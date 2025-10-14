package oneday.service;

import java.sql.SQLException;
import java.time.OffsetDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import org.json.simple.JSONObject;

import oneday.dto.FullCalendarEventDto;
import oneday.dto.ReservationCalendarDto;
import oneday.dto.ReservationDetailDto;
import oneday.dto.ReservationRequestDto;
import oneday.model.Classes;
import oneday.model.Payment;
import oneday.model.Reservation;
import oneday.repository.ClassDAO;
import oneday.repository.PaymentDAO;
import oneday.repository.ReservationDAO;
import oneday.util.DatabaseTransactionUtil;
import oneday.util.LoggerUtil;

public class ReservationService {
	private static ReservationService instance;
	private final ReservationDAO reservationDAO;
	private final ClassDAO classDAO;
	private static final Logger logger = LoggerUtil.getLogger(String.valueOf(ReservationService.class));

	private ReservationService() {
		this.reservationDAO = new ReservationDAO();
		this.classDAO = new ClassDAO();
	}

	public static synchronized ReservationService getInstance() {
		if (instance == null) {
			instance = new ReservationService();
		}
		return instance;
	}

	public Reservation createReservation(ReservationRequestDto dto, int studentId) throws Exception {
		return DatabaseTransactionUtil.executeTransaction(conn -> {
			try {
				// 예약 생성 가능 여부 검사
				Classes targetClass = classDAO.findById(conn, dto.getClassId());
				if (targetClass == null) {
					throw new RuntimeException("존재하지 않는 강의입니다.");
				}
				if (reservationDAO.existsByStudentIdAndClassId(conn, studentId, dto.getClassId())) {
					throw new RuntimeException("이미 예약한 강의입니다.");
				}
				int currentCount = reservationDAO.countByClassId(conn, dto.getClassId());
				if (currentCount >= targetClass.getMaxCapacity()) {
					throw new RuntimeException("정원이 모두 마감되었습니다.");
				}

				Reservation newReservation = new Reservation();
				newReservation.setStudentId(studentId);
				newReservation.setClassId(dto.getClassId());
				newReservation.setStatusCode(1);

				return reservationDAO.save(conn, newReservation);
			} catch (SQLException e) {
				throw new RuntimeException(e);
			}
		});
	}

	//학생 월별 예약 조회
	public List<ReservationCalendarDto> findMyReservationTimesByMonth(int studentId, int year, int month) {
		try {
			return reservationDAO.findCalendarEventsByStudentIdAndMonth(studentId, year, month);
		} catch (SQLException e) {
			e.printStackTrace();
			return new ArrayList<>();
		}
	}

	//예약 조회
	public List<FullCalendarEventDto> findMyCalendarEventsByDateRange(int studentId, String startDate, String endDate) {
		try {
			return reservationDAO.findEventsForCalendar(studentId, startDate, endDate);
		} catch (SQLException e) {
			logger.log(Level.SEVERE, "날짜 범위로 캘린더 이벤트 조회 중 DB 오류 발생", e);
			return new ArrayList<>();
		}
	}

	//예약 상세정보 조회
	public ReservationDetailDto findMyReservationDetails(int reservationId, int studentId) throws SQLException {
		try {
			return reservationDAO.findReservationDetailsById(reservationId, studentId);
		} catch (SQLException e) {
			e.printStackTrace();
			return null;
		}
	}

}