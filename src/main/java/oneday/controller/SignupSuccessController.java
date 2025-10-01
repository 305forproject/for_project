package oneday.controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * 회원가입 성공 페이지 컨트롤러
 *
 * <p>회원가입 성공 후 표시되는 페이지를 담당하는 컨트롤러입니다.
 * Spring 전환 시 @Controller와 @GetMapping으로 대체됩니다.</p>
 *
 * <p>Spring 전환 예시:</p>
 * <pre>
 * {@code
 * @Controller
 * public class SignupSuccessController {
 *
 *     @GetMapping("/signup/success")
 *     public String showSuccessPage() {
 *         return "signup-success";
 *     }
 * }
 * }
 * </pre>
 *
 * @author Oneday Team
 * @version 1.0
 * @since 2024
 */
@WebServlet("/signup/success")
public class SignupSuccessController extends HttpServlet {

    /**
     * GET 요청 처리 - 회원가입 성공 페이지 표시
     *
     * <p>Spring 전환 시:</p>
     * <pre>
     * {@code
     * @GetMapping("/signup/success")
     * public String showSuccessPage(Model model) {
     *     // 필요시 모델에 데이터 추가
     *     model.addAttribute("message", "회원가입이 완료되었습니다.");
     *     return "signup-success";
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

        // 성공 메시지 설정 (선택적)
        request.setAttribute("message", "회원가입이 성공적으로 완료되었습니다.");

        // 뷰로 포워드
        request.getRequestDispatcher("/WEB-INF/views/signup-success.jsp").forward(request, response);
    }

    /**
     * POST 요청은 지원하지 않음
     *
     * <p>이 페이지는 GET 요청만 처리합니다.</p>
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // POST 요청은 GET으로 리다이렉트
        response.sendRedirect(request.getContextPath() + "/signup/success");
    }
}
