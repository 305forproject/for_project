package oneday.controller;

import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import oneday.dto.SignupForm;
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

		// 1. 요청 파라미터를 SignupForm으로 변환 (Spring에서는 @ModelAttribute로 자동 바인딩)
		SignupForm signupForm = extractSignupForm(request);

		// 2. 유효성 검증 (Spring에서는 @Valid와 Validator 사용)
		String validationError = signupForm.validate();
		if (validationError != null) {
			handleValidationError(request, response, validationError, signupForm);
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
				// 성공 시 리다이렉트 (Spring에서는 "redirect:/signup/success")
				response.sendRedirect(request.getContextPath() + "/signup/success");
			} else {
				handleError(request, response, "회원가입 처리 중 오류가 발생했습니다.", signupForm);
			}

		} catch (IllegalArgumentException e) {
			// 비즈니스 로직 예외 (아이디 중복 등)
			handleError(request, response, e.getMessage(), signupForm);
		} catch (SQLException e) {
			// 데이터베이스 예외
			e.printStackTrace();
			handleError(request, response, "데이터베이스 오류가 발생했습니다.", signupForm);
		}
	}

	/**
	 * 요청 파라미터를 SignupForm 객체로 추출
	 *
	 * <p>Spring에서는 @ModelAttribute로 자동 처리됩니다.</p>
	 */
	private SignupForm extractSignupForm(HttpServletRequest request) {
		SignupForm form = new SignupForm();
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
		String error, SignupForm signupForm)
		throws ServletException, IOException {
		handleError(request, response, error, signupForm);
	}

	/**
	 * 오류 처리 및 뷰로 포워드
	 */
	private void handleError(HttpServletRequest request, HttpServletResponse response,
		String error, SignupForm signupForm)
		throws ServletException, IOException {
		request.setAttribute("error", error);
		request.setAttribute("loginId", signupForm.getLoginId());
		request.setAttribute("name", signupForm.getName()); // name 값도 유지
		request.getRequestDispatcher("/WEB-INF/views/signup.jsp").forward(request, response);
	}
}
