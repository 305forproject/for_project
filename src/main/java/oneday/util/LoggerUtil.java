package oneday.util;

import java.io.IOException;
import java.util.logging.*;

public class LoggerUtil {

	// 로거
	private static final Logger topLogger = Logger.getLogger("oneday");

	// static: 클래스가 로드시 한 번만 실행
	static {
		try {
			// 기본 핸들러 제거, 중복 출력을 방지
			topLogger.setUseParentHandlers(false);

			// 새 핸들러 생성
			ConsoleHandler handler = new ConsoleHandler();

			// 출력 형식 지정하는 포매터 생성
			SimpleFormatter formatter = new SimpleFormatter();
			handler.setFormatter(formatter);

			// 로거 핸들러 추가
			topLogger.addHandler(handler);

			// 로그 레벨 설정
			// INFO 레벨 이상의 로그만 출력 -> INFO, WARNING,SEVERE 3가지
			topLogger.setLevel(Level.INFO);

		} catch (SecurityException e) {
			e.printStackTrace();
		}
	}

	public static Logger getLogger(String className) {
		return Logger.getLogger(className);
	}
}