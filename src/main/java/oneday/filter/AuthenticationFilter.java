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

	// 인증이 필요 없는 경로 미리 리스트
	private List<String> whitelist;

	@Override
	public void init(FilterConfig filterConfig) throws ServletException {
		String contextPath = filterConfig.getServletContext().getContextPath();
		whitelist = Arrays.asList(
			contextPath + "/login",
			contextPath + "/signup",
			contextPath + "/main",
			contextPath + "/static/",
			contextPath + "/classes"
		);
	}

	@Override
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
		throws IOException, ServletException {

		HttpServletRequest httpRequest = (HttpServletRequest)request;
		HttpServletResponse httpResponse = (HttpServletResponse)response;
		String requestURI = httpRequest.getRequestURI();

		// 요청된 주소가 허용 목록 포함 확인
		boolean isWhitelisted = false;
		for (String whitelistPath : whitelist) {
			if (requestURI.startsWith(whitelistPath)) {
				isWhitelisted = true;
				break;
			}
		}

		//  허용 목록, 로그인 상태 통과
		if (isWhitelisted || isAuthenticated(httpRequest )) {
			chain.doFilter(request, response);
		} else {
			httpResponse.sendRedirect(httpRequest.getContextPath() + "/login");
		}
	}


	// 세션으로 사용자 로그인 검사
	private boolean isAuthenticated(HttpServletRequest request) {
		HttpSession session = request.getSession(false);
		return session != null && session.getAttribute("userId") != null;
	}

	@Override
	public void destroy() {
	}
}