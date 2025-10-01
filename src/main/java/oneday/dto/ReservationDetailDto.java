package oneday.dto;

import java.time.LocalDateTime;

public class ReservationDetailDto {
	private int reservationId;
	private String className;
	private LocalDateTime startAt;
	private LocalDateTime endAt;
	private String location;

	public ReservationDetailDto() {}

	public int getReservationId() { return reservationId; }
	public void setReservationId(int reservationId) { this.reservationId = reservationId; }
	public String getClassName() { return className; }
	public void setClassName(String className) { this.className = className; }
	public LocalDateTime getStartAt() { return startAt; }
	public void setStartAt(LocalDateTime startAt) { this.startAt = startAt; }
	public LocalDateTime getEndAt() { return endAt; }
	public void setEndAt(LocalDateTime endAt) { this.endAt = endAt; }
	public String getLocation() { return location; }
	public void setLocation(String location) { this.location = location; }
}
