package oneday.util;

import com.google.gson.*;
import java.lang.reflect.Type;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class LocalDateTimeAdapter implements JsonSerializer<LocalDateTime>, JsonDeserializer<LocalDateTime> {

	// 날짜 형식을 ISO_LOCAL_DATE_TIME 표준으로 지정 (예: "2025-10-13T18:30:00")
	private static final DateTimeFormatter formatter = DateTimeFormatter.ISO_LOCAL_DATE_TIME;

	// Java 객체(LocalDateTime) -> JSON 문자열로 변환할 때 호출됨
	@Override
	public JsonElement serialize(LocalDateTime localDateTime, Type type, JsonSerializationContext jsonSerializationContext) {
		return new JsonPrimitive(formatter.format(localDateTime));
	}

	// JSON 문자열 -> Java 객체(LocalDateTime)로 변환할 때 호출됨
	@Override
	public LocalDateTime deserialize(JsonElement jsonElement, Type type, JsonDeserializationContext jsonDeserializationContext) throws JsonParseException {
		return LocalDateTime.parse(jsonElement.getAsString(), formatter);
	}
}