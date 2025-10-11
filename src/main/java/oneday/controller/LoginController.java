package oneday.controller;

import oneday.model.Role;
import oneday.model.User;
import oneday.repository.UserDAO;
import oneday.service.AuthService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

/**
 * 로그인 처리를 담당하는 서블릿 컨트롤러
 *
 * <p>이 클래스는 사용자의 로그인 요청을 처리합니다.
 * GET 요청 시 로그인 폼을 보여주고, POST 요청 시 로그인 인증을 수행합니다.</p>
 *
 * <p>로그인 성공 시 세션에 사용자 ID를 저장하고 메인 페이지로 리다이렉트하며,
 * 실패 시 오류 메시지와 함께 로그인 페이지를 다시 표시합니다.</p>
 *
 * <p>매핑 URL: /login</p>
 *
 * @author Oneday Team
 * @version 1.0
 * @since 2024
 */
@WebServlet("/login")
public class LoginController extends HttpServlet {
	/** 로그인 세션 타임아웃 시간 (30분 = 1800초) */
	private static final int LOGIN_TIMEOUT_SECONDS = 1800;

	/** 사용자 인증을 위한 서비스 인스턴스 */
	private AuthService authService = new AuthService();

	/** 사용자 역할 정보 조회를 위한 DAO 인스턴스 */
	private UserDAO userDAO = new UserDAO();

	/**
	 * GET 요청을 처리하여 로그인 폼을 표시합니다.
	 *
	 * <p>사용자가 /login URL에 접근했을 때 로그인 JSP 페이지를 포워드합니다.</p>
	 *
	 * @param request HTTP 요청 객체
	 * @param response HTTP 응답 객체
	 * @throws ServletException 서블릿 처리 중 오류가 발생한 경우
	 * @throws IOException 입출력 오류가 발생한 경우
	 */
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
		throws ServletException, IOException {
		request.getRequestDispatcher("/WEB-INF/jsp/index-home.jsp").forward(request, response);
	}

	/**
	 * POST 요청을 처리하여 로그인 인증을 수행합니다.
	 *
	 * <p>폼에서 전송된 로그인 ID와 비밀번호를 받아 인증을 수행하고,
	 * 성공 시 세션에 사용자 ID와 역할 정보를 저장한 후 메인 페이지로 리다이렉트합니다.
	 * 실패 시 오류 메시지를 설정하고 로그인 페이지를 다시 표시합니다.</p>
	 *
	 * @param request HTTP 요청 객체 (loginId, password 파라미터 포함)
	 * @param response HTTP 응답 객체
	 * @throws ServletException 서블릿 처리 중 오류가 발생한 경우
	 * @throws IOException 입출력 오류가 발생한 경우
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
				session.setAttribute("isTeacher", isTeacher);
				session.setAttribute("isStudent", isStudent);

				// 세션 타임아웃 설정 (30분)
				session.setMaxInactiveInterval(LOGIN_TIMEOUT_SECONDS);

				// 메인 페이지로 리다이렉트
				response.sendRedirect("/");
			} catch (SQLException e) {
				e.printStackTrace();
				request.setAttribute("error", "사용자 권한 정보를 가져오는데 실패했습니다.");
				request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
			}
		} else {
			request.setAttribute("error", "아이디 또는 비밀번호가 잘못되었습니다.");
			request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
		}
	}
}
