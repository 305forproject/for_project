package oneday.controller;

import oneday.dto.TeacherCalendarDto;
import oneday.dto.TeacherClassDetailDto;
import oneday.service.ClassService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/teachers/classes/*")
public class TeacherClassController extends HttpServlet {

	private final ClassService classService = ClassService.getInstance();

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws
		ServletException,
		IOException {
		String pathInfo = request.getPathInfo();

		// 로그인한 강사 ID 가져오기
		Integer teacherId = (Integer)request.getSession().getAttribute("userId");

		if (teacherId == null) {
			request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
			return;
		}

		// 1. 달력 조회: /teachers/classes?year=...&month=...
		if (pathInfo == null || pathInfo.equals("/")) {
			handleCalendarView(request, response, teacherId);
		}
		// 2. 상세 정보 조회: /teachers/classes/{classId}
		else {
			handleDetailView(request, response, teacherId, pathInfo);
		}
	}

	private void handleCalendarView(HttpServletRequest request, HttpServletResponse response, int teacherId) throws
		ServletException,
		IOException {
		String yearParam = request.getParameter("year");
		String monthParam = request.getParameter("month");

		if (yearParam != null && monthParam != null) {
			int year = Integer.parseInt(yearParam);
			int month = Integer.parseInt(monthParam);

			List<TeacherCalendarDto> events = classService.findMyCalendarEvents(teacherId, year, month);
			request.setAttribute("calendarEvents", events);
			request.getRequestDispatcher("/WEB-INF/views/teacherCalendar.jsp").forward(request, response);
		} else {
			response.sendError(HttpServletResponse.SC_BAD_REQUEST, "year와 month 가 필요합니다.");
		}
	}

	private void handleDetailView(HttpServletRequest request, HttpServletResponse response, int teacherId,
		String pathInfo) throws ServletException, IOException {
		try {
			int classId = Integer.parseInt(pathInfo.substring(1));

			TeacherClassDetailDto detail = classService.findMyClassDetail(classId, teacherId);
			request.setAttribute("classDetail", detail);
			request.getRequestDispatcher("/WEB-INF/views/teacherClassDetail.jsp").forward(request, response);

		} catch (NumberFormatException e) {
			response.sendError(HttpServletResponse.SC_BAD_REQUEST, "잘못된 강의 ID 형식입니다.");
		}
	}
}