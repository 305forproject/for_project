package oneday.repository;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import oneday.config.DatabaseConfig;
import oneday.dto.TeacherCalendarDto;
import oneday.dto.TeacherClassDetailDto;
import oneday.model.Classes;

public class ClassDAO {
	private final DatabaseConfig dbConfig;

	public ClassDAO() {
		this.dbConfig = DatabaseConfig.getInstance();
	}

	//id로 수업 조회
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

	//선생용 달력 조회
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

	//예약 상세 조회
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
}
