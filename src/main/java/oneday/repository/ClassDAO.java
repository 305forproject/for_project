package oneday.repository;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

import oneday.config.DatabaseConfig;
import oneday.dto.ClassDetailDto;
import oneday.dto.ClassListDto;
import oneday.dto.FullCalendarEventDto;
import oneday.dto.TeacherCalendarDto;
import oneday.dto.TeacherClassDetailDto;
import oneday.model.Category;
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

	//날짜로 달력 조회
	public List<FullCalendarEventDto> findEventsForCalendarByTeacher(int teacherId, String startDate,
		String endDate) throws SQLException {
		List<FullCalendarEventDto> events = new ArrayList<>();

		String sql = "SELECT CLASS_ID, CLASS_NAME, START_AT " +
			"FROM CLASSES " +
			"WHERE TEACHER_ID = ? AND START_AT >= ? AND START_AT < ?";

		try (Connection conn = dbConfig.getConnection();
			 PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setInt(1, teacherId);
			pstmt.setString(2, startDate);
			pstmt.setString(3, endDate);

			DateTimeFormatter formatter = DateTimeFormatter.ofPattern("h:mm a");

			try (ResultSet rs = pstmt.executeQuery()) {
				while (rs.next()) {
					FullCalendarEventDto dto = new FullCalendarEventDto();
					dto.setId(String.valueOf(rs.getInt("CLASS_ID")));

					// 3. 시작 시간과 종료 시간을 LocalDateTime 객체
					LocalDateTime startAt = rs.getTimestamp("START_AT").toLocalDateTime();

					// 4. 각 시간을 지정된 형식의 문자열로 변환
					String formattedStartTime = startAt.format(formatter);

					dto.setTitle(formattedStartTime);

					dto.setStart(startAt.toString());

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
	 * @return 클래스 상세 정보, 조회 실패 시 null
	 * @throws SQLException 데이터베이스 접근 중 오류 발생 시
	 */
	public TeacherClassDetailDto findDetailByClassIdAndTeacherId(int classId) throws SQLException {
		TeacherClassDetailDto dto = null;
		String sql = "SELECT c.CLASS_NAME, c.START_AT, c.END_AT, c.LOCATION, c.MAX_CAPACITY, " +
			"       c.LATITUDE, c.LONGITUDE, cat.CATEGORY, " +
			"       (SELECT COUNT(*) FROM RESERVATIONS r WHERE r.CLASS_ID = c.CLASS_ID) as current_count " +
			"FROM CLASSES c " +
			"JOIN CATEGORIES cat ON c.CATEGORY_ID = cat.CATEGORY_ID " +
			"WHERE c.CLASS_ID = ?";

		try (Connection conn = dbConfig.getConnection();
			 PreparedStatement pstmt = conn.prepareStatement(sql)) {
			pstmt.setInt(1, classId);
			try (ResultSet rs = pstmt.executeQuery()) {
				if (rs.next()) {
					dto = new TeacherClassDetailDto();
					dto.setClassName(rs.getString("CLASS_NAME"));
					dto.setStartAt(rs.getTimestamp("START_AT").toLocalDateTime());
					dto.setEndAt(rs.getTimestamp("END_AT").toLocalDateTime());
					dto.setLocation(rs.getString("LOCATION"));
					dto.setMaxCapacity(rs.getInt("MAX_CAPACITY"));
					dto.setCurrentReservationCount(rs.getInt("current_count"));
					dto.setCategoryName(rs.getString("CATEGORY"));
					dto.setLatitude(rs.getString("LATITUDE"));
					dto.setLongitude(rs.getString("LONGITUDE"));
				}
			}
		}
		return dto;
	}

	/**
	 * ID로 클래스 상세 정보를 조회합니다. (강사 이름, 현재 예약 인원 포함)
	 */
	public ClassDetailDto findDetailById(int classId) throws SQLException {
		ClassDetailDto dto = null;
		// SQL 쿼리: USERS 테이블을 JOIN하고, 서브쿼리로 예약 인원을 계산합니다.
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
					dto = new ClassDetailDto();
					dto.setClassId(rs.getInt("CLASS_ID"));
					dto.setCategoryId(rs.getInt("CATEGORY_ID"));
					dto.setClassName(rs.getString("CLASS_NAME"));
					dto.setDescription(rs.getString("CLASS_DETAIL"));
					dto.setStartAt(rs.getTimestamp("START_AT").toLocalDateTime());
					dto.setEndAt(rs.getTimestamp("END_AT").toLocalDateTime());
					dto.setLongitude(rs.getString("LONGITUDE"));
					dto.setLatitude(rs.getString("LATITUDE"));
					dto.setLocation(rs.getString("LOCATION"));
					dto.setMaxStudents(rs.getInt("MAX_CAPACITY"));
					dto.setPrice(rs.getInt("PRICE"));
					dto.setTeacherName(rs.getString("teacher_name"));
					dto.setCurrentReservationCount(rs.getInt("current_reservation_count"));
				}
			}
		}
		return dto;
	}

	/**
	 * ID로 특정 강의 정보를 조회합니다.
	 * @param classId 조회할 강의의 ID
	 * @return 조회된 강의 정보가 담긴 Classes 객체. 해당하는 강의가 없으면 null을 반환합니다.
	 * @throws SQLException 데이터베이스 접근 중 오류가 발생한 경우
	 */
	public Classes findById(Connection conn, int classId) throws SQLException {
		Classes cls = null;
		String sql = "SELECT * FROM CLASSES WHERE CLASS_ID = ?";

		try (PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setInt(1, classId);
			try (ResultSet rs = pstmt.executeQuery()) {
				if (rs.next()) {
					cls = new Classes();
					cls.setClassId(rs.getInt("CLASS_ID"));
					cls.setTeacherId(rs.getInt("TEACHER_ID"));
					cls.setCategoryId(rs.getInt("CATEGORY_ID"));
					cls.setClassName(rs.getString("CLASS_NAME"));
					cls.setClassDetail(rs.getString("CLASS_DETAIL"));
					cls.setStartAt(rs.getTimestamp("START_AT").toLocalDateTime());
					cls.setEndAt(rs.getTimestamp("END_AT").toLocalDateTime());
					cls.setLongitude(rs.getString("LONGITUDE"));
					cls.setLatitude(rs.getString("LATITUDE"));
					cls.setLocation(rs.getString("LOCATION"));
					cls.setMaxCapacity(rs.getInt("MAX_CAPACITY"));
					cls.setPrice(rs.getInt("PRICE"));
				}
			}
		}
		return cls;
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
			"START_AT, END_AT, LONGITUDE, LATITUDE, LOCATION, ZIPCODE, MAX_CAPACITY, PRICE) " +
			"VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

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
			pstmt.setString(10, classes.getZipcode());
			pstmt.setInt(11, classes.getMaxCapacity());
			pstmt.setInt(12, classes.getPrice());

			int rowsAffected = pstmt.executeUpdate();
			return rowsAffected > 0;
		}
	}

	/**
	 * 메인 페이지용 강의 목록을 최신순으로 조회 (대표 이미지 포함)
	 * @param sortOption 정렬 옵션 ("newest", "popular", "deadline")
	 * @return 최신순으로 정렬된 강의 목록 (대표 이미지 URL 포함)
	 * @throws SQLException 데이터베이스 오류 발생 시
	 */
	public List<ClassListDto> findAllClasses(String sortOption, Integer categoryId) throws SQLException {
		List<ClassListDto> classList = new ArrayList<>();

		// 기본 SQL 쿼리문 (ORDER BY 제외)
		StringBuilder sql = new StringBuilder("""
			SELECT c.CLASS_ID, c.CLASS_NAME, u.NAME as TEACHER_NAME, c.PRICE,
			      DATE_FORMAT(c.START_AT, '%Y-%m-%d %H:%i') as START_AT, c.LOCATION,
			      i.IMAGE_URL as REPRESENTATIVE_IMAGE_URL,
			      cat.CATEGORY as CATEGORY_NAME
			FROM CLASSES c
			JOIN USERS u ON c.TEACHER_ID = u.USER_ID
			JOIN CATEGORIES cat ON c.CATEGORY_ID = cat.CATEGORY_ID
			LEFT JOIN IMAGES i ON c.CLASS_ID = i.CLASS_ID AND i.IS_REPRESENTATIVE = 1
			""");

		// categoryId가 있으면 WHERE 절 추가
		if (categoryId != null && categoryId > 0) {
			sql.append(" WHERE c.CATEGORY_ID = ?");
		}

		// 정렬 옵션에 따라 ORDER BY 절을 동적으로 선택
		String orderByClause;
		switch (sortOption) {
			case "popular":
				orderByClause = " ORDER BY (SELECT COUNT(*) FROM RESERVATIONS r WHERE r.CLASS_ID = c.CLASS_ID) DESC, c.CLASS_ID DESC";
				break;
			case "deadline":
				orderByClause = " ORDER BY c.START_AT ASC";
				break;
			case "newest":
			default:
				orderByClause = " ORDER BY c.CLASS_ID DESC";
				break;
		}
		sql.append(orderByClause);

		try (Connection conn = dbConfig.getConnection();
			 PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {
			if (categoryId != null && categoryId > 0) {
				pstmt.setInt(1, categoryId);
			}
			try (ResultSet rs = pstmt.executeQuery()) {

				while (rs.next()) {
					ClassListDto dto = new ClassListDto();
					dto.setClassId(rs.getInt("CLASS_ID"));
					dto.setClassName(rs.getString("CLASS_NAME"));
					dto.setTeacherName(rs.getString("TEACHER_NAME"));
					dto.setPrice(rs.getInt("PRICE"));
					dto.setStartAt(rs.getString("START_AT"));
					dto.setLocation(rs.getString("LOCATION"));
					dto.setCategoryName(rs.getString("CATEGORY_NAME"));

					String imageUrl = rs.getString("REPRESENTATIVE_IMAGE_URL");
					dto.setRepresentativeImageUrl(imageUrl != null ? imageUrl : "/images/default-class.jpg");

					classList.add(dto);
				}
			}
			return classList;
		}
	}

	// 모든 카테고리 목록을 조회하는 메소드
	public List<Category> findAllCategories() throws SQLException {
		List<Category> categories = new ArrayList<>();
		String sql = "SELECT * FROM CATEGORIES";
		try (Connection conn = dbConfig.getConnection();
			 PreparedStatement pstmt = conn.prepareStatement(sql);
			 ResultSet rs = pstmt.executeQuery()) {
			while (rs.next()) {
				Category category = new Category();
				category.setCategoryId(rs.getInt("CATEGORY_ID"));
				category.setCategory(rs.getString("CATEGORY"));
				categories.add(category);
			}
		}
		return categories;
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
			"START_AT, END_AT, LONGITUDE, LATITUDE, LOCATION, ZIPCODE, MAX_CAPACITY, PRICE) " +
			"VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

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
			pstmt.setString(10, classes.getZipcode());
			pstmt.setInt(11, classes.getMaxCapacity());
			pstmt.setInt(12, classes.getPrice());

			int rowsAffected = pstmt.executeUpdate();

			if (rowsAffected > 0) {
				try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
					if (generatedKeys.next()) {
						int generatedId = generatedKeys.getInt(1);
						return generatedId;
					}
				}
			}
			return 0;
		}
	}
}
