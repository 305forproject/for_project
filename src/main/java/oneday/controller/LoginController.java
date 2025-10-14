package oneday.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import oneday.model.Role;
import oneday.model.User;
import oneday.repository.UserDAO;
import oneday.service.AuthService;

/**
 * 로그인 처리를 담당하는 서블릿 컨트롤러
 */
@WebServlet("/login")
public class LoginController extends HttpServlet {
	/** 로그인 세션 타임아웃 시간 (30분 = 1800초) */
	private static final int LOGIN_TIMEOUT_SECONDS = 1800;

	/** 사용자 인증을 위한 서비스 인스턴스 */
	private final AuthService authService = new AuthService();

	/** 사용자 역할 정보 조회를 위한 DAO 인스턴스 */
	private final UserDAO userDAO = new UserDAO();

	/**
	 * POST 요청을 처리하여 로그인 인증을 수행합니다.
	 */
	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
		throws ServletException, IOException {
		String loginId = request.getParameter("loginId");
		String password = request.getParameter("password");

		User user = authService.authenticate(loginId, password);

		if (user != null) {
			try {
				// 사용자의 모든 역할 조회
				List<Role> userRoles = userDAO.getUserRoles(user.getUserId());

				// 역할 정보 확인
				boolean isTeacher = false;
				boolean isStudent = false;

				for (Role role : userRoles) {
					if (role == Role.TEACHER) {
						isTeacher = true;
					}
					if (role == Role.STUDENT) {
						isStudent = true;
					}
				}

				// 쿠키 생성
				Cookie userIdCookie = new Cookie("userId", String.valueOf(user.getUserId()));
				Cookie isTeacherCookie = new Cookie("isTeacher", String.valueOf(isTeacher));
				Cookie isStudentCookie = new Cookie("isStudent", String.valueOf(isStudent));

				// 쿠키 설정
				Cookie[] cookies = {userIdCookie, isTeacherCookie, isStudentCookie};
				for (Cookie cookie : cookies) {
					cookie.setMaxAge(LOGIN_TIMEOUT_SECONDS);
					cookie.setPath("/");
					cookie.setHttpOnly(false);
					cookie.setSecure(false);

					response.addCookie(cookie);
				}

				// 세션 생성 및 사용자 정보 저장
				HttpSession session = request.getSession(true);
				session.setAttribute("userId", user.getUserId());
				session.setAttribute("userName", user.getName());
				session.setAttribute("isTeacher", isTeacher);
				session.setAttribute("isStudent", isStudent);
				session.setMaxInactiveInterval(LOGIN_TIMEOUT_SECONDS);

				// 로그인 성공 시 /main으로 리다이렉트
				response.sendRedirect(request.getContextPath() + "/main");
			} catch (SQLException e) {
				e.printStackTrace();
				// 데이터베이스 오류 시 에러 메시지 설정
				request.setAttribute("error", "서버 오류가 발생했습니다. 잠시 후 다시 시도해주세요.");
				request.getRequestDispatcher("/WEB-INF/views/index-home.jsp").forward(request, response);
			}
		} else {
			// 로그인 실패 시 에러 메시지 설정 후 다시 메인 페이지로 포워드
			request.setAttribute("error", "아이디 또는 비밀번호가 올바르지 않습니다.");
			request.getRequestDispatcher("/WEB-INF/views/index-home.jsp").forward(request, response);
		}
	}
}
