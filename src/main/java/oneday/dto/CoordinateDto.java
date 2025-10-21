package oneday.dto;

/**
 * 좌표 정보를 담는 DTO 클래스
 * 지도 API로부터 받은 위도/경도 정보를 표현
 */
public record CoordinateDto(String latitude, String longitude) {

	@Override
	public String toString() {
		return "CoordinateDto{latitude='" + latitude + "', longitude='" + longitude + "'}";
	}
}
