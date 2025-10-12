package oneday.dto;

/**
 * 메인 페이지 강의 목록 표시용 DTO
 * 대표 이미지를 포함한 강의 요약 정보를 담음
 */
public class ClassListDto {
	private int classId;
	private String className;
	private String teacherName;
	private int price;
	private String startAt;
	private String representativeImageUrl;
	private String location;

	public ClassListDto() {
	}

	// Getter와 Setter 메서드들
	public int getClassId() {
		return classId;
	}

	public void setClassId(int classId) {
		this.classId = classId;
	}

	public String getClassName() {
		return className;
	}

	public void setClassName(String className) {
		this.className = className;
	}

	public String getTeacherName() {
		return teacherName;
	}

	public void setTeacherName(String teacherName) {
		this.teacherName = teacherName;
	}

	public int getPrice() {
		return price;
	}

	public void setPrice(int price) {
		this.price = price;
	}

	public String getStartAt() {
		return startAt;
	}

	public void setStartAt(String startAt) {
		this.startAt = startAt;
	}

	public String getRepresentativeImageUrl() {
		return representativeImageUrl;
	}

	public void setRepresentativeImageUrl(String representativeImageUrl) {
		this.representativeImageUrl = representativeImageUrl;
	}

	public String getLocation() {
		return location;
	}

	public void setLocation(String location) {
		this.location = location;
	}
}
