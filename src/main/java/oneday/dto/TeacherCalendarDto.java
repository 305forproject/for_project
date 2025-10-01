package oneday.dto;

import java.time.LocalDateTime;

public class TeacherCalendarDto {
	private int classId;
	private LocalDateTime startAt;
	private LocalDateTime endAt;
	private int currentReservationCount;
	private int maxCapacity;

	public int getClassId() {
		return classId;
	}

	public void setClassId(int classId) {
		this.classId = classId;
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

	public int getCurrentReservationCount() {
		return currentReservationCount;
	}

	public void setCurrentReservationCount(int currentReservationCount) {
		this.currentReservationCount = currentReservationCount;
	}

	public int getMaxCapacity() {
		return maxCapacity;
	}

	public void setMaxCapacity(int maxCapacity) {
		this.maxCapacity = maxCapacity;
	}
}