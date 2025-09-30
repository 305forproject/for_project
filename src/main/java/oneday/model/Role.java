package oneday.model;

/**
 * 사용자 역할을 정의하는 Enum 클래스
 *
 * <p>이 Enum은 시스템에서 사용자가 가질 수 있는 역할을 정의합니다.
 * 각 역할은 고유한 ID, 이름, 표시명을 가지고 있습니다.</p>
 *
 * <p>현재 지원하는 역할:</p>
 * <ul>
 *   <li>TEACHER - 선생님 (roleId: 1)</li>
 *   <li>STUDENT - 학생 (roleId: 2)</li>
 * </ul>
 *
 * <p>사용 예제:</p>
 * <pre>{@code
 * Role userRole = Role.STUDENT;
 * int roleId = userRole.getRoleId();  // 2
 * String displayName = userRole.getDisplayName();  // "학생"
 *
 * // ID로 역할 찾기
 * Role role = Role.findByRoleId(1);  // TEACHER 반환
 * }</pre>
 *
 * @author Oneday Team
 * @version 1.0
 * @since 2024
 */
public enum Role {
    /** 선생님 역할 - 클래스를 개설하고 관리할 수 있는 권한 */
    TEACHER(1, "TEACHER", "선생님"),

    /** 학생 역할 - 클래스를 예약하고 수강할 수 있는 권한 */
    STUDENT(2, "STUDENT", "학생");

    /** 데이터베이스의 역할 ID */
    private final int roleId;

    /** 데이터베이스의 역할 이름 */
    private final String roleName;

    /** 사용자에게 표시될 역할명 (한국어) */
    private final String displayName;

    /**
     * Role Enum 생성자
     *
     * @param roleId 데이터베이스의 역할 ID
     * @param roleName 데이터베이스의 역할 이름 (영문)
     * @param displayName 사용자 인터페이스에 표시될 이름 (한국어)
     */
    Role(int roleId, String roleName, String displayName) {
        this.roleId = roleId;
        this.roleName = roleName;
        this.displayName = displayName;
    }

    /**
     * 역할의 데이터베이스 ID를 반환합니다.
     *
     * @return 역할 ID (정수값)
     */
    public int getRoleId() {
        return roleId;
    }

    /**
     * 역할의 영문 이름을 반환합니다.
     *
     * @return 역할 이름 (예: "TEACHER", "STUDENT")
     */
    public String getRoleName() {
        return roleName;
    }

    /**
     * 사용자에게 표시될 역할의 한국어 이름을 반환합니다.
     *
     * @return 표시용 이름 (예: "선생님", "학생")
     */
    public String getDisplayName() {
        return displayName;
    }

    /**
     * 주어진 역할 ID에 해당하는 Role Enum을 찾아 반환합니다.
     *
     * <p>데이터베이스에서 조회한 roleId를 통해 해당하는 Role을 찾을 때 사용합니다.</p>
     *
     * @param roleId 찾고자 하는 역할의 ID
     * @return 해당하는 Role Enum 객체
     * @throws IllegalArgumentException 유효하지 않은 roleId가 전달된 경우
     */
    public static Role findByRoleId(int roleId) {
        for (Role role : values()) {
            if (role.getRoleId() == roleId) {
                return role;
            }
        }
        throw new IllegalArgumentException("유효하지 않은 역할 ID입니다: " + roleId);
    }

    /**
     * 주어진 역할 이름에 해당하는 Role Enum을 찾아 반환합니다.
     *
     * <p>대소문자를 구분하지 않고 검색합니다.</p>
     *
     * @param roleName 찾고자 하는 역할의 이름 (예: "TEACHER", "teacher")
     * @return 해당하는 Role Enum 객체
     * @throws IllegalArgumentException 유효하지 않은 roleName이 전달된 경우
     */
    public static Role findByRoleName(String roleName) {
        for (Role role : values()) {
            if (role.getRoleName().equalsIgnoreCase(roleName)) {
                return role;
            }
        }
        throw new IllegalArgumentException("유효하지 않은 역할 이름입니다: " + roleName);
    }
}
