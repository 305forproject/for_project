package oneday.config;

import java.io.InputStream;
import java.util.Properties;

public class PaymentConfig {

	private static final Properties properties = new Properties();

	// 클래스가 로드될 때 static 블록이 실행되어 파일을 한번만 읽습니다.
	static {
		try (InputStream input = PaymentConfig.class.getClassLoader().getResourceAsStream("payment.properties")) {
			if (input == null) {
				System.out.println("Error: payment.properties 파일을 찾을 수 없습니다.");
			}
			properties.load(input);
		} catch (Exception ex) {
			ex.printStackTrace();
		}
	}

	/**
	 * properties 파일에서 secretKey 값을 가져옵니다.
	 * @return payment.secretKey 값
	 */
	public static String getSecretKey() {
		return properties.getProperty("payment.secretKey");
	}
}