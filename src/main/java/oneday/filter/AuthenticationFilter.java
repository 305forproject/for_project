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
	// 서블릿 컨텍스트 경로를 보관
	private String contextPath;

	@Override
	public void init(FilterConfig filterConfig) throws ServletException {
		this.contextPath = filterConfig.getServletContext().getContextPath();

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

		// 개발용 디버그 로그: 요청 경로와 판단값을 출력
		try {
			HttpSession debugSession = httpRequest.getSession(false);
			System.out.println("[AuthFilter DEBUG] requestURI=" + requestURI
				+ " | contextPath=" + this.contextPath
				+ " | session.userId=" + (debugSession != null ? debugSession.getAttribute("userId") : null)
			);
		} catch (Exception e) {
			// 로그 출력 실패시에도 필터 동작에는 영향 주지 않음
			System.out.println("[AuthFilter DEBUG] failed to print debug info: " + e.getMessage());
		}

		// 정적 리소스(또는 화이트리스트) 통과
		boolean isWhitelisted = whitelist.stream().anyMatch(requestURI::startsWith);
		boolean isStaticPath = (this.contextPath + "/static").equals("/static")
			? requestURI.startsWith("/static")
			: requestURI.startsWith(this.contextPath + "/static");
		// 확장자로도 허용 (css, js, 이미지 폰트 등)
		boolean isStaticExt = requestURI.matches(".*\\.(css|js|png|jpg|jpeg|gif|svg|webp|woff2|woff|ttf|map)$");

		if (isWhitelisted || isStaticPath || isStaticExt) {
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