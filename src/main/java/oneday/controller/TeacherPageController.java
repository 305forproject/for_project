package oneday.controller;

import java.io.IOException;
import java.sql.SQLException;

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
 * <p>이 클래스는 선생님 전용페이지 접근 요청과 계좌번호 등록을 처리합니다.
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

	private final AuthService authService = new AuthService();

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
			// 2. 선생님 롤 체크 및 부여
			if (isTeacher == null || !isTeacher) {
				// 선생님 롤 부여
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

			// 3. 강사 캘린더 페이지로 이동
			request.setAttribute("userId", userId);
			request.getRequestDispatcher("/WEB-INF/views/teacherCalendar.jsp").forward(request, response);

		} catch (Exception e) {
			request.setAttribute("errorMessage", "서버 오류가 발생했습니다: " + e.getMessage());
			request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
		}
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
		throws ServletException, IOException {

		// 1. 로그인 상태 확인
		HttpSession session = request.getSession(false);
		if (session == null || session.getAttribute("userId") == null) {
			response.sendRedirect(request.getContextPath() + "/main");
			return;
		}

		Integer userId = (Integer)session.getAttribute("userId");
		String accountNumber = request.getParameter("accountNumber");

		// 2. 계좌번호 유효성 검사
		if (accountNumber == null || accountNumber.trim().isEmpty()) {
			response.sendRedirect(request.getContextPath() + "/main?error=invalid-account");
			return;
		}

		accountNumber = accountNumber.trim();
		if (accountNumber.length() < 10) {
			response.sendRedirect(request.getContextPath() + "/main?error=invalid-account");
			return;
		}

		try {
			// 3. 강사 계좌번호 등록 처리
			boolean success = authService.registerTeacherAccount(userId, accountNumber);

			if (success) {
				// 4. 세션과 쿠키 업데이트
				session.setAttribute("isTeacher", true);
				updateTeacherCookie(response, true);

				// 5. 성공 메시지와 함께 메인 페이지로 리다이렉트
				response.sendRedirect(request.getContextPath() + "/main?success=teacher-registered");
			} else {
				// 실패 시 에러 메시지와 함께 메인 페이지로 리다이렉트
				response.sendRedirect(request.getContextPath() + "/main?error=registration-failed");
			}

		} catch (SQLException e) {
			e.printStackTrace();
			response.sendRedirect(request.getContextPath() + "/main?error=server-error");
		} catch (Exception e) {
			e.printStackTrace();
			response.sendRedirect(request.getContextPath() + "/main?error=server-error");
		}
	}

	private void updateTeacherCookie(HttpServletResponse response, boolean isTeacher) {
		Cookie teacherCookie = new Cookie("isTeacher", String.valueOf(isTeacher));
		teacherCookie.setMaxAge(LOGIN_TIMEOUT_SECONDS);
		teacherCookie.setPath("/");
		teacherCookie.setHttpOnly(false);
		teacherCookie.setSecure(false);
		response.addCookie(teacherCookie);
	}
}
