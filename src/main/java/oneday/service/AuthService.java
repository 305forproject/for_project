package oneday.service;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import oneday.model.User;
import oneday.repository.UserDAO;
import oneday.util.DatabaseTransactionUtil;

/**
 * 사용자 인증 및 사용자 정보 관리 서비스 클래스
 *
 * <p>이 클래스는 로그인 인증과 사용자 정보 조회를 위한 비즈니스 로직을 제공합니다.
 * UserDAO를 통해 데이터베이스에 접근하며, 예외 처리를 담당합니다.</p>
 *
 * <p>주요 기능:</p>
 * <ul>
 *   <li>로그인 인증 처리</li>
 *   <li>사용자 ID를 통한 사용자 정보 조회</li>
 *   <li>데이터베이스 접근 예외 처리</li>
 * </ul>
 *
 * @author Oneday Team
 * @version 1.0
 * @since 2024
 */
public class AuthService {
	/** 사용자 데이터 접근을 위한 DAO 인스턴스 */
	private final UserDAO userDAO = new UserDAO();

	/** 역할 ID 상수 */
	private static final int TEACHER_ROLE_ID = 1;

	/**
	 * 사용자 로그인을 인증합니다.
	 *
	 * <p>주어진 로그인 ID와 비밀번호를 통해 사용자를 인증합니다.
	 * 데이터베이스 접근 중 발생하는 예외를 처리하고,
	 * 인증 실패 시 null을 반환합니다.</p>
	 *
	 * @param loginId 사용자의 로그인 ID
	 * @param password 사용자의 비밀번호
	 * @return 인증된 사용자 객체, 인증 실패 또는 오류 시 null
	 */
	public User authenticate(String loginId, String password) {
		try {
			return userDAO.findByLoginIdAndPassword(loginId, password);
		} catch (SQLException e) {
			e.printStackTrace();
			return null;
		}
	}

	/**
	 * 사용자 ID로 사용자 정보를 조회합니다.
	 *
	 * <p>세션에 저장된 사용자 ID를 통해 사용자의 전체 정보를 조회할 때 사용됩니다.
	 * 데이터베이스 접근 중 발생하는 예외를 처리합니다.</p>
	 *
	 * @param userId 조회할 사용자의 고유 ID
	 * @return 사용자 객체, 조회 실패 또는 오류 시 null
	 */
	public User getUserById(int userId) {
		try {
			return userDAO.findById(userId);
		} catch (SQLException e) {
			e.printStackTrace();
			return null;
		}
	}

	/**
	 * 사용자에게 선생님 롤을 부여합니다.
	 * @param userId 사용자 ID
	 * @return 롤 부여 성공 여부
	 */
	public boolean createTeacherRole(int userId) {
		return DatabaseTransactionUtil.executeTransactionForBoolean(conn -> {
			// 이미 선생님 롤이 있는지 확인
			if (hasTeacherRole(conn, userId)) {
				return true; // 이미 존재함
			}

			// 선생님 롤 생성
			return insertTeacherRole(conn, userId);
		});
	}

	/**
	 * 강사 계좌번호 등록 및 강사 역할 부여
	 *
	 * @param userId 사용자 ID
	 * @param accountNumber 계좌번호
	 * @return 성공 시 true, 실패 시 false
	 * @throws SQLException 데이터베이스 오류 시
	 */
	public boolean registerTeacherAccount(int userId, String accountNumber) throws SQLException {
		return userDAO.registerTeacherAccount(userId, accountNumber);
	}

	/**
	 * 사용자가 선생님 롤을 가지고 있는지 확인합니다.
	 */
	private boolean hasTeacherRole(Connection conn, int userId) {
		String sql = "SELECT COUNT(*) FROM USER_ROLE WHERE USER_ID = ? AND ROLE_ID = ?";

		try (PreparedStatement stmt = conn.prepareStatement(sql)) {
			stmt.setInt(1, userId);
			stmt.setInt(2, TEACHER_ROLE_ID);
			try (ResultSet rs = stmt.executeQuery()) {
				return rs.next() && rs.getInt(1) > 0;
			}
		} catch (SQLException e) {
			throw new RuntimeException("선생님 롤 확인 중 오류가 발생했습니다.", e);
		}
	}

	/**
	 * 사용자에게 선생님 롤을 삽입합니다.
	 */
	private boolean insertTeacherRole(Connection conn, int userId) {
		String sql = "INSERT INTO USER_ROLE (USER_ID, ROLE_ID) VALUES (?, ?)";

		try (PreparedStatement stmt = conn.prepareStatement(sql)) {
			stmt.setInt(1, userId);
			stmt.setInt(2, TEACHER_ROLE_ID);
			return stmt.executeUpdate() > 0;
		} catch (SQLException e) {
			throw new RuntimeException("선생님 롤 생성 중 오류가 발생했습니다.", e);
		}
	}
}
