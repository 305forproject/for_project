package oneday.dto;

/**
 * 클래스 등록 요청 데이터 전송 객체 (DTO)
 * 클래스 등록 폼에서 전달되는 데이터를 담는 객체
 */
public class ClassRegisterDto {
	private String className;
	private String description;
	private int categoryId;
	private String classDate;
	private String startTime;
	private String endTime;
	private int maxStudents;
	private int price;
	private String location;
	private String zipcode;
	private String latitude;
	private String longitude;

	/**
	 * 기본 생성자
	 */
	public ClassRegisterDto() {
	}

	/**
	 * 클래스명을 반환
	 *
	 * @return 클래스명
	 */
	public String getClassName() {
		return className;
	}

	/**
	 * 클래스명을 설정
	 *
	 * @param className 설정할 클래스명
	 */
	public void setClassName(String className) {
		this.className = className;
	}

	/**
	 * 클래스 설명을 반환
	 *
	 * @return 클래스 설명
	 */
	public String getDescription() {
		return description;
	}

	/**
	 * 클래스 설명을 설정
	 *
	 * @param description 설정할 클래스 설명
	 */
	public void setDescription(String description) {
		this.description = description;
	}

	/**
	 * 카테고리 ID를 반환
	 *
	 * @return 카테고리 ID
	 */
	public int getCategoryId() {
		return categoryId;
	}

	/**
	 * 카테고리 ID를 설정
	 *
	 * @param categoryId 설정할 카테고리 ID
	 */
	public void setCategoryId(int categoryId) {
		this.categoryId = categoryId;
	}

	/**
	 * 수업 날짜를 반환 (yyyy-MM-dd 형식)
	 *
	 * @return 수업 날짜
	 */
	public String getClassDate() {
		return classDate;
	}

	/**
	 * 수업 날짜를 설정 (yyyy-MM-dd 형식)
	 *
	 * @param classDate 설정할 수업 날짜
	 */
	public void setClassDate(String classDate) {
		this.classDate = classDate;
	}

	/**
	 * 수업 시작 시간을 반환 (HH:mm 형식)
	 *
	 * @return 수업 시작 시간
	 */
	public String getStartTime() {
		return startTime;
	}

	/**
	 * 수업 시작 시간을 설정 (HH:mm 형식)
	 *
	 * @param startTime 설정할 수업 시작 시간
	 */
	public void setStartTime(String startTime) {
		this.startTime = startTime;
	}

	/**
	 * 수업 종료 시간을 반환 (HH:mm 형식)
	 *
	 * @return 수업 종료 시간
	 */
	public String getEndTime() {
		return endTime;
	}

	/**
	 * 수업 종료 시간을 설정 (HH:mm 형식)
	 *
	 * @param endTime 설정할 수업 종료 시간
	 */
	public void setEndTime(String endTime) {
		this.endTime = endTime;
	}

	/**
	 * 최대 학생 수를 반환
	 *
	 * @return 최대 학생 수
	 */
	public int getMaxStudents() {
		return maxStudents;
	}

	/**
	 * 최대 학생 수를 설정
	 *
	 * @param maxStudents 설정할 최대 학생 수
	 */
	public void setMaxStudents(int maxStudents) {
		this.maxStudents = maxStudents;
	}

	/**
	 * 수업료를 반환
	 *
	 * @return 수업료 (원)
	 */
	public int getPrice() {
		return price;
	}

	/**
	 * 수업료를 설정
	 *
	 * @param price 설정할 수업료 (원)
	 */
	public void setPrice(int price) {
		this.price = price;
	}

	/**
	 * 수업 장소를 반환
	 *
	 * @return 수업 장소
	 */
	public String getLocation() {
		return location;
	}

	/**
	 * 수업 장소를 설정
	 *
	 * @param location 설정할 수업 장소
	 */
	public void setLocation(String location) {
		this.location = location;
	}

	/**
	 * 우편번호를 반환
	 *
	 * @return 우편번호
	 */
	public String getZipcode() {
		return zipcode;
	}

	/**
	 * 우편번호를 설정
	 *
	 * @param zipcode 설정할 우편번호
	 */
	public void setZipcode(String zipcode) {
		this.zipcode = zipcode;
	}

	/**
	 * 위도를 반환
	 *
	 * @return 위도
	 */
	public String getLatitude() {
		return latitude;
	}

	/**
	 * 위도를 설정
	 *
	 * @param latitude 설정할 위도
	 */
	public void setLatitude(String latitude) {
		this.latitude = latitude;
	}

	/**
	 * 경도를 반환
	 *
	 * @return 경도
	 */
	public String getLongitude() {
		return longitude;
	}

	/**
	 * 경도를 설정
	 *
	 * @param longitude 설정할 경도
	 */
	public void setLongitude(String longitude) {
		this.longitude = longitude;
	}
}
