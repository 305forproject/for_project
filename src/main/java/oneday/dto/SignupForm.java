package oneday.dto;

/**
 * 회원가입 폼 데이터 전송 객체
 *
 * <p>Spring 전환 시 Bean Validation 어노테이션이 추가됩니다:</p>
 * <pre>
 * {@code
 * public class SignupForm {
 *     @NotBlank(message = "아이디를 입력해주세요.")
 *     @Size(min = 4, max = 20, message = "아이디는 4~20자로 입력해주세요.")
 *     private String loginId;
 *
 *     @NotBlank(message = "비밀번호를 입력해주세요.")
 *     @Size(min = 6, max = 20, message = "비밀번호는 6~20자로 입력해주세요.")
 *     private String password;
 *
 *     @NotBlank(message = "비밀번호 확인을 입력해주세요.")
 *     private String passwordConfirm;
 * }
 * }
 * </pre>
 *
 * @author Oneday Team
 * @version 1.0
 * @since 2024
 */
public class SignupForm {

	private String loginId;
	private String password;
	private String passwordConfirm;
	private String name;

	/**
	 * 기본 생성자
	 */
	public SignupForm() {
	}

	/**
	 * 모든 필드를 초기화하는 생성자
	 *
	 * @param loginId 로그인 아이디
	 * @param password 비밀번호
	 * @param passwordConfirm 비밀번호 확인
	 * @param name 사용자 이름
	 */
	public SignupForm(String loginId, String password, String passwordConfirm, String name) {
		this.loginId = loginId;
		this.password = password;
		this.passwordConfirm = passwordConfirm;
		this.name = name;
	}

	/**
	 * 비밀번호 일치 여부 확인
	 *
	 * @return 비밀번호가 일치하면 true, 아니면 false
	 */
	public boolean isPasswordMatching() {
		return password != null && password.equals(passwordConfirm);
	}

	/**
	 * 유효성 검증
	 *
	 * <p>Spring 전환 시 @Valid 어노테이션과 Validator로 대체됩니다.</p>
	 *
	 * @return 유효성 검증 통과 시 null, 오류 시 에러 메시지
	 */
	public String validate() {
		if (loginId == null || loginId.trim().isEmpty()) {
			return "아이디를 입력해주세요.";
		}
		if (loginId.length() < 4 || loginId.length() > 20) {
			return "아이디는 4~20자로 입력해주세요.";
		}
		if (password == null || password.trim().isEmpty()) {
			return "비밀번호를 입력해주세요.";
		}
		if (password.length() < 6 || password.length() > 20) {
			return "비밀번호는 6~20자로 입력해주세요.";
		}
		if (!isPasswordMatching()) {
			return "비밀번호가 일치하지 않습니다.";
		}
		return null;
	}

	// Getters and Setters
	public String getLoginId() {
		return loginId;
	}

	public void setLoginId(String loginId) {
		this.loginId = loginId;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getPasswordConfirm() {
		return passwordConfirm;
	}

	public void setPasswordConfirm(String passwordConfirm) {
		this.passwordConfirm = passwordConfirm;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}
}
