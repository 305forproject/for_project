package oneday.filter;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Arrays;
import java.util.List;

@WebFilter("/*")
public class AuthenticationFilter implements Filter {

	// 인증이 필요 없는 경로
	private List<String> whitelist;
	// 선생 역할 필요 경로
	private List<String> teacherOnlyPaths;

	@Override
	public void init(FilterConfig filterConfig) throws ServletException {
		String contextPath = filterConfig.getServletContext().getContextPath();

		// 공개 경로 설정
		whitelist = Arrays.asList(
			contextPath + "/login",
			contextPath + "/signup",
			contextPath + "/main",
			contextPath + "/static/"
		);

		// 선생님 전용 경로 설정
		teacherOnlyPaths = Arrays.asList(
			contextPath + "/teachers/classes/"
		);
	}

	@Override
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
		throws IOException, ServletException {

		HttpServletRequest httpRequest = (HttpServletRequest) request;
		HttpServletResponse httpResponse = (HttpServletResponse) response;
		String requestURI = httpRequest.getRequestURI();

		// 공개 경로 통과
		boolean isWhitelisted = whitelist.stream().anyMatch(requestURI::startsWith);
		if (isWhitelisted) {
			chain.doFilter(request, response);
			return;
		}

		// 로그인 상태 확인
		HttpSession session = httpRequest.getSession(false);
		if (session == null || session.getAttribute("userId") == null) {
			httpResponse.sendRedirect(httpRequest.getContextPath() + "/login"); // 로그인 페이지로
			return;
		}

		// 선생 전용 경로 확인
		boolean isTeacherPath = teacherOnlyPaths.stream().anyMatch(requestURI::startsWith);
		if (isTeacherPath) {
			// 세션에서 선생님 역할 확인
			Boolean isTeacher = (Boolean) session.getAttribute("isTeacher");
			if (isTeacher == null || !isTeacher) {
				httpResponse.sendRedirect(httpRequest.getContextPath() + "/main.jsp");
				return;
			}
		}

		chain.doFilter(request, response);
	}

	@Override
	public void destroy() {}
}