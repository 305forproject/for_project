package oneday.controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import oneday.model.Image;
import oneday.service.ImageService;

@WebServlet("/main")
public class MainController extends HttpServlet {
	private final ImageService imageService = ImageService.getInstance();


	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
		throws ServletException, IOException {
		// 이미지 받아와 전달
		List<Image> slideImages = imageService.getMainSlideImages();
		
		request.setAttribute("slideImages", slideImages);

		request.getRequestDispatcher("/WEB-INF/views/index-home.jsp").forward(request, response);
	}
}
