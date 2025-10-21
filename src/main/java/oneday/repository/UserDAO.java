package oneday.repository;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import oneday.config.DatabaseConfig;
import oneday.model.Role;
import oneday.model.User;
import oneday.util.DatabaseTransactionUtil;

/**
 * 사용자 데이터 접근 객체 (Data Access Object)
 *
 * <p>이 클래스는 USERS 테이블과 USER_ROLE 테이블에 대한 데이터베이스 작업을 담당합니다.
 * 회원가입, 로그인 검증, 사용자 정보 조회 등의 기능을 제공합니다.</p>
 *
 * <p>주요 기능:</p>
 * <ul>
 *   <li>아이디 중복 검사</li>
 *   <li>회원가입 처리 (트랜잭션 관리)</li>
 *   <li>사용자 역할 할당</li>
 *   <li>사용자 역할 조회</li>
 * </ul>
 *
 * <p>트랜잭션 관리:</p>
 * <p>회원가입 과정에서 USERS 테이블과 USER_ROLE 테이블에 동시에 데이터를 삽입해야 하므로,
 * 트랜잭션을 사용하여 데이터 일관성을 보장합니다.</p>
 *
 * <p>사용 예제:</p>
 * <pre>{@code
 * UserDAO userDAO = new UserDAO();
 *
 * // 아이디 중복 검사
 * if (!userDAO.isLoginIdExists("testuser")) {
 *     // 회원가입 처리
 *     User newUser = new User("testuser", "password", "홍길동");
 *     boolean success = userDAO.signup(newUser);
 * }
 * }</pre>
 *
 * @author Oneday Team
 * @version 1.0
 * @since 2024
 */
public class UserDAO {

	/** 데이터베이스 설정 싱글톤 인스턴스 */
	private final DatabaseConfig dbConfig;

	/** 회원가입 시 기본으로 부여되는 역할 (학생) */
	private static final Role DEFAULT_SIGNUP_ROLE = Role.STUDENT;

	/**
	 * UserDAO 생성자
	 *
	 * <p>DatabaseConfig 싱글톤 인스턴스를 초기화합니다.</p>
	 */
	public UserDAO() {
		this.dbConfig = DatabaseConfig.getInstance();
	}

	/**
	 * 주어진 로그인 아이디가 이미 존재하는지 확인합니다.
	 *
	 * <p>회원가입 전에 아이디 중복을 검사할 때 사용됩니다.
	 * COUNT 쿼리를 사용하여 효율적으로 중복 여부를 확인합니다.</p>
	 *
	 * @param loginId 확인할 로그인 아이디
	 * @return 이미 존재하면 true, 존재하지 않으면 false
	 * @throws SQLException 데이터베이스 접근 중 오류가 발생한 경우
	 */
	public boolean isLoginIdExists(String loginId) throws SQLException {
		String sql = "SELECT COUNT(*) FROM USERS WHERE LOGIN_ID = ?";

		try (Connection conn = dbConfig.getConnection();
			 PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setString(1, loginId);

			try (ResultSet rs = pstmt.executeQuery()) {
				if (rs.next()) {
					return rs.getInt(1) > 0;
				}
			}
		}
		return false;
	}

	/**
	 * 기본 역할(학생)로 회원가입을 처리합니다.
	 *
	 * <p>이 메서드는 {@link #signupWithRole(User, Role)} 메서드를
	 * 기본 역할(STUDENT)로 호출하는 편의 메서드입니다.</p>
	 *
	 * @param user 회원가입할 사용자 정보
	 * @return 성공 시 true, 실패 시 false
	 * @throws SQLException 데이터베이스 처리 중 오류가 발생한 경우
	 * @see #signupWithRole(User, Role)
	 */
	public boolean signup(User user) throws SQLException {
		return signupWithRole(user, DEFAULT_SIGNUP_ROLE);
	}

	/**
	 * 지정된 역할로 회원가입을 처리합니다.
	 *
	 * <p>이 메서드는 트랜잭션을 사용하여 다음 작업을 원자적으로 수행합니다:</p>
	 * <ol>
	 *   <li>USERS 테이블에 사용자 정보 삽입</li>
	 *   <li>생성된 USER_ID 획득</li>
	 *   <li>USER_ROLE 테이블에 역할 정보 삽입</li>
	 * </ol>
	 *
	 * <p>중간에 오류가 발생하면 모든 변경사항이 롤백됩니다.</p>
	 *
	 * @param user 회원가입할 사용자 정보
	 * @param role 부여할 역할 (TEACHER 또는 STUDENT)
	 * @return 성공 시 true, 실패 시 false
	 * @throws SQLException 데이터베이스 처리 중 오류가 발생한 경우
	 */
	public boolean signupWithRole(User user, Role role) throws SQLException {
		try (Connection conn = dbConfig.getConnection()) {
			conn.setAutoCommit(false);  // 트랜잭션 시작

			try {
				// 1. 사용자 생성 및 ID 반환
				int userId = createUser(conn, user);

				// 2. 사용자 역할 할당
				assignUserRole(conn, userId, role);

				conn.commit();  // 트랜잭션 커밋
				return true;

			} catch (SQLException e) {
				conn.rollback();  // 오류 시 롤백
				throw new SQLException("회원가입 처리 실패: " + e.getMessage(), e);
			} finally {
				conn.setAutoCommit(true);  // AutoCommit 복원
			}
		}
	}

	/**
	 * USERS 테이블에 새로운 사용자 정보를 삽입합니다.
	 *
	 * <p>이 메서드는 {@link #signupWithRole(User, Role)} 메서드에서
	 * 내부적으로 호출되는 헬퍼 메서드입니다.</p>
	 *
	 * <p>삽입 후 자동 생성된 USER_ID를 반환합니다.</p>
	 *
	 * @param conn 데이터베이스 연결 (트랜잭션 컨텍스트)
	 * @param user 삽입할 사용자 정보
	 * @return 생성된 USER_ID
	 * @throws SQLException 사용자 생성 실패 시
	 */
	private int createUser(Connection conn, User user) throws SQLException {
		String sql = "INSERT INTO USERS (LOGIN_ID, PASSWORD, NAME, ACCOUNT) VALUES (?, ?, ?, ?)";

		try (PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
			pstmt.setString(1, user.getLoginId());
			pstmt.setString(2, user.getPassword());
			pstmt.setString(3, user.getName());
			pstmt.setString(4, "");  // 계좌번호는 빈 문자열

			int affectedRows = pstmt.executeUpdate();
			if (affectedRows == 0) {
				throw new SQLException("사용자 생성 실패: 행이 삽입되지 않았습니다.");
			}

			return extractGeneratedUserId(pstmt);
		}
	}

	/**
	 * PreparedStatement에서 자동 생성된 USER_ID를 추출합니다.
	 *
	 * <p>이 메서드는 {@link #createUser(Connection, User)} 메서드에서
	 * 사용자 생성 후 생성된 기본키를 가져오기 위해 사용됩니다.</p>
	 *
	 * @param pstmt 실행된 PreparedStatement (RETURN_GENERATED_KEYS 옵션 필요)
	 * @return 생성된 USER_ID
	 * @throws SQLException USER_ID 추출 실패 시
	 */
	private int extractGeneratedUserId(PreparedStatement pstmt) throws SQLException {
		try (ResultSet rs = pstmt.getGeneratedKeys()) {
			if (rs.next()) {
				return rs.getInt(1);
			} else {
				throw new SQLException("USER_ID 생성 실패: 키를 가져올 수 없습니다.");
			}
		}
	}

	/**
	 * USER_ROLE 테이블에 사용자와 역할의 매핑 정보를 삽입합니다.
	 *
	 * <p>이 메서드는 {@link #signupWithRole(User, Role)} 메서드에서
	 * 사용자 생성 후 역할을 할당하기 위해 사용됩니다.</p>
	 *
	 * @param conn 데이터베이스 연결 (트랜잭션 컨텍스트)
	 * @param userId 역할을 할당받을 사용자 ID
	 * @param role 할당할 역할 (TEACHER 또는 STUDENT)
	 * @throws SQLException 역할 할당 실패 시
	 */
	private void assignUserRole(Connection conn, int userId, Role role) throws SQLException {
		String sql = "INSERT INTO USER_ROLE (USER_ID, ROLE_ID) VALUES (?, ?)";

		try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
			pstmt.setInt(1, userId);
			pstmt.setInt(2, role.getRoleId());

			int affectedRows = pstmt.executeUpdate();
			if (affectedRows == 0) {
				throw new SQLException("사용자 역할 할당 실패: " + role.getDisplayName());
			}
		}
	}

	/**
	 * 주어진 사용자 ID에 할당된 역할을 조회합니다.
	 *
	 * <p>USER_ROLE 테이블과 ROLES 테이블을 조인하여
	 * 사용자에게 할당된 역할 정보를 가져옵니다.</p>
	 *
	 * <p>현재는 사용자당 하나의 역할만 지원하므로 첫 번째 역할을 반환합니다.
	 * 향후 다중 역할을 지원할 경우 이 메서드를 수정해야 할 수 있습니다.</p>
	 *
	 * @param userId 역할을 조회할 사용자 ID
	 * @return 사용자의 역할 (Role Enum), 역할이 없으면 null
	 * @throws SQLException 데이터베이스 접근 중 오류가 발생한 경우
	 */
	public Role getUserRole(int userId) throws SQLException {
		String sql = "SELECT r.ROLE_ID, r.ROLE_NAME FROM USER_ROLE ur " +
			"JOIN ROLES r ON ur.ROLE_ID = r.ROLE_ID " +
			"WHERE ur.USER_ID = ?";

		try (Connection conn = dbConfig.getConnection();
			 PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setInt(1, userId);

			try (ResultSet rs = pstmt.executeQuery()) {
				if (rs.next()) {
					int roleId = rs.getInt("ROLE_ID");
					return Role.findByRoleId(roleId);
				}
			}
		}
		return null;
	}

	/**
	 * 로그인 ID와 비밀번호로 사용자를 인증합니다.
	 *
	 * <p>USERS 테이블에서 주어진 로그인 ID와 비밀번호가 일치하는
	 * 사용자를 찾아 반환합니다. 일치하는 사용자가 없으면 null을 반환합니다.</p>
	 *
	 * @param loginId 사용자의 로그인 ID
	 * @param password 사용자의 비밀번호
	 * @return 인증된 사용자 객체, 인증 실패 시 null
	 * @throws SQLException 데이터베이스 접근 중 오류가 발생한 경우
	 */
	public User findByLoginIdAndPassword(String loginId, String password) throws SQLException {
		String sql = "SELECT USER_ID, LOGIN_ID, PASSWORD, NAME, ACCOUNT FROM USERS WHERE LOGIN_ID = ? AND PASSWORD = ?";

		try (Connection conn = dbConfig.getConnection();
			 PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setString(1, loginId);
			pstmt.setString(2, password);

			try (ResultSet rs = pstmt.executeQuery()) {
				if (rs.next()) {
					User user = new User();
					user.setUserId(rs.getInt("USER_ID"));
					user.setLoginId(rs.getString("LOGIN_ID"));
					user.setPassword(rs.getString("PASSWORD"));
					user.setName(rs.getString("NAME"));
					user.setAccount(rs.getString("ACCOUNT"));
					return user;
				}
			}
		}
		return null;
	}

	/**
	 * 사용자 ID로 사용자 정보를 조회합니다.
	 *
	 * <p>주로 세션에 저장된 사용자 ID를 통해 사용자의 전체 정보를
	 * 다시 조회할 때 사용됩니다.</p>
	 *
	 * @param userId 조회할 사용자의 고유 ID
	 * @return 사용자 객체, 존재하지 않으면 null
	 * @throws SQLException 데이터베이스 접근 중 오류가 발생한 경우
	 */
	public User findById(int userId) throws SQLException {
		String sql = "SELECT USER_ID, LOGIN_ID, PASSWORD, NAME, ACCOUNT FROM USERS WHERE USER_ID = ?";

		try (Connection conn = dbConfig.getConnection();
			 PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setInt(1, userId);

			try (ResultSet rs = pstmt.executeQuery()) {
				if (rs.next()) {
					User user = new User();
					user.setUserId(rs.getInt("USER_ID"));
					user.setLoginId(rs.getString("LOGIN_ID"));
					user.setPassword(rs.getString("PASSWORD"));
					user.setName(rs.getString("NAME"));
					user.setAccount(rs.getString("ACCOUNT"));
					return user;
				}
			}
		}
		return null;
	}

	/**
	 * 주어진 사용자 ID에 할당된 모든 역할을 조회합니다.
	 *
	 * <p>USER_ROLE 테이블과 ROLES 테이블을 조인하여
	 * 사용자에게 할당된 모든 역할 정보를 가져옵니다.</p>
	 *
	 * <p>한 사용자가 여러 역할을 가질 수 있으므로 모든 역할을 리스트로 반환합니다.</p>
	 *
	 * @param userId 역할을 조회할 사용자 ID
	 * @return 사용자의 모든 역할 목록 (Role Enum), 역할이 없으면 빈 리스트
	 * @throws SQLException 데이터베이스 접근 중 오류가 발생한 경우
	 */
	public List<Role> getUserRoles(int userId) throws SQLException {
		String sql = "SELECT r.ROLE_ID, r.ROLE_NAME FROM USER_ROLE ur " +
			"JOIN ROLES r ON ur.ROLE_ID = r.ROLE_ID " +
			"WHERE ur.USER_ID = ?";

		List<Role> roles = new ArrayList<>();

		try (Connection conn = dbConfig.getConnection();
			 PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setInt(1, userId);

			try (ResultSet rs = pstmt.executeQuery()) {
				while (rs.next()) {
					int roleId = rs.getInt("ROLE_ID");
					Role role = Role.findByRoleId(roleId);
					if (role != null) {
						roles.add(role);
					}
				}
			}
		}
		return roles;
	}

	/**
	 * 사용자 계좌번호 업데이트 (Connection 사용)
	 *
	 * @param conn 데이터베이스 연결
	 * @param userId 사용자 ID
	 * @param accountNumber 계좌번호
	 * @return 성공 시 true, 실패 시 false
	 * @throws SQLException 데이터베이스 오류 시
	 */
	public boolean updateUserAccount(Connection conn, int userId, String accountNumber) throws SQLException {
		String sql = "UPDATE USERS SET ACCOUNT = ? WHERE USER_ID = ?";

		try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
			pstmt.setString(1, accountNumber);
			pstmt.setInt(2, userId);

			int affectedRows = pstmt.executeUpdate();
			return affectedRows > 0;
		}
	}

	/**
	 * 사용자에게 특정 역할 추가 (Connection 사용)
	 *
	 * @param conn 데이터베이스 연결
	 * @param userId 사용자 ID
	 * @param roleId 추가할 역할 ID
	 * @return 성공 시 true, 실패 시 false
	 * @throws SQLException 데이터베이스 오류 시
	 */
	public boolean addUserRole(Connection conn, int userId, int roleId) throws SQLException {
		// 이미 해당 역할이 있는지 확인
		if (hasUserRole(conn, userId, roleId)) {
			return true; // 이미 역할이 있으면 성공으로 처리
		}

		String sql = "INSERT INTO USER_ROLE (USER_ID, ROLE_ID) VALUES (?, ?)";

		try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
			pstmt.setInt(1, userId);
			pstmt.setInt(2, roleId);

			int affectedRows = pstmt.executeUpdate();
			return affectedRows > 0;
		}
	}

	/**
	 * 사용자가 특정 역할을 가지고 있는지 확인 (Connection 사용)
	 *
	 * @param conn 데이터베이스 연결
	 * @param userId 사용자 ID
	 * @param roleId 확인할 역할 ID
	 * @return 역할이 있으면 true, 없으면 false
	 * @throws SQLException 데이터베이스 오류 시
	 */
	public boolean hasUserRole(Connection conn, int userId, int roleId) throws SQLException {
		String sql = "SELECT COUNT(*) FROM USER_ROLE WHERE USER_ID = ? AND ROLE_ID = ?";

		try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
			pstmt.setInt(1, userId);
			pstmt.setInt(2, roleId);

			try (ResultSet rs = pstmt.executeQuery()) {
				if (rs.next()) {
					return rs.getInt(1) > 0;
				}
			}
		}
		return false;
	}

	/**
	 * 강사 계좌번호 등록 및 강사 역할 부여 (트랜잭션 처리)
	 *
	 * @param userId 사용자 ID
	 * @param accountNumber 계좌번호
	 * @return 성공 시 true, 실패 시 false
	 * @throws SQLException 데이터베이스 오류 시
	 */
	public boolean registerTeacherAccount(int userId, String accountNumber) throws SQLException {
		return DatabaseTransactionUtil.executeTransactionForBoolean(conn -> {
			try {
				// 1. 계좌번호 업데이트
				boolean accountUpdated = updateUserAccount(conn, userId, accountNumber);
				if (!accountUpdated) {
					throw new RuntimeException("계좌번호 업데이트 실패");
				}

				// 2. 강사 역할이 있는지 확인하고 없으면 추가
				final int TEACHER_ROLE_ID = 1;
				if (!hasUserRole(conn, userId, TEACHER_ROLE_ID)) {
					boolean roleAdded = addUserRole(conn, userId, TEACHER_ROLE_ID);
					if (!roleAdded) {
						throw new RuntimeException("강사 역할 추가 실패");
					}
				}

				return true;

			} catch (SQLException e) {
				throw new RuntimeException("강사 계좌번호 등록 실패: " + e.getMessage(), e);
			}
		});
	}
}
