package oneday.dto;

public class FullCalendarEventDto {

	private String id;       // 이벤트 고유 ID (reservationId)
	private String title;    // 달력에 표시될 제목 (category)
	private String start;    // 시작 시간 (ISO 8601 형식 문자열)
	private String end;      // 종료 시간 (ISO 8601 형식 문자열)

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getStart() {
		return start;
	}

	public void setStart(String start) {
		this.start = start;
	}

	public String getEnd() {
		return end;
	}

	public void setEnd(String end) {
		this.end = end;
	}
}