package oneday.test;

import oneday.config.DatabaseConfig;
import java.sql.*;

/**
 * DatabaseConfig 테스트 클래스
 *
 * 실행 방법:
 * 1. src/main/resources/database.properties 파일 확인
 * 2. 이 클래스의 main 메서드 실행
 * 3. 콘솔에서 결과 확인
 */
public class DatabaseConfigTest {

    public static void main(String[] args) {
        System.out.println("=== DatabaseConfig 테스트 시작 ===\n");

        // 1. 싱글톤 인스턴스 테스트
        testSingletonInstance();

        // 2. 데이터베이스 연결 테스트
        testDatabaseConnection();

        // 3. 실제 쿼리 실행 테스트 (테이블이 있다면)
        testSimpleQuery();

        System.out.println("\n=== 모든 테스트 완료 ===");
    }

    /**
     * 싱글톤 패턴이 제대로 작동하는지 테스트
     */
    private static void testSingletonInstance() {
        System.out.println("[테스트 1] 싱글톤 인스턴스 확인");

        DatabaseConfig instance1 = DatabaseConfig.getInstance();
        DatabaseConfig instance2 = DatabaseConfig.getInstance();

        if (instance1 == instance2) {
            System.out.println("✅ 성공: 동일한 인스턴스 반환됨");
        } else {
            System.out.println("❌ 실패: 서로 다른 인스턴스가 생성됨");
        }
        System.out.println();
    }

    /**
     * 데이터베이스 연결 테스트
     */
    private static void testDatabaseConnection() {
        System.out.println("[테스트 2] 데이터베이스 연결 확인");

        DatabaseConfig config = DatabaseConfig.getInstance();

        // testConnection() 메서드 사용
        if (config.testConnection()) {
            System.out.println("✅ 성공: 데이터베이스 연결 성공!");
        } else {
            System.out.println("❌ 실패: 데이터베이스 연결 실패");
            System.out.println("   database.properties 파일 설정을 확인하세요:");
            System.out.println("   - db.url이 올바른가?");
            System.out.println("   - db.username과 db.password가 맞는가?");
            System.out.println("   - MySQL 서버가 실행 중인가?");
        }

        // 직접 Connection 객체 생성 테스트
        try (Connection conn = config.getConnection()) {
            DatabaseMetaData metaData = conn.getMetaData();
            System.out.println("📊 데이터베이스 정보:");
            System.out.println("   - 제품명: " + metaData.getDatabaseProductName());
            System.out.println("   - 버전: " + metaData.getDatabaseProductVersion());
            System.out.println("   - 드라이버: " + metaData.getDriverName());
            System.out.println("   - URL: " + metaData.getURL());

        } catch (SQLException e) {
            System.out.println("❌ SQLException 발생: " + e.getMessage());
        }
        System.out.println();
    }

    /**
     * 간단한 쿼리 실행 테스트
     * 실제 테이블이 없어도 작동하는 쿼리 사용
     */
    private static void testSimpleQuery() {
        System.out.println("[테스트 3] 쿼리 실행 테스트");

        DatabaseConfig config = DatabaseConfig.getInstance();

        try (Connection conn = config.getConnection();
             Statement stmt = conn.createStatement()) {

            // MySQL의 간단한 시스템 정보 조회
            ResultSet rs = stmt.executeQuery("SELECT NOW() as current_time, VERSION() as mysql_version");

            if (rs.next()) {
                System.out.println("✅ 쿼리 실행 성공:");
                System.out.println("   - 현재 시간: " + rs.getString("current_time"));
                System.out.println("   - MySQL 버전: " + rs.getString("mysql_version"));
            }

            // 현재 데이터베이스 이름 확인
            rs = stmt.executeQuery("SELECT DATABASE() as db_name");
            if (rs.next()) {
                System.out.println("   - 현재 데이터베이스: " + rs.getString("db_name"));
            }

            // 테이블 목록 확인 (있다면)
            rs = stmt.executeQuery("SHOW TABLES");
            System.out.println("\n📋 테이블 목록:");
            boolean hasTable = false;
            while (rs.next()) {
                System.out.println("   - " + rs.getString(1));
                hasTable = true;
            }
            if (!hasTable) {
                System.out.println("   (테이블이 없습니다)");
            }

        } catch (SQLException e) {
            System.out.println("❌ 쿼리 실행 실패: " + e.getMessage());
        }
    }
}
