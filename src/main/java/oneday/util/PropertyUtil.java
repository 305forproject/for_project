package oneday.util;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

/**
 * Properties 파일 로드 유틸리티
 */
public class PropertyUtil {
    private static final Properties kakaoProperties = new Properties();

    static {
        try (InputStream input = PropertyUtil.class.getClassLoader()
                .getResourceAsStream("kakao.properties")) {
            if (input == null) {
                throw new RuntimeException("kakao.properties 파일을 찾을 수 없습니다.");
            }
            kakaoProperties.load(input);
        } catch (IOException e) {
            throw new RuntimeException("kakao.properties 로드 중 오류 발생", e);
        }
    }

    /**
     * Kakao API Key를 반환합니다.
     * @return Kakao API Key
     */
    public static String getKakaoApiKey() {
        return kakaoProperties.getProperty("kakao.api.key");
    }

    /**
     * Kakao JavaScript Key를 반환합니다.
     * @return Kakao JavaScript Key
     */
    public static String getKakaoJavascriptKey() {
        return kakaoProperties.getProperty("kakao.javascript.key");
    }
}

