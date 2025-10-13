package oneday.dto;

import java.time.LocalDateTime;
import java.util.Date;
import java.time.ZoneId;
import java.util.List;

import oneday.model.Image;

public class ClassDetailDto {

	private int classId;
	private int categoryId;
	private String className;
	private String description;
	private LocalDateTime startAt;
	private LocalDateTime endAt;
	private String longitude;
	private String latitude;
	private String location;
	private int maxStudents;
	private int price;
	private String teacherName;
	private int currentReservationCount;
	private List<Image> images;

	public List<Image> getImages() {
		return images;
	}

	public void setImages(List<Image> images) {
		this.images = images;
	}

	// JSP의 <fmt:formatDate> 태그를 위한 변환 메소드
	public Date getStartAtAsDate() {
		if (this.startAt == null)
			return null;
		return Date.from(this.startAt.atZone(ZoneId.systemDefault()).toInstant());
	}

	public Date getEndAtAsDate() {
		if (this.endAt == null)
			return null;
		return Date.from(this.endAt.atZone(ZoneId.systemDefault()).toInstant());
	}

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

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
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

	public int getMaxStudents() {
		return maxStudents;
	}

	public void setMaxStudents(int maxStudents) {
		this.maxStudents = maxStudents;
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
}