package oneday.controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import oneday.dto.ClassListDto;
import oneday.model.Category;
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

		// 강사 등록 성공 메시지 처리
		String success = request.getParameter("success");
		if ("teacher-registered".equals(success)) {
			request.setAttribute("successMessage", "강사 등록이 완료되었습니다!");
		}

		// 정렬
		String sortOption = request.getParameter("sort");
		if (sortOption == null) {
			sortOption = "newest";
		}

		// 카테고리
		String categoryIdParam = request.getParameter("categoryId");
		Integer categoryId = null;
		if (categoryIdParam != null && !categoryIdParam.isEmpty()) {
			categoryId = Integer.parseInt(categoryIdParam);
		}

		// 서비스로 정보 조회
		List<Image> slideImages = imageService.getMainSlideImages();
		List<ClassListDto> classList = classService.getClassList(sortOption, categoryId);
		List<Category> categories = classService.getAllCategories();

		// 조회된 목록을 request에 담아 JSP로 전달
		request.setAttribute("classList", classList);
		request.setAttribute("categories", categories);
		request.setAttribute("slideImages", slideImages);
		request.setAttribute("currentSort", sortOption);
		request.setAttribute("currentCategory", categoryId);

		request.getRequestDispatcher("/WEB-INF/views/index-home.jsp").forward(request, response);
	}
}
