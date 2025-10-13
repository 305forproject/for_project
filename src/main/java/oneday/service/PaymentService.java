package oneday.service;

import oneday.model.Classes;
import oneday.model.Payment;
import oneday.model.Reservation;
import oneday.repository.ClassDAO;
import oneday.repository.PaymentDAO;
import oneday.repository.ReservationDAO;
import oneday.util.DatabaseTransactionUtil;
import org.json.simple.JSONObject;

import java.sql.SQLException;
import java.time.OffsetDateTime;
import java.time.format.DateTimeFormatter;

public class PaymentService {
	private static PaymentService instance;
	private final PaymentDAO paymentDAO;
	private final ClassDAO classDAO;
	private final ReservationDAO reservationDAO;

	private PaymentService() {
		this.paymentDAO = new PaymentDAO();
		this.classDAO = new ClassDAO();
		this.reservationDAO = new ReservationDAO();
	}

	public static synchronized PaymentService getInstance() {
		if (instance == null) {
			instance = new PaymentService();
		}
		return instance;
	}

	public void createReservationAndPayment(int classId, int studentId, JSONObject tossResponse) throws Exception {

		// [수정] executeTransactionForBoolean 대신 executeTransaction을 직접 사용합니다.
		DatabaseTransactionUtil.executeTransaction(conn -> {
			try {
				// --- 1. 예약 생성 규칙 검사 ---
				Classes targetClass = classDAO.findById(classId);
				if (targetClass == null) {
					throw new RuntimeException("존재하지 않는 강의입니다.");
				}
				if (reservationDAO.existsByStudentIdAndClassId(studentId, classId)) {
					throw new RuntimeException("이미 예약한 강의입니다.");
				}
				int currentCount = reservationDAO.countByClassId(classId);
				if (currentCount >= targetClass.getMaxCapacity()) {
					throw new RuntimeException("정원이 모두 마감되었습니다.");
				}

				// --- 2. 예약 정보 저장 ---
				Reservation newReservation = new Reservation();
				newReservation.setClassId(classId);
				newReservation.setStudentId(studentId);
				newReservation.setStatusCode(1); // 1: 결제완료 상태
				Reservation savedReservation = reservationDAO.save(conn, newReservation);

				// --- 3. 결제 정보 저장 ---
				Payment payment = new Payment();
				payment.setReservationId(savedReservation.getReservationId());
				payment.setTossOrderId((String) tossResponse.get("orderId"));
				payment.setTossPaymentKey((String) tossResponse.get("paymentKey"));
				payment.setTossPaymentMethod((String) tossResponse.get("method"));
				payment.setTossPaymentStatus((String) tossResponse.get("status"));
				payment.setTotalAmount(((Long) tossResponse.get("totalAmount")).intValue());
				DateTimeFormatter formatter = DateTimeFormatter.ISO_OFFSET_DATE_TIME;
				payment.setRequestedAt(OffsetDateTime.parse((String) tossResponse.get("requestedAt"), formatter).toLocalDateTime());
				payment.setApprovedAt(OffsetDateTime.parse((String) tossResponse.get("approvedAt"), formatter).toLocalDateTime());
				paymentDAO.save(conn, payment);

				return true; // 성공 시 아무 값이나 반환 (여기서는 사용되지 않음)
			} catch (SQLException e) {
				throw new RuntimeException("데이터베이스 처리 중 오류 발생", e);
			}
		});
	}

	public boolean processPayment(JSONObject tossResponse, int reservationId) {
		Payment payment = new Payment();
		payment.setReservationId(reservationId);
		payment.setTossOrderId((String) tossResponse.get("orderId"));
		payment.setTossPaymentKey((String) tossResponse.get("paymentKey"));
		payment.setTossPaymentMethod((String) tossResponse.get("method"));
		payment.setTossPaymentStatus((String) tossResponse.get("status"));
		payment.setTotalAmount(((Long) tossResponse.get("totalAmount")).intValue());
		DateTimeFormatter formatter = DateTimeFormatter.ISO_OFFSET_DATE_TIME;
		payment.setRequestedAt(OffsetDateTime.parse((String) tossResponse.get("requestedAt"), formatter).toLocalDateTime());
		payment.setApprovedAt(OffsetDateTime.parse((String) tossResponse.get("approvedAt"), formatter).toLocalDateTime());

		// 트랜잭션 시작: 두 개의 DB 작업(결제 저장, 예약 상태 변경) 하나로
		return DatabaseTransactionUtil.executeTransactionForBoolean(conn -> {
			// 1. PAYMENTS 테이블에 결제 정보 저장
			try {
				paymentDAO.save(conn, payment);
			} catch (SQLException e) {
				throw new RuntimeException(e);
			}

			// 2. RESERVATIONS 테이블의 상태를 '결제완료'(예: 상태코드 2)로 변경
			try {
				reservationDAO.updateStatusCode(conn, reservationId, 2);
			} catch (SQLException e) {
				throw new RuntimeException(e);
			}

			return true;
		});
	}
}