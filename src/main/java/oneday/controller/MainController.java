package oneday.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * 메인 페이지를 처리하는 서블릿 컨트롤러
 *
 * <p>이 클래스는 루트 URL(/)에 대한 요청을 처리하여 메인 페이지를 표시합니다.
 * 세션에서 사용자 ID와 역할 정보를 조회하여 메인 JSP 페이지로 포워드합니다.</p>
 *
 * <p>세션에 저장된 필수 정보(userId, isTeacher, isStudent)만을 사용하여
 * 이를 request 속성으로 설정하여 JSP에서 사용할 수 있도록 합니다.</p>
 *
 * <p>매핑 URL: /</p>
 *
 * @author Oneday Team
 * @version 1.0
 * @since 2024
 */
@WebServlet("/")
public class MainController extends HttpServlet {

	/**
	 * GET 요청을 처리하여 메인 페이지를 표시합니다.
	 *
	 * <p>세션에서 사용자 정보와 역할을 확인하고, 로그인되지 않은 경우 로그인 페이지로 리다이렉트합니다.
	 * 로그인된 사용자의 경우 세션의 핵심 정보만을 사용하여 메인 JSP 페이지로 포워드합니다.</p>
	 *
	 * @param request HTTP 요청 객체
	 * @param response HTTP 응답 객체
	 * @throws ServletException 서블릿 처리 중 오류가 발생한 경우
	 * @throws IOException 입출력 오류가 발생한 경우
	 */
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
		throws ServletException, IOException {
		HttpSession session = request.getSession(false);

		if (session == null || session.getAttribute("userId") == null) {
			// 로그인되지 않은 경우 로그인 페이지로 리다이렉트
			response.sendRedirect("login");
			return;
		}

		// 세션에서 필요한 정보만 가져오기
		Integer userId = (Integer)session.getAttribute("userId");
		Boolean isTeacher = (Boolean)session.getAttribute("isTeacher");
		Boolean isStudent = (Boolean)session.getAttribute("isStudent");

		// 요청 속성 설정 (JSP에서 사용)
		request.setAttribute("userId", userId);
		request.setAttribute("isTeacher", isTeacher);
		request.setAttribute("isStudent", isStudent);

		// 메인 페이지로 포워드
		request.getRequestDispatcher("/WEB-INF/views/main.jsp").forward(request, response);
	}
}
