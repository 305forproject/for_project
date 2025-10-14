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

	public void createReservationAndPayment(int classId, int studentId, JSONObject tossResponse) {
		DatabaseTransactionUtil.executeTransaction(conn -> {
			try {
				// --- 1. 예약 생성 가능 여부 검사 ---
				Classes targetClass = classDAO.findById(conn, classId);
				if (targetClass == null) {
					throw new RuntimeException("존재하지 않는 강의입니다.");
				}
				if (reservationDAO.existsByStudentIdAndClassId(conn, studentId, classId)) {
					throw new RuntimeException("이미 예약한 강의입니다.");
				}
				int currentCount = reservationDAO.countByClassId(conn, classId);
				if (currentCount >= targetClass.getMaxCapacity()) {
					throw new RuntimeException("정원이 모두 마감되었습니다.");
				}

				// --- 2. 예약 정보 저장 ---
				Reservation newReservation = new Reservation();
				newReservation.setClassId(classId);
				newReservation.setStudentId(studentId);
				newReservation.setStatusCode(1); // 1: 예약완료 상태
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

				return true;
			} catch (SQLException e) {
				throw new RuntimeException("데이터베이스 처리 중 오류 발생", e);
			}
		});
	}
}