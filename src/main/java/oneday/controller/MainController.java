package oneday.controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import oneday.dto.ClassListDto;
import oneday.model.Image;
import oneday.service.ClassService;
import oneday.service.ImageService;

@WebServlet("/main")
public class MainController extends HttpServlet {
	private final ImageService imageService = ImageService.getInstance();
	private final ClassService classService = ClassService.getInstance();

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
		throws ServletException, IOException {
		// 이미지 받아와 전달
		List<Image> slideImages = imageService.getMainSlideImages();

		request.setAttribute("slideImages", slideImages);

		// 강사 등록 성공 메시지 처리
		String success = request.getParameter("success");
		if ("teacher-registered".equals(success)) {
			request.setAttribute("successMessage", "강사 등록이 완료되었습니다!");
		}

		String sortOption = request.getParameter("sort");
		if (sortOption == null) {
			sortOption = "newest";
		}

		// 정렬 옵션을 전달하여 클래스 목록을 조회
		List<ClassListDto> classList = classService.getClassList(sortOption);

		// 조회된 목록을 request에 담아 JSP로 전달
		request.setAttribute("classList", classList);

		request.getRequestDispatcher("/WEB-INF/views/index-home.jsp").forward(request, response);
	}
}
