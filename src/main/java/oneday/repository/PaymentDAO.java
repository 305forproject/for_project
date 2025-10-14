package oneday.repository;

import oneday.config.DatabaseConfig;
import oneday.model.Payment;
import java.sql.*;

public class PaymentDAO {
	private final DatabaseConfig dbConfig;

	public PaymentDAO() {
		this.dbConfig = DatabaseConfig.getInstance();
	}

	// 트랜잭션 외부에서 사용할 때
	public Payment save(Payment payment) throws SQLException {
		try (Connection conn = dbConfig.getConnection()) {
			return save(conn, payment);
		}
	}

	// 트랜잭션 내부에서 사용할 때 (Connection 공유)
	public Payment save(Connection conn, Payment payment) throws SQLException {
		String sql = "INSERT INTO PAYMENTS (RESERVATION_ID, TOSS_ORDER_ID, TOSS_PAYMENT_KEY, TOSS_PAYMENT_METHOD, TOSS_PAYMENT_STATUS, REQUESTED_AT, APPROVED_AT, TOTAL_AMOUNT) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
		try (PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
			pstmt.setInt(1, payment.getReservationId());
			pstmt.setString(2, payment.getTossOrderId());
			pstmt.setString(3, payment.getTossPaymentKey());
			pstmt.setString(4, payment.getTossPaymentMethod());
			pstmt.setString(5, payment.getTossPaymentStatus());
			pstmt.setObject(6, payment.getRequestedAt());
			pstmt.setObject(7, payment.getApprovedAt());
			pstmt.setInt(8, payment.getTotalAmount());
			pstmt.executeUpdate();
			try (ResultSet rs = pstmt.getGeneratedKeys()) {
				if (rs.next()) {
					payment.setPaymentId(rs.getInt(1));
				}
			}
		}
		return payment;
	}
}