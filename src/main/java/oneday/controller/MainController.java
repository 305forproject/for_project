package oneday.controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import oneday.dto.ClassListDto;
import oneday.service.ClassService;

/**
 * 메인 페이지 요청을 처리하는 컨트롤러
 * 강의 목록을 조회하여 메인 페이지에 표시
 */
@WebServlet("/main")
public class MainController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private final ClassService classService;

	public MainController() {
		this.classService = ClassService.getInstance();
	}

	/**
	 * 메인 페이지 GET 요청 처리
	 * 모든 강의 목록을 최신순으로 조회하여 메인 페이지로 전달
	 */
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
		throws ServletException, IOException {

		try {
			// 모든 강의 목록을 최신순으로 조회
			List<ClassListDto> classList = classService.getAllClassList();

			// 요청 속성에 강의 목록 설정
			request.setAttribute("classList", classList);

			// 메인 페이지로 포워딩
			request.getRequestDispatcher("/WEB-INF/views/main.jsp").forward(request, response);

		} catch (Exception e) {
			e.printStackTrace();
			response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "강의 목록 조회 중 오류가 발생했습니다.");
		}
	}
}
