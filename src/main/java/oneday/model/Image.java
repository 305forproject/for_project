package oneday.model;

/**
 * 이미지 정보를 담는 엔티티 클래스
 * IMAGES 테이블과 매핑되는 모델 객체
 */
public class Image {
	private int imageId;
	private int classId;
	private String imageUrl;
	private boolean isRepresentative;
	private boolean isMainSlide;

	public Image() {
	}

	public Image(int classId, String imageUrl, boolean isRepresentative, boolean isMainSlide) {
		this.classId = classId;
		this.imageUrl = imageUrl;
		this.isRepresentative = isRepresentative;
		this.isMainSlide = isMainSlide;
	}

	// Getter와 Setter 메서드들
	public int getImageId() {
		return imageId;
	}

	public void setImageId(int imageId) {
		this.imageId = imageId;
	}

	public int getClassId() {
		return classId;
	}

	public void setClassId(int classId) {
		this.classId = classId;
	}

	public String getImageUrl() {
		return imageUrl;
	}

	public void setImageUrl(String imageUrl) {
		this.imageUrl = imageUrl;
	}

	public boolean isRepresentative() {
		return isRepresentative;
	}

	public void setRepresentative(boolean representative) {
		isRepresentative = representative;
	}

	public boolean isMainSlide() {
		return isMainSlide;
	}

	public void setMainSlide(boolean mainSlide) {
		isMainSlide = mainSlide;
	}
}
