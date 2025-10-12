package oneday.filter;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * 모든 HTTP 요청에 대한 인코딩 설정을 담당하는 필터
 * 한글 데이터 처리를 위해 UTF-8 인코딩을 자동으로 설정
 */
@WebFilter("/*")
public class EncodingFilter implements Filter {
	
	/**
	 * 요청과 응답에 UTF-8 인코딩을 설정하는 필터 메서드
	 * 모든 HTTP 요청에 대해 자동으로 실행됨
	 *
	 * @param request 클라이언트 요청 객체
	 * @param response 서버 응답 객체
	 * @param chain 필터 체인 (다음 필터 또는 서블릿으로 요청 전달)
	 * @throws IOException 입출력 오류 발생 시
	 * @throws ServletException 서블릿 처리 중 오류 발생 시
	 */
	@Override
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
		throws IOException, ServletException {

		HttpServletRequest httpRequest = (HttpServletRequest)request;
		HttpServletResponse httpResponse = (HttpServletResponse)response;

		// 모든 요청과 응답에 UTF-8 인코딩 설정
		httpRequest.setCharacterEncoding("UTF-8");

		// 다음 필터 또는 서블릿으로 요청 전달
		chain.doFilter(request, response);
	}
}