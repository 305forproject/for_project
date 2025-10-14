package oneday.controller;

import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import oneday.dto.SignupFormDTO;
import oneday.service.UserService;

/**
 * 회원가입 처리를 담당하는 컨트롤러
 *
 * <p>MVC 패턴의 Controller 역할을 수행하며, Spring 전환 시
 * @Controller와 @RequestMapping으로 대체됩니다.</p>
 *
 * <p>Spring 전환 예시:</p>
 * <pre>
 * {@code
 * @Controller
 * @RequestMapping("/signup")
 * public class SignupController {
 *     @Autowired
 *     private UserService userService;
 *
 *     @GetMapping
 *     public String showSignupForm(Model model) { ... }
 *
 *     @PostMapping
 *     public String processSignup(@ModelAttribute SignupForm form, BindingResult result) { ... }
 * }
 * }
 * </pre>
 *
 * @author Oneday Team
 * @version 1.0
 * @since 2024
 */
@WebServlet("/signup")
public class SignupController extends HttpServlet {

	/** 사용자 서비스 - Spring 전환 시 @Autowired로 주입 */
	private UserService userService;

	/**
	 * 컨트롤러 초기화
	 *
	 * <p>Spring 전환 시 DI(의존성 주입)로 대체됩니다.</p>
	 */
	@Override
	public void init() throws ServletException {
		this.userService = UserService.getInstance();
	}

	/**
	 * GET 요청 처리 - 회원가입 폼 표시
	 *
	 * <p>Spring 전환 시:</p>
	 * <pre>
	 * {@code
	 * @GetMapping
	 * public String showSignupForm(Model model) {
	 *     model.addAttribute("signupForm", new SignupForm());
	 *     return "signup";
	 * }
	 * }
	 * </pre>
	 *
	 * @param request HTTP 요청 객체
	 * @param response HTTP 응답 객체
	 */
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
		throws ServletException, IOException {
		// 뷰로 포워드
		request.getRequestDispatcher("/WEB-INF/views/signup.jsp").forward(request, response);
	}

	/**
	 * POST 요청 처리 - 회원가입 처리
	 *
	 * <p>Spring 전환 시:</p>
	 * <pre>
	 * {@code
	 * @PostMapping
	 * public String processSignup(@Valid @ModelAttribute SignupForm form,
	 *                            BindingResult result,
	 *                            RedirectAttributes redirectAttributes) {
	 *     if (result.hasErrors()) {
	 *         return "signup";
	 *     }
	 *     // 처리 로직
	 *     return "redirect:/signup/success";
	 * }
	 * }
	 * </pre>
	 *
	 * @param request HTTP 요청 객체
	 * @param response HTTP 응답 객체
	 */
	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
		throws ServletException, IOException {

		request.setCharacterEncoding("UTF-8");

		// 1. 요청 파라미터를 SignupForm으로 변환
		SignupFormDTO signupForm = extractSignupForm(request);

		// 2. 유효성 검증
		String validationError = signupForm.validate();
		if (validationError != null) {
			// 에러 시 모달에서 에러 메시지 표시하도록 메인 페이지로 forward
			request.setAttribute("signupError", validationError);
			request.getRequestDispatcher("/WEB-INF/views/index-home.jsp").forward(request, response);
			return;
		}

		// 3. 비즈니스 로직 처리
		try {
			boolean success = userService.signup(
				signupForm.getLoginId(),
				signupForm.getPassword(),
				signupForm.getName()
			);

			if (success) {
				// 성공 시 메인 페이지로 forward하며 성공 메시지 전달
				request.setAttribute("signupSuccess", "회원가입이 성공적으로 완료되었습니다!");
				request.getRequestDispatcher("/WEB-INF/views/index-home.jsp").forward(request, response);
			} else {
				request.setAttribute("signupError", "회원가입 처리 중 오류가 발생했습니다.");
				request.getRequestDispatcher("/WEB-INF/views/index-home.jsp").forward(request, response);
			}

		} catch (IllegalArgumentException e) {
			// 비즈니스 로직 예외 (아이디 중복 등)
			request.setAttribute("signupError", e.getMessage());
			request.getRequestDispatcher("/WEB-INF/views/index-home.jsp").forward(request, response);
		} catch (SQLException e) {
			// 데이터베이스 예외
			e.printStackTrace();
			request.setAttribute("signupError", "서버 오류가 발생했습니다. 잠시 후 다시 시도해주세요.");
			request.getRequestDispatcher("/WEB-INF/views/index-home.jsp").forward(request, response);
		}
	}

	/**
	 * 요청 파라미터를 SignupForm 객체로 추출
	 *
	 * <p>Spring에서는 @ModelAttribute로 자동 처리됩니다.</p>
	 */
	private SignupFormDTO extractSignupForm(HttpServletRequest request) {
		SignupFormDTO form = new SignupFormDTO();
		form.setLoginId(request.getParameter("loginId"));
		form.setPassword(request.getParameter("password"));
		form.setPasswordConfirm(request.getParameter("passwordConfirm"));
		form.setName(request.getParameter("name"));
		return form;
	}

	/**
	 * 유효성 검증 오류 처리
	 */
	private void handleValidationError(HttpServletRequest request, HttpServletResponse response,
		String error, SignupFormDTO signupForm)
		throws ServletException, IOException {
		handleError(request, response, error, signupForm);
	}

	/**
	 * 오류 처리 및 뷰로 포워드
	 */
	private void handleError(HttpServletRequest request, HttpServletResponse response,
		String error, SignupFormDTO signupForm)
		throws ServletException, IOException {
		request.setAttribute("error", error);
		request.setAttribute("loginId", signupForm.getLoginId());
		request.setAttribute("name", signupForm.getName()); // name 값도 유지
		request.getRequestDispatcher("/WEB-INF/views/signup.jsp").forward(request, response);
	}
}
