package oneday.controller;

import oneday.dto.ClassDetailDto;
import oneday.service.ClassService;
import oneday.util.PropertyUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/class/detail")
public class ClassController extends HttpServlet {
	private final ClassService classService = ClassService.getInstance();

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String classIdParam = request.getParameter("classId");

		// URL에 ID가 포함된 경우 (상세 조회)
		if (classIdParam != null && !classIdParam.isEmpty()) {
			try {
				int classId = Integer.parseInt(classIdParam);
				ClassDetailDto detail = classService.findClassDetail(classId);

				if (detail != null) {
					request.setAttribute("classDetail", detail);
					request.setAttribute("kakaoJsKey", PropertyUtil.getKakaoJavascriptKey());
					request.getRequestDispatcher("/WEB-INF/views/classDetail.jsp").forward(request, response);
				} else {
					response.sendError(HttpServletResponse.SC_NOT_FOUND, "해당 클래스를 찾을 수 없습니다.");
				}

			} catch (NumberFormatException e) {
				response.sendError(HttpServletResponse.SC_BAD_REQUEST, "잘못된 클래스 ID 형식입니다.");
			}
		} else {
			//url 없으면 되돌아가기
			response.sendRedirect(request.getContextPath() + "/");
		}
	}
}