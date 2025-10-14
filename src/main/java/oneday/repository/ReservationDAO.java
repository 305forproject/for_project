package oneday.repository;

import oneday.config.DatabaseConfig;
import oneday.dto.FullCalendarEventDto;
import oneday.dto.ReservationCalendarDto;
import oneday.dto.ReservationDetailDto;
import oneday.model.Reservation;

import java.sql.*;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

public class ReservationDAO {

	private final DatabaseConfig dbConfig;

	public ReservationDAO() {
		this.dbConfig = DatabaseConfig.getInstance();
	}

	//예약자 수 확인
	public int countByClassId(Connection conn, int classId) throws SQLException {
		String sql = "SELECT COUNT(*) FROM RESERVATIONS WHERE CLASS_ID = ?";
		try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
			pstmt.setInt(1, classId);
			try (ResultSet rs = pstmt.executeQuery()) {
				if (rs.next()) {
					return rs.getInt(1);
				}
			}
		}
		return 0;
	}

	//이미 예약 했는지
	public boolean existsByStudentIdAndClassId(Connection conn, int studentId, int classId) throws SQLException {
		String sql = "SELECT COUNT(*) FROM RESERVATIONS WHERE STUDENT_ID = ? AND CLASS_ID = ?";
		try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
			pstmt.setInt(1, studentId);
			pstmt.setInt(2, classId);
			try (ResultSet rs = pstmt.executeQuery()) {
				if (rs.next()) {
					return rs.getInt(1) > 0;
				}
			}
		}
		return false;
	}

	//새 예약 저장

	/**
	 * 트랜잭션 외부에서 예약을 저장할 때 사용하는 메소드.
	 * 내부적으로 DB 커넥션을 열고 닫습니다.
	 * @param reservation 저장할 예약 정보
	 * @return 저장된 예약 정보 (ID 포함)
	 * @throws SQLException DB 오류 발생 시
	 */
	public Reservation save(Reservation reservation) throws SQLException {
		// 1. 이 메소드는 스스로 DB 커넥션을 엽니다.
		try (Connection conn = dbConfig.getConnection()) {
			// 2. 그리고 아래에 있는, Connection을 받는 save 메소드를 호출하여 실제 작업을 위임합니다.
			return save(conn, reservation);
		}
	}

	/**
	 * 트랜잭션 내부에서 예약을 저장할 때 사용하는 메소드.
	 * 외부(서비스 계층)에서 전달받은 DB 커넥션을 사용합니다.
	 * @param conn 외부에서 전달받은 데이터베이스 연결
	 * @param reservation 저장할 예약 정보
	 * @return 저장된 예약 정보 (ID 포함)
	 * @throws SQLException DB 오류 발생 시
	 */
	public Reservation save(Connection conn, Reservation reservation) throws SQLException {
		String sql = "INSERT INTO RESERVATIONS (CLASS_ID, STUDENT_ID, STATUS_CODE) VALUES (?, ?, ?)";

		// try-with-resources에서 Connection을 여는 코드를 제거합니다.
		// 이제 파라미터로 받은 conn을 사용합니다.
		try (PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

			pstmt.setInt(1, reservation.getClassId());
			pstmt.setInt(2, reservation.getStudentId());
			pstmt.setInt(3, reservation.getStatusCode());

			int affectedRows = pstmt.executeUpdate();

			if (affectedRows == 0) {
				throw new SQLException("예약 정보 저장에 실패했습니다.");
			}

			try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
				if (generatedKeys.next()) {
					reservation.setReservationId(generatedKeys.getInt(1));
				} else {
					throw new SQLException("예약 ID를 가져오는데 실패했습니다.");
				}
			}
		}
		return reservation;
	}

	//학생, 년, 월 별 예약 조회
	public List<ReservationCalendarDto> findCalendarEventsByStudentIdAndMonth(int studentId, int year, int month) throws
		SQLException {
		List<ReservationCalendarDto> calendarEvents = new ArrayList<>();
		String sql = "SELECT r.RESERVATION_ID, c.START_AT, c.END_AT, cat.CATEGORY " +
			"FROM RESERVATIONS r " +
			"JOIN CLASSES c ON r.CLASS_ID = c.CLASS_ID " +
			"JOIN CATEGORIES cat ON c.CATEGORY_ID = cat.CATEGORY_ID " +
			"WHERE r.STUDENT_ID = ? AND YEAR(c.START_AT) = ? AND MONTH(c.START_AT) = ?";

		try (Connection conn = dbConfig.getConnection();
			 PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setInt(1, studentId);
			pstmt.setInt(2, year);
			pstmt.setInt(3, month);

			try (ResultSet rs = pstmt.executeQuery()) {
				while (rs.next()) {
					ReservationCalendarDto dto = new ReservationCalendarDto();
					dto.setReservationId(rs.getInt("RESERVATION_ID"));
					dto.setStartAt(rs.getTimestamp("START_AT").toLocalDateTime());
					dto.setEndAt(rs.getTimestamp("END_AT").toLocalDateTime());
					dto.setCategory(rs.getString("CATEGORY"));
					calendarEvents.add(dto);
				}
			}
		}
		return calendarEvents;
	}

	//예약 상세 조회
	public ReservationDetailDto findReservationDetailsById(int reservationId, int studentId) throws SQLException {
		ReservationDetailDto dto = null;
		String sql = "SELECT c.class_id, c.class_name, c.start_at, c.end_at, c.location," +
			"c.latitude, c.longitude, cat.category " +
			"FROM RESERVATIONS r " +
			"JOIN CLASSES c ON r.class_id = c.class_id " +
			"JOIN CATEGORIES cat ON c.category_id = cat.category_id " +
			"WHERE r.reservation_id = ?";

		try (Connection conn = dbConfig.getConnection();
			 PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setInt(1, reservationId);
			try (ResultSet rs = pstmt.executeQuery()) {
				if (rs.next()) {
					dto = new ReservationDetailDto();
					dto.setClassName(rs.getString("CLASS_NAME"));
					dto.setLocation(rs.getString("LOCATION"));
					dto.setStartAt(rs.getTimestamp("START_AT").toLocalDateTime());
					dto.setEndAt(rs.getTimestamp("END_AT").toLocalDateTime());
					dto.setLatitude(rs.getString("latitude"));
					dto.setLongitude(rs.getString("longitude"));
					dto.setCategoryName(rs.getString("category"));
				}
			}
		}
		return dto;
	}

	// 날짜 범위 조절하여 학생 예약 조회
	public List<FullCalendarEventDto> findEventsForCalendar(int studentId, String startDate, String endDate) throws
		SQLException {
		List<FullCalendarEventDto> events = new ArrayList<>();
		String sql = "SELECT r.RESERVATION_ID, c.START_AT, c.END_AT, c.CLASS_NAME " +
			"FROM RESERVATIONS r " +
			"JOIN CLASSES c ON r.CLASS_ID = c.CLASS_ID " +
			"WHERE r.STUDENT_ID = ? AND c.START_AT BETWEEN ? AND ?";

		try (Connection conn = dbConfig.getConnection();
			 PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setInt(1, studentId);
			pstmt.setString(2, startDate);
			pstmt.setString(3, endDate);

			DateTimeFormatter formatter = DateTimeFormatter.ofPattern("h:mm a");

			try (ResultSet rs = pstmt.executeQuery()) {
				while (rs.next()) {
					FullCalendarEventDto dto = new FullCalendarEventDto();
					dto.setId(String.valueOf(rs.getInt("RESERVATION_ID")));

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

	//예약 상태 변경
	public int updateStatusCode(Connection conn, int reservationId, int statusCode) throws SQLException {
		String sql = "UPDATE RESERVATIONS SET STATUS_CODE = ? WHERE RESERVATION_ID = ?";
		try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
			pstmt.setInt(1, statusCode);
			pstmt.setInt(2, reservationId);
			return pstmt.executeUpdate();
		}
	}

}
