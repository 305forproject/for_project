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
	private final PaymentDAO paymentDAO;
	private static final Logger logger = LoggerUtil.getLogger(String.valueOf(ReservationService.class));

	private ReservationService() {
		this.reservationDAO = new ReservationDAO();
		this.paymentDAO = new PaymentDAO();
		this.classDAO = new ClassDAO(); // ClassDAO 초기화
	}

	public static synchronized ReservationService getInstance() {
		if (instance == null) {
			instance = new ReservationService();
		}
		return instance;
	}

	public Reservation createReservation(ReservationRequestDto dto, int studentId) throws Exception {
		// 1. 강의 정보 조회
		Classes targetClass = classDAO.findById(dto.getClassId());
		if (targetClass == null) {
			throw new Exception("존재하지 않는 강의입니다.");
		}

		// 2. 이미 예약했는지 확인
		if (reservationDAO.existsByStudentIdAndClassId(studentId, dto.getClassId())) {
			throw new Exception("이미 예약한 강의입니다.");
		}

		// 3. 정원이 다 찼는지 확인
		int currentCount = reservationDAO.countByClassId(dto.getClassId());
		if (currentCount >= targetClass.getMaxCapacity()) {
			throw new Exception("정원이 모두 마감되었습니다.");
		}

		// 4. 모든 규칙 통과 시 예약 생성
		Reservation newReservation = new Reservation();
		newReservation.setStudentId(studentId);
		newReservation.setClassId(dto.getClassId());
		newReservation.setStatusCode(1); // 1: 예약완료 상태라고 가정

		return reservationDAO.save(newReservation);
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

	/**
	 * [신규] 결제 승인 후, 예약과 결제 정보를 DB에 함께 생성하는 메소드
	 */
	public boolean createReservationAfterPayment(int classId, int studentId, JSONObject tossResponse) {

		// --- 트랜잭션 시작 ---
		return DatabaseTransactionUtil.executeTransactionForBoolean(conn -> {

			// --- 1. [추가] 예약 생성 규칙 검사 (createReservation에서 가져온 로직) ---
			try {
				// 1-1. 강의 정보 조회
				Classes targetClass = classDAO.findById(classId);
				if (targetClass == null) {
					throw new RuntimeException("존재하지 않는 강의입니다."); // RuntimeException으로 변경
				}

				// 1-2. 이미 예약했는지 확인
				if (reservationDAO.existsByStudentIdAndClassId(studentId, classId)) {
					throw new RuntimeException("이미 예약한 강의입니다.");
				}

				// 1-3. 정원이 다 찼는지 확인
				int currentCount = reservationDAO.countByClassId(classId);
				if (currentCount >= targetClass.getMaxCapacity()) {
					throw new RuntimeException("정원이 모두 마감되었습니다.");
				}
			} catch (SQLException e) {
				// DAO에서 발생하는 SQLException을 RuntimeException으로 감싸서 던져 트랜잭션을 롤백시킵니다.
				throw new RuntimeException("예약 규칙 검사 중 DB 오류 발생", e);
			}

			// --- 2. RESERVATIONS 테이블에 INSERT ---
			Reservation newReservation = new Reservation();
			newReservation.setClassId(classId);
			newReservation.setStudentId(studentId);
			newReservation.setStatusCode(2); // 2: 결제완료 상태

			Reservation savedReservation = null;
			try {
				savedReservation = reservationDAO.save(conn, newReservation);
			} catch (SQLException e) {
				throw new RuntimeException(e);
			}

			// --- 3. PAYMENTS 테이블에 INSERT ---
			Payment payment = new Payment();
			payment.setReservationId(savedReservation.getReservationId());
			// tossResponse에서 데이터를 꺼내 payment 객체를 채우는 로직
			payment.setTossOrderId((String) tossResponse.get("orderId"));
			payment.setTossPaymentKey((String) tossResponse.get("paymentKey"));
			payment.setTossPaymentMethod((String) tossResponse.get("method"));
			payment.setTossPaymentStatus((String) tossResponse.get("status"));
			payment.setTotalAmount(((Long) tossResponse.get("totalAmount")).intValue());
			DateTimeFormatter formatter = DateTimeFormatter.ISO_OFFSET_DATE_TIME;
			payment.setRequestedAt(OffsetDateTime.parse((String) tossResponse.get("requestedAt"), formatter).toLocalDateTime());
			payment.setApprovedAt(OffsetDateTime.parse((String) tossResponse.get("approvedAt"), formatter).toLocalDateTime());

			try {
				paymentDAO.save(conn, payment);
			} catch (SQLException e) {
				throw new RuntimeException(e);
			}

			return true; // 모든 작업이 성공적으로 끝나면 true 반환
		});
		// --- 트랜잭션 종료 ---
	}
}