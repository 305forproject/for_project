package oneday.model;

/**
 * 사용자 정보를 나타내는 엔티티 클래스
 *
 * <p>이 클래스는 데이터베이스의 USERS 테이블과 매핑되는 객체입니다.
 * 사용자의 기본 정보(ID, 로그인 정보, 이름, 계좌번호)를 관리합니다.</p>
 *
 * <p>데이터베이스 테이블 구조:</p>
 * <ul>
 *   <li>USER_ID - 자동 생성되는 기본키</li>
 *   <li>LOGIN_ID - 로그인용 아이디 (고유값)</li>
 *   <li>PASSWORD - 비밀번호</li>
 *   <li>NAME - 사용자 이름</li>
 *   <li>ACCOUNT - 계좌번호 (선생님만 필수, 학생은 빈 문자열)</li>
 * </ul>
 *
 * <p>사용 예제:</p>
 * <pre>{@code
 * // 회원가입용 사용자 생성
 * User newUser = new User("testuser", "password123", "홍길동");
 *
 * // 기존 사용자 정보 조회 후 수정
 * User user = userDAO.findByLoginId("testuser");
 * user.setAccount("1234567890");
 * }</pre>
 *
 * @author Oneday Team
 * @version 1.0
 * @since 2024
 */
public class User {
    /** 데이터베이스에서 자동 생성되는 사용자의 고유 식별자 */
    private int userId;

    /** 로그인에 사용되는 아이디 (고유값) */
    private String loginId;

    /** 사용자의 비밀번호 */
    private String password;

    /** 사용자의 실명 */
    private String name;

    /** 계좌번호 (선생님만 필수, 학생은 빈 문자열로 저장) */
    private String account;

    /**
     * 기본 생성자
     *
     * <p>JPA나 MyBatis 등의 ORM에서 객체를 생성할 때 사용됩니다.
     * 직접 호출하기보다는 프레임워크에서 내부적으로 사용됩니다.</p>
     */
    public User() {}

    /**
     * 회원가입용 생성자
     *
     * <p>새로운 사용자를 생성할 때 사용하는 생성자입니다.
     * 계좌번호는 자동으로 빈 문자열로 설정됩니다.</p>
     *
     * @param loginId 로그인 아이디 (고유값이어야 함)
     * @param password 비밀번호
     * @param name 사용자 실명
     */
    public User(String loginId, String password, String name) {
        this.loginId = loginId;
        this.password = password;
        this.name = name;
        this.account = "";  // 회원가입 시 계좌번호는 빈 문자열
    }

    // Getters and Setters

    /**
     * 사용자의 고유 식별자를 반환합니다.
     *
     * @return 사용자 ID (데이터베이스 기본키)
     */
    public int getUserId() {
        return userId;
    }

    /**
     * 사용자의 고유 식별자를 설정합니다.
     *
     * <p>일반적으로 데이터베이스에서 조회한 데이터를 객체에 매핑할 때 사용됩니다.
     * 직접 호출할 필요는 거의 없습니다.</p>
     *
     * @param userId 설정할 사용자 ID
     */
    public void setUserId(int userId) {
        this.userId = userId;
    }

    /**
     * 로그인 아이디를 반환합니다.
     *
     * @return 로그인용 아이디
     */
    public String getLoginId() {
        return loginId;
    }

    /**
     * 로그인 아이디를 설정합니다.
     *
     * <p>아이디는 시스템 내에서 고유해야 합니다.
     * 중복 검사는 별도로 수행해야 합니다.</p>
     *
     * @param loginId 설정할 로그인 아이디
     */
    public void setLoginId(String loginId) {
        this.loginId = loginId;
    }

    /**
     * 비밀번호를 반환합니다.
     *
     * <p>보안상 실제 서비스에서는 암호화된 비밀번호를 저장해야 합니다.</p>
     *
     * @return 비밀번호
     */
    public String getPassword() {
        return password;
    }

    /**
     * 비밀번호를 설정합니다.
     *
     * <p>실제 서비스에서는 평문 비밀번호가 아닌 해시된 비밀번호를 저장해야 합니다.</p>
     *
     * @param password 설정할 비밀번호
     */
    public void setPassword(String password) {
        this.password = password;
    }

    /**
     * 사용자 이름을 반환합니다.
     *
     * @return 사용자의 실명
     */
    public String getName() {
        return name;
    }

    /**
     * 사용자 이름을 설정합니다.
     *
     * @param name 설정할 사용자 이름
     */
    public void setName(String name) {
        this.name = name;
    }

    /**
     * 계좌번호를 반환합니다.
     *
     * <p>선생님의 경우 실제 계좌번호가 저장되고,
     * 학생의 경우 빈 문자열이 저장됩니다.</p>
     *
     * @return 계좌번호 (선생님) 또는 빈 문자열 (학생)
     */
    public String getAccount() {
        return account;
    }

    /**
     * 계좌번호를 설정합니다.
     *
     * <p>선생님의 경우에만 실제 계좌번호를 설정하고,
     * 학생의 경우는 빈 문자열을 유지합니다.</p>
     *
     * @param account 설정할 계좌번호
     */
    public void setAccount(String account) {
        this.account = account;
    }
}
