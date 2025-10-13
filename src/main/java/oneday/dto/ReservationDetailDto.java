package oneday.dto;

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;

public class ReservationDetailDto {
	private int reservationId;
	private String className;
	private LocalDateTime startAt;
	private LocalDateTime endAt;
	private String location;
	private String categoryName;
	private String latitude;
	private String longitude;

	public String getCategoryName() {
		return categoryName;
	}

	public void setCategoryName(String categoryName) {
		this.categoryName = categoryName;
	}

	public String getLatitude() {
		return latitude;
	}

	public void setLatitude(String latitude) {
		this.latitude = latitude;
	}

	public String getLongitude() {
		return longitude;
	}

	public void setLongitude(String longitude) {
		this.longitude = longitude;
	}

	public ReservationDetailDto() {
	}

	public int getReservationId() {
		return reservationId;
	}

	public void setReservationId(int reservationId) {
		this.reservationId = reservationId;
	}

	public String getClassName() {
		return className;
	}

	public void setClassName(String className) {
		this.className = className;
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

	public String getLocation() {
		return location;
	}

	public void setLocation(String location) {
		this.location = location;
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
