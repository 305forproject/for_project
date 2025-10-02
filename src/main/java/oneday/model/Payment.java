package oneday.model;

import java.time.LocalDateTime;

public class Payment {

	private int paymentId;
	private int reservationId;
	private String tossOrderId;
	private String tossPaymentKey;
	private String tossPaymentMethod;
	private String tossPaymentStatus;
	private LocalDateTime requestedAt;
	private LocalDateTime approvedAt;
	private int totalAmount;

	public int getPaymentId() {
		return paymentId;
	}

	public void setPaymentId(int paymentId) {
		this.paymentId = paymentId;
	}

	public int getReservationId() {
		return reservationId;
	}

	public void setReservationId(int reservationId) {
		this.reservationId = reservationId;
	}

	public String getTossOrderId() {
		return tossOrderId;
	}

	public void setTossOrderId(String tossOrderId) {
		this.tossOrderId = tossOrderId;
	}

	public String getTossPaymentKey() {
		return tossPaymentKey;
	}

	public void setTossPaymentKey(String tossPaymentKey) {
		this.tossPaymentKey = tossPaymentKey;
	}

	public String getTossPaymentMethod() {
		return tossPaymentMethod;
	}

	public void setTossPaymentMethod(String tossPaymentMethod) {
		this.tossPaymentMethod = tossPaymentMethod;
	}

	public String getTossPaymentStatus() {
		return tossPaymentStatus;
	}

	public void setTossPaymentStatus(String tossPaymentStatus) {
		this.tossPaymentStatus = tossPaymentStatus;
	}

	public LocalDateTime getRequestedAt() {
		return requestedAt;
	}

	public void setRequestedAt(LocalDateTime requestedAt) {
		this.requestedAt = requestedAt;
	}

	public LocalDateTime getApprovedAt() {
		return approvedAt;
	}

	public void setApprovedAt(LocalDateTime approvedAt) {
		this.approvedAt = approvedAt;
	}

	public int getTotalAmount() {
		return totalAmount;
	}

	public void setTotalAmount(int totalAmount) {
		this.totalAmount = totalAmount;
	}
}