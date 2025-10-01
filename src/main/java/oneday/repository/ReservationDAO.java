package oneday.repository;

import oneday.config.DatabaseConfig;
import oneday.dto.ReservationCalendarDto;
import oneday.dto.ReservationDetailDto;
import oneday.model.Reservation;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;


public class ReservationDAO {

	private final DatabaseConfig dbConfig;

	public ReservationDAO() {
		this.dbConfig = DatabaseConfig.getInstance();
	}

	//예약자 수 확인
	public int countByClassId(int classId) throws SQLException {
		String sql = "SELECT COUNT(*) FROM RESERVATIONS WHERE CLASS_ID = ?";
		try (Connection conn = dbConfig.getConnection();
			 PreparedStatement pstmt = conn.prepareStatement(sql)) {
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
	public boolean existsByStudentIdAndClassId(int studentId, int classId) throws SQLException {
		String sql = "SELECT COUNT(*) FROM RESERVATIONS WHERE STUDENT_ID = ? AND CLASS_ID = ?";
		try (Connection conn = dbConfig.getConnection();
			 PreparedStatement pstmt = conn.prepareStatement(sql)) {
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
	public Reservation save(Reservation reservation) throws SQLException {
		String sql = "INSERT INTO RESERVATIONS (CLASS_ID, STUDENT_ID, STATUS_CODE) VALUES (?, ?, ?)";

		try (Connection conn = dbConfig.getConnection();
			 PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

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
	public List<ReservationCalendarDto> findCalendarEventsByStudentIdAndMonth(int studentId, int year, int month) throws SQLException {
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

	public ReservationDetailDto findReservationDetailsById(int reservationId, int studentId) throws SQLException {
		ReservationDetailDto dto = null;
		String sql = "SELECT c.CLASS_NAME, c.START_AT, c.END_AT, c.LOCATION " +
			"FROM RESERVATIONS r " +
			"JOIN CLASSES c ON r.CLASS_ID = c.CLASS_ID " +
			"WHERE r.RESERVATION_ID = ? AND r.STUDENT_ID = ?";

		try (Connection conn = dbConfig.getConnection();
			 PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setInt(1, reservationId);
			pstmt.setInt(2, studentId);

			try (ResultSet rs = pstmt.executeQuery()) {
				if (rs.next()) {
					dto = new ReservationDetailDto();
					dto.setClassName(rs.getString("CLASS_NAME"));
					dto.setStartAt(rs.getTimestamp("START_AT").toLocalDateTime());
					dto.setEndAt(rs.getTimestamp("END_AT").toLocalDateTime());
					dto.setLocation(rs.getString("LOCATION"));
				}
			}
		}
		return dto;
	}

}
