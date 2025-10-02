package oneday.service;

import oneday.model.Payment;
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
	private final ReservationDAO reservationDAO;

	private PaymentService() {
		this.paymentDAO = new PaymentDAO();
		this.reservationDAO = new ReservationDAO();
	}

	public static synchronized PaymentService getInstance() {
		if (instance == null) {
			instance = new PaymentService();
		}
		return instance;
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