package oneday.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * 로그아웃 처리를 담당하는 서블릿 컨트롤러
 *
 * <p>이 클래스는 사용자의 로그아웃 요청을 처리합니다.
 * 세션을 무효화하고 로그인 페이지로 리다이렉트합니다.</p>
 *
 * <p>매핑 URL: /logout</p>
 *
 * @author Oneday Team
 * @version 1.0
 * @since 2024
 */
@WebServlet("/logout")
public class LogoutController extends HttpServlet {

	/**
	 * GET 요청을 처리하여 로그아웃을 수행합니다.
	 *
	 * <p>현재 세션을 무효화하고 모든 관련 쿠키를 삭제한 후 로그인 페이지로 리다이렉트합니다.</p>
	 *
	 * @param request HTTP 요청 객체
	 * @param response HTTP 응답 객체
	 * @throws ServletException 서블릿 처리 중 오류가 발생한 경우
	 * @throws IOException 입출력 오류가 발생한 경우
	 */
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
		throws ServletException, IOException {

		// 세션 무효화
		HttpSession session = request.getSession(false);
		if (session != null) {
			session.invalidate();
		}

		// 쿠키 삭제
		Cookie userIdCookie = new Cookie("userId", "");
		Cookie isTeacherCookie = new Cookie("isTeacher", "");
		Cookie isStudentCookie = new Cookie("isStudent", "");

		// 쿠키 만료 시간을 0으로 설정하여 삭제
		Cookie[] cookiesToDelete = {userIdCookie, isTeacherCookie, isStudentCookie};

		for (Cookie cookie : cookiesToDelete) {
			cookie.setMaxAge(0);
			cookie.setPath("/");
			cookie.setHttpOnly(true);
			cookie.setSecure(request.isSecure());

			response.addCookie(cookie);
		}

		// 로그인 페이지로 리다이렉트
		response.sendRedirect("login");
	}

	/**
	 * POST 요청을 처리하여 로그아웃을 수행합니다.
	 *
	 * <p>GET 메서드에 위임하여 처리합니다.</p>
	 *
	 * @param request HTTP 요청 객체
	 * @param response HTTP 응답 객체
	 * @throws ServletException 서블릿 처리 중 오류가 발생한 경우
	 * @throws IOException 입출력 오류가 발생한 경우
	 */
	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
		throws ServletException, IOException {
		doGet(request, response);
	}
}
