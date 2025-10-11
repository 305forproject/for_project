package oneday.service;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import oneday.dto.CoordinateDto;

/**
 * Kakao Map REST API를 사용하여 주소를 좌표로 변환하는 서비스
 */
public class KakaoMapService {
	private static KakaoMapService instance;
	private static final String KAKAO_API_KEY = "cd113cc26d1219d44007491db261deb6";
	private static final String GEOCODING_URL = "https://dapi.kakao.com/v2/local/search/address.json";
	private static final ObjectMapper objectMapper = new ObjectMapper();

	private KakaoMapService() {
	}

	public static synchronized KakaoMapService getInstance() {
		if (instance == null) {
			instance = new KakaoMapService();
		}
		return instance;
	}

	/**
	 * 주소를 좌표로 변환
	 *
	 * @param address 변환할 주소
	 * @return 좌표 정보, 실패 시 null
	 */
	public CoordinateDto getCoordinatesFromAddress(String address) {
		try {
			String encodedAddress = URLEncoder.encode(address, StandardCharsets.UTF_8);
			String urlString = GEOCODING_URL + "?query=" + encodedAddress;

			URL url = new URL(urlString);
			HttpURLConnection conn = (HttpURLConnection)url.openConnection();

			conn.setRequestMethod("GET");
			conn.setRequestProperty("Authorization", "KakaoAK " + KAKAO_API_KEY);
			conn.setRequestProperty("Content-Type", "application/json");
			conn.setRequestProperty("User-Agent", "Mozilla/5.0 (Java Application)");
			conn.setConnectTimeout(5000);
			conn.setReadTimeout(5000);

			int responseCode = conn.getResponseCode();

			if (responseCode == HttpURLConnection.HTTP_OK) {
				BufferedReader reader = new BufferedReader(
					new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8)
				);
				StringBuilder response = new StringBuilder();
				String line;

				while ((line = reader.readLine()) != null) {
					response.append(line);
				}
				reader.close();

				return parseCoordinatesFromResponse(response.toString());

			} else {
				return null;
			}

		} catch (IOException e) {
			return null;
		}
	}

	/**
	 * JSON 응답에서 좌표 정보 추출 (Jackson 라이브러리 사용)
	 */
	private CoordinateDto parseCoordinatesFromResponse(String jsonResponse) {
		try {
			JsonNode root = objectMapper.readTree(jsonResponse);

			JsonNode documents = root.get("documents");
			if (documents == null || !documents.isArray() || documents.isEmpty()) {
				return null;
			}

			JsonNode firstDocument = documents.get(0);
			String latitude = firstDocument.get("y").asText();
			String longitude = firstDocument.get("x").asText();

			return new CoordinateDto(latitude, longitude);

		} catch (Exception e) {
			return null;
		}
	}
}
