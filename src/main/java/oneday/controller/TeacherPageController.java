package oneday.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import oneday.service.AuthService;

/**
 * 선생님 전용페이지를 처리하는 서블릿 컨트롤러
 *
 * <p>이 클래스는 선생님 전용페이지 접근 요청을 처리합니다.
 * 로그인 확인, 선생님 롤 확인 및 생성, 세션/쿠키 업데이트를 담당합니다.</p>
 *
 * <p>매핑 URL: /teacher-page</p>
 *
 * @author Oneday Team
 * @version 1.0
 * @since 2024
 */
@WebServlet("/teacher-page")
public class TeacherPageController extends HttpServlet {

	/** 로그인 타임아웃 시간 (30분 = 1800초) */
	private static final int LOGIN_TIMEOUT_SECONDS = 1800;

	private AuthService authService = new AuthService();

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
		throws ServletException, IOException {

		HttpSession session = request.getSession(false);

		// 1. 로그인 체크
		if (session == null || session.getAttribute("userId") == null) {
			response.sendRedirect("login");
			return;
		}

		Integer userId = (Integer)session.getAttribute("userId");
		Boolean isTeacher = (Boolean)session.getAttribute("isTeacher");

		try {
			// 2. 선생님 롤 체크 및 생성
			if (isTeacher == null || !isTeacher) {
				// 선생님 롤 생성
				boolean roleCreated = authService.createTeacherRole(userId);

				if (!roleCreated) {
					// 롤 생성 실패
					request.setAttribute("errorMessage", "선생님 권한 생성에 실패했습니다.");
					request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
					return;
				}

				// 세션 업데이트
				session.setAttribute("isTeacher", true);

				// 쿠키 업데이트
				updateTeacherCookie(response, true);
			}

			// 3. 선생님 전용페이지로 이동
			request.setAttribute("userId", userId);
			request.getRequestDispatcher("/WEB-INF/views/teacher-main.jsp").forward(request, response);

		} catch (Exception e) {
			request.setAttribute("errorMessage", "서버 오류가 발생했습니다: " + e.getMessage());
			request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
		}
	}

	private void updateTeacherCookie(HttpServletResponse response, boolean isTeacher) {
		Cookie teacherCookie = new Cookie("isTeacher", String.valueOf(isTeacher));
		teacherCookie.setMaxAge(LOGIN_TIMEOUT_SECONDS);
		teacherCookie.setPath("/");
		response.addCookie(teacherCookie);
	}
}
