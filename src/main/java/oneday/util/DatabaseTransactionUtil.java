package oneday.util;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.function.Function;

import oneday.config.DatabaseConfig;

/**
 * 데이터베이스 트랜잭션 처리를 위한 완전한 유틸리티 클래스
 */
public class DatabaseTransactionUtil {

	/**
	 * 트랜잭션을 실행합니다.
	 * @param operation 트랜잭션 내에서 실행할 작업
	 * @return 작업 결과
	 */
	public static <T> T executeTransaction(Function<Connection, T> operation) {
		Connection conn = null;

		try {
			conn = DatabaseConfig.getInstance().getConnection();
			conn.setAutoCommit(false);

			T result = operation.apply(conn);

			conn.commit();
			return result;

		} catch (Exception e) {
			safeRollback(conn);
			throw new RuntimeException("트랜잭션 실행 중 오류가 발생했습니다.", e);
		} finally {
			safeClose(conn);
		}
	}

	/**
	 * 트랜잭션을 실행하고 boolean 결과를 반환합니다.
	 * @param operation 트랜잭션 내에서 실행할 작업
	 * @return 작업 성공 여부
	 */
	public static boolean executeTransactionForBoolean(Function<Connection, Boolean> operation) {
		try {
			return executeTransaction(operation);
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
	}

	/**
	 * 연결을 안전하게 롤백합니다.
	 */
	public static void safeRollback(Connection conn) {
		try {
			if (conn != null) {
				conn.rollback();
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	/**
	 * 연결을 안전하게 닫습니다.
	 */
	public static void safeClose(Connection conn) {
		try {
			if (conn != null) {
				conn.setAutoCommit(true);
				conn.close();
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
}
