package oneday.dto;

import java.time.LocalDateTime;

public class TeacherClassDetailDto {
	private int classId;
	private int categoryId;
	private String className;
	private String classDetail;
	private LocalDateTime startAt;
	private LocalDateTime endAt;
	private String longitude;
	private String latitude;
	private String location;
	private int maxCapacity;
	private int price;
	private String teacherName;
	private int currentReservationCount;

	public int getClassId() {
		return classId;
	}

	public void setClassId(int classId) {
		this.classId = classId;
	}

	public int getCategoryId() {
		return categoryId;
	}

	public void setCategoryId(int categoryId) {
		this.categoryId = categoryId;
	}

	public String getClassName() {
		return className;
	}

	public void setClassName(String className) {
		this.className = className;
	}

	public String getClassDetail() {
		return classDetail;
	}

	public void setClassDetail(String classDetail) {
		this.classDetail = classDetail;
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

	public String getLongitude() {
		return longitude;
	}

	public void setLongitude(String longitude) {
		this.longitude = longitude;
	}

	public String getLatitude() {
		return latitude;
	}

	public void setLatitude(String latitude) {
		this.latitude = latitude;
	}

	public String getLocation() {
		return location;
	}

	public void setLocation(String location) {
		this.location = location;
	}

	public int getMaxCapacity() {
		return maxCapacity;
	}

	public void setMaxCapacity(int maxCapacity) {
		this.maxCapacity = maxCapacity;
	}

	public int getPrice() {
		return price;
	}

	public void setPrice(int price) {
		this.price = price;
	}

	public String getTeacherName() {
		return teacherName;
	}

	public void setTeacherName(String teacherName) {
		this.teacherName = teacherName;
	}

	public int getCurrentReservationCount() {
		return currentReservationCount;
	}

	public void setCurrentReservationCount(int currentReservationCount) {
		this.currentReservationCount = currentReservationCount;
	}

	public TeacherClassDetailDto() {
	}


}