package oneday.dto;

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;

public class ReservationCalendarDto {
	private int reservationId;
	private LocalDateTime startAt;
	private LocalDateTime endAt;
	private String category;

	public int getReservationId() {
		return reservationId;
	}

	public void setReservationId(int reservationId) {
		this.reservationId = reservationId;
	}

	public LocalDateTime getStartAt() {
		return startAt;
	}

	public void setStartAt(LocalDateTime startAt) {
		this.startAt = startAt;
	}

	public LocalDateTime getEndAt() {
		return endAt;
	}

	public void setEndAt(LocalDateTime endAt) {
		this.endAt = endAt;
	}

	public String getCategory() {
		return category;
	}

	public void setCategory(String category) {
		this.category = category;
	}

	// jsp 출력은  위한 메소드
	// "${event.startAtAsDate} 이런 식으로 사용
	public Date getStartAtAsDate() {
		if (this.startAt == null) return null;
		return Date.from(this.startAt.atZone(ZoneId.systemDefault()).toInstant());
	}

	public Date getEndAtAsDate() {
		if (this.endAt == null) return null;
		return Date.from(this.endAt.atZone(ZoneId.systemDefault()).toInstant());
	}
}
