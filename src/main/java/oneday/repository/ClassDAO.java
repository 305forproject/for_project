package oneday.repository;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import oneday.config.DatabaseConfig;
import oneday.dto.ClassListDto;
import oneday.dto.TeacherCalendarDto;
import oneday.dto.TeacherClassDetailDto;
import oneday.model.Classes;

/**
 * 클래스 관련 데이터베이스 접근 객체 (DAO)
 * 클래스의 생성, 조회, 수정, 삭제 등의 데이터베이스 작업을 담당
 */
public class ClassDAO {
	private final DatabaseConfig dbConfig;

	/**
	 * ClassDAO 생성자
	 * DatabaseConfig 싱글톤 인스턴스를 초기화
	 */
	public ClassDAO() {
		this.dbConfig = DatabaseConfig.getInstance();
	}

	/**
	 * 클래스 ID로 수업 정보를 조회
	 *
	 * @param classId 조회할 클래스 ID
	 * @return 클래스 상세 정보가 담긴 TeacherClassDetailDto 객체, 조회 실패 시 null
	 * @throws SQLException 데이터베이스 접근 중 오류 발생 시
	 */
	public TeacherClassDetailDto findById(int classId) throws SQLException {
		TeacherClassDetailDto dto = null;
		String sql = "SELECT c.*, u.NAME as teacher_name, " +
			"       (SELECT COUNT(*) FROM RESERVATIONS r WHERE r.CLASS_ID = c.CLASS_ID) as current_reservation_count " +
			"FROM CLASSES c " +
			"JOIN USERS u ON c.TEACHER_ID = u.USER_ID " +
			"WHERE c.CLASS_ID = ?";

		try (Connection conn = dbConfig.getConnection();
			 PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setInt(1, classId);
			try (ResultSet rs = pstmt.executeQuery()) {
				if (rs.next()) {
					dto = new TeacherClassDetailDto();

					dto.setClassId(rs.getInt("CLASS_ID"));
					dto.setCategoryId(rs.getInt("CATEGORY_ID"));
					dto.setClassName(rs.getString("CLASS_NAME"));
					dto.setClassDetail(rs.getString("CLASS_DETAIL"));
					dto.setStartAt(rs.getTimestamp("START_AT").toLocalDateTime());
					dto.setEndAt(rs.getTimestamp("END_AT").toLocalDateTime());
					dto.setLongitude(rs.getString("LONGITUDE"));
					dto.setLatitude(rs.getString("LATITUDE"));
					dto.setLocation(rs.getString("LOCATION"));
					dto.setMaxCapacity(rs.getInt("MAX_CAPACITY"));
					dto.setPrice(rs.getInt("PRICE"));
					dto.setTeacherName(rs.getString("teacher_name"));
					dto.setCurrentReservationCount(rs.getInt("current_reservation_count"));
				}
			}
		}
		return dto;
	}

	/**
	 * 강사 ID와 년월로 달력 이벤트 조회
	 *
	 * @param teacherId 강사 ID
	 * @param year 조회할 년도
	 * @param month 조회할 월
	 * @return 해당 년월의 강사 클래스 목록
	 * @throws SQLException 데이터베이스 접근 중 오류 발생 시
	 */
	public List<TeacherCalendarDto> findCalendarEventsByTeacherIdAndMonth(int teacherId, int year, int month) throws
		SQLException {
		List<TeacherCalendarDto> events = new ArrayList<>();
		String sql = "SELECT c.CLASS_ID, c.START_AT, c.END_AT, c.MAX_CAPACITY, " +
			"(SELECT COUNT(*) FROM RESERVATIONS r WHERE r.CLASS_ID = c.CLASS_ID) as current_count " +
			"FROM CLASSES c " +
			"WHERE c.TEACHER_ID = ? AND YEAR(c.START_AT) = ? AND MONTH(c.START_AT) = ?";

		try (Connection conn = dbConfig.getConnection();
			 PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setInt(1, teacherId);
			pstmt.setInt(2, year);
			pstmt.setInt(3, month);

			try (ResultSet rs = pstmt.executeQuery()) {
				while (rs.next()) {
					TeacherCalendarDto dto = new TeacherCalendarDto();
					dto.setClassId(rs.getInt("CLASS_ID"));
					dto.setStartAt(rs.getTimestamp("START_AT").toLocalDateTime());
					dto.setEndAt(rs.getTimestamp("END_AT").toLocalDateTime());
					dto.setMaxCapacity(rs.getInt("MAX_CAPACITY"));
					dto.setCurrentReservationCount(rs.getInt("current_count"));
					events.add(dto);
				}
			}
		}
		return events;
	}

	/**
	 * 클래스 ID와 강사 ID로 클래스 상세 정보 조회
	 * 강사 본인의 클래스만 조회 가능
	 *
	 * @param classId 조회할 클래스 ID
	 * @param teacherId 강사 ID
	 * @return 클래스 상세 정보, 조회 실패 시 null
	 * @throws SQLException 데이터베이스 접근 중 오류 발생 시
	 */
	public TeacherClassDetailDto findDetailByClassIdAndTeacherId(int classId, int teacherId) throws SQLException {
		TeacherClassDetailDto dto = null;
		String sql = "SELECT c.CLASS_NAME, c.START_AT, c.END_AT, c.LOCATION, c.MAX_CAPACITY, " +
			"(SELECT COUNT(*) FROM RESERVATIONS r WHERE r.CLASS_ID = c.CLASS_ID) as current_count " +
			"FROM CLASSES c " +
			"WHERE c.CLASS_ID = ? AND c.TEACHER_ID = ?";

		try (Connection conn = dbConfig.getConnection();
			 PreparedStatement pstmt = conn.prepareStatement(sql)) {
			pstmt.setInt(1, classId);
			pstmt.setInt(2, teacherId);
			try (ResultSet rs = pstmt.executeQuery()) {
				if (rs.next()) {
					dto = new TeacherClassDetailDto();
					dto.setClassName(rs.getString("CLASS_NAME"));
					dto.setStartAt(rs.getTimestamp("START_AT").toLocalDateTime());
					dto.setEndAt(rs.getTimestamp("END_AT").toLocalDateTime());
					dto.setLocation(rs.getString("LOCATION"));
					dto.setMaxCapacity(rs.getInt("MAX_CAPACITY"));
					dto.setCurrentReservationCount(rs.getInt("current_count"));
				}
			}
		}
		return dto;
	}

	/**
	 * 새로운 클래스를 데이터베이스에 등록
	 *
	 * @param classes 등록할 클래스 정보가 담긴 Classes 객체
	 * @return 등록 성공 시 true, 실패 시 false
	 * @throws SQLException 데이터베이스 접근 중 오류 발생 시
	 */
	public boolean insertClass(Classes classes) throws SQLException {
		String sql = "INSERT INTO CLASSES (TEACHER_ID, CATEGORY_ID, CLASS_NAME, CLASS_DETAIL, " +
			"START_AT, END_AT, LONGITUDE, LATITUDE, LOCATION, MAX_CAPACITY, PRICE) " +
			"VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

		try (Connection conn = dbConfig.getConnection();
			 PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setInt(1, classes.getTeacherId());
			pstmt.setInt(2, classes.getCategoryId());
			pstmt.setString(3, classes.getClassName());
			pstmt.setString(4, classes.getClassDetail());
			pstmt.setTimestamp(5, java.sql.Timestamp.valueOf(classes.getStartAt()));
			pstmt.setTimestamp(6, java.sql.Timestamp.valueOf(classes.getEndAt()));
			pstmt.setString(7, classes.getLongitude());
			pstmt.setString(8, classes.getLatitude());
			pstmt.setString(9, classes.getLocation());
			pstmt.setInt(10, classes.getMaxCapacity());
			pstmt.setInt(11, classes.getPrice());

			int rowsAffected = pstmt.executeUpdate();
			return rowsAffected > 0;
		}
	}

	/**
	 * 메인 페이지용 강의 목록을 최신순으로 조회 (대표 이미지 포함)
	 *
	 * @return 최신순으로 정렬된 강의 목록 (대표 이미지 URL 포함)
	 * @throws SQLException 데이터베이스 오류 발생 시
	 */
	public List<ClassListDto> findAllClassListOrderByNewest() throws SQLException {
		List<ClassListDto> classList = new ArrayList<>();
		String sql = """
			SELECT c.CLASS_ID, c.CLASS_NAME, u.NAME as TEACHER_NAME, c.PRICE,
				   DATE_FORMAT(c.START_AT, '%Y-%m-%d %H:%i') as START_AT, c.LOCATION,
				   i.IMAGE_URL as REPRESENTATIVE_IMAGE_URL,
				   cat.CATEGORY as CATEGORY_NAME
			FROM CLASSES c
			JOIN USERS u ON c.TEACHER_ID = u.USER_ID
			JOIN CATEGORIES cat ON c.CATEGORY_ID = cat.CATEGORY_ID
			LEFT JOIN IMAGES i ON c.CLASS_ID = i.CLASS_ID AND i.IS_REPRESENTATIVE = 1
			ORDER BY c.CLASS_ID DESC
			""";

		try (Connection conn = dbConfig.getConnection();
			 PreparedStatement pstmt = conn.prepareStatement(sql);
			 ResultSet rs = pstmt.executeQuery()) {

			while (rs.next()) {
				ClassListDto dto = new ClassListDto();
				dto.setClassId(rs.getInt("CLASS_ID"));
				dto.setClassName(rs.getString("CLASS_NAME"));
				dto.setTeacherName(rs.getString("TEACHER_NAME"));
				dto.setPrice(rs.getInt("PRICE"));
				dto.setStartAt(rs.getString("START_AT"));
				dto.setLocation(rs.getString("LOCATION"));

				String imageUrl = rs.getString("REPRESENTATIVE_IMAGE_URL");
				dto.setRepresentativeImageUrl(imageUrl != null ? imageUrl : "/images/default-class.jpg");

				classList.add(dto);
			}
		}
		return classList;
	}

	/**
	 * 새로운 클래스를 등록하고 생성된 ID를 반환
	 *
	 * @param conn 데이터베이스 연결 객체
	 * @param classes 등록할 클래스 정보
	 * @return 생성된 클래스 ID, 실패 시 0
	 * @throws SQLException 데이터베이스 오류 발생 시
	 */
	public int insertClassAndGetId(Connection conn, Classes classes) throws SQLException {
		String sql = "INSERT INTO CLASSES (TEACHER_ID, CATEGORY_ID, CLASS_NAME, CLASS_DETAIL, " +
			"START_AT, END_AT, LONGITUDE, LATITUDE, LOCATION, MAX_CAPACITY, PRICE) " +
			"VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

		try (PreparedStatement pstmt = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
			pstmt.setInt(1, classes.getTeacherId());
			pstmt.setInt(2, classes.getCategoryId());
			pstmt.setString(3, classes.getClassName());
			pstmt.setString(4, classes.getClassDetail());
			pstmt.setTimestamp(5, java.sql.Timestamp.valueOf(classes.getStartAt()));
			pstmt.setTimestamp(6, java.sql.Timestamp.valueOf(classes.getEndAt()));
			pstmt.setString(7, classes.getLongitude());
			pstmt.setString(8, classes.getLatitude());
			pstmt.setString(9, classes.getLocation());
			pstmt.setInt(10, classes.getMaxCapacity());
			pstmt.setInt(11, classes.getPrice());

			int rowsAffected = pstmt.executeUpdate();
			if (rowsAffected > 0) {
				try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
					if (generatedKeys.next()) {
						return generatedKeys.getInt(1);
					}
				}
			}
			return 0;
		}
	}
}
