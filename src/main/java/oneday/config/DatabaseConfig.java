package oneday.config;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

/**
 * 데이터베이스 연결 설정 관리 클래스
 *
 * <p>이 클래스는 데이터베이스 연결에 필요한 설정을 관리하고
 * Connection 객체를 생성하는 역할을 담당합니다.</p>
 *
 * <p>싱글톤 패턴으로 구현되어 애플리케이션 전체에서
 * 하나의 인스턴스만 사용됩니다.</p>
 *
 * @author Oneday Team
 * @version 1.0
 * @since 2024
 */
public class DatabaseConfig {

    private static DatabaseConfig instance;
    private final Properties properties;

    /**
     * 비공개 생성자 - 싱글톤 패턴 구현
     *
     * <p>database.properties 파일을 로드하고 JDBC 드라이버를 초기화합니다.</p>
     *
     * @throws RuntimeException JDBC 드라이버를 찾을 수 없거나 로드할 수 없는 경우
     */
    private DatabaseConfig() {
        this.properties = loadProperties();
        try {
            // MySQL JDBC 드라이버 클래스를 메모리에 로드
            Class.forName(properties.getProperty("db.driver"));
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("JDBC 드라이버 로드 실패: " +
                properties.getProperty("db.driver"), e);
        }
    }

    /**
     * DatabaseConfig의 싱글톤 인스턴스를 반환합니다.
     *
     * <p>처음 호출 시 인스턴스를 생성하고, 이후 호출에서는
     * 기존 인스턴스를 반환합니다.</p>
     *
     * <p>멀티스레드 환경에서 안전하도록 synchronized 키워드를 사용합니다.</p>
     *
     * @return DatabaseConfig의 유일한 인스턴스
     */
    public static synchronized DatabaseConfig getInstance() {
        if (instance == null) {
            instance = new DatabaseConfig();
        }
        return instance;
    }

    /**
     * database.properties 파일을 로드하여 Properties 객체로 반환합니다.
     *
     * <p>Properties 객체는 다음과 같은 키-값 쌍을 포함합니다:</p>
     * <ul>
     *   <li>db.driver - JDBC 드라이버 클래스명 (예: com.mysql.cj.jdbc.Driver)</li>
     *   <li>db.url - 데이터베이스 연결 URL (예: jdbc:mysql://localhost:3306/oneday_db)</li>
     *   <li>db.username - 데이터베이스 사용자명</li>
     *   <li>db.password - 데이터베이스 비밀번호</li>
     * </ul>
     *
     * @return database.properties 파일의 내용을 담은 Properties 객체
     * @throws RuntimeException properties 파일을 찾을 수 없거나 읽을 수 없는 경우
     */
    private Properties loadProperties() {
        // 빈 Properties 객체 생성 - HashMap을 상속받은 키-값 저장소
        Properties props = new Properties();

        // 클래스패스에서 database.properties 파일을 InputStream으로 읽기
        try (InputStream input = getClass().getClassLoader()
                .getResourceAsStream("database.properties")) {

            if (input == null) {
                throw new RuntimeException(
                    "database.properties 파일을 찾을 수 없습니다. " +
                    "src/main/resources 디렉토리에 파일이 있는지 확인하세요."
                );
            }

            // properties 파일의 내용을 Properties 객체에 로드
            // 파일의 각 라인(key=value)이 Properties 객체의 엔트리로 저장됨
            props.load(input);

        } catch (IOException e) {
            throw new RuntimeException(
                "데이터베이스 설정 파일 로드 실패: " + e.getMessage(), e
            );
        }

        return props;
    }

    /**
     * 데이터베이스 연결을 생성하여 반환합니다.
     *
     * <p>호출할 때마다 새로운 Connection 객체를 생성합니다.
     * 사용이 끝난 Connection은 호출자가 close() 메서드로 반드시 닫아야 합니다.</p>
     *
     * <p>사용 예제:</p>
     * <pre>{@code
     * try (Connection conn = DatabaseConfig.getInstance().getConnection()) {
     *     // SQL 쿼리 실행
     *     Statement stmt = conn.createStatement();
     *     ResultSet rs = stmt.executeQuery("SELECT * FROM users");
     *     // 결과 처리...
     * } catch (SQLException e) {
     *     // 예외 처리
     * }
     * }</pre>
     *
     * @return 새로운 데이터베이스 Connection 객체
     * @throws SQLException 데이터베이스 연결 실패 시
     *                      (예: 잘못된 URL, 사용자명/비밀번호 오류, 네트워크 문제 등)
     */
    public Connection getConnection() throws SQLException {
        String url = properties.getProperty("db.url");
        String username = properties.getProperty("db.username");
        String password = properties.getProperty("db.password");

        // DriverManager를 통해 데이터베이스 연결 생성
        return DriverManager.getConnection(url, username, password);
    }

    /**
     * 데이터베이스 연결 테스트 메서드
     *
     * <p>실제로 데이터베이스에 연결이 가능한지 확인합니다.</p>
     *
     * @return 연결 성공 시 true, 실패 시 false
     */
    public boolean testConnection() {
        try (Connection conn = getConnection()) {
            // isValid() 메서드로 연결 유효성 확인 (5초 타임아웃)
            return conn.isValid(5);
        } catch (SQLException e) {
            System.err.println("데이터베이스 연결 테스트 실패: " + e.getMessage());
            return false;
        }
    }
}
