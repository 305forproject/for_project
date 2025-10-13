package oneday.controller;

import java.io.IOException;
import java.util.List;

import com.google.gson.Gson;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import oneday.dto.FullCalendarEventDto;
import oneday.dto.ReservationCalendarDto;
import oneday.service.ReservationService;

@WebServlet("/users/mypage")
public class StudentReservationController extends HttpServlet {
	private final ReservationService reservationService = ReservationService.getInstance();

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int studentId = (Integer) request.getSession().getAttribute("userId");

		// FullCalendar가 보내주는 start 파라미터가 있는지 확인
		String startParam = request.getParameter("start");

		// --- FullCalendar의 AJAX 요청 처리 ---
		if (startParam != null) {
			String endParam = request.getParameter("end");
			List<FullCalendarEventDto> events = reservationService.findMyCalendarEventsByDateRange(studentId, startParam, endParam);

			// 조회된 데이터를 JSON 형식으로 변환하여 응답
			response.setContentType("application/json");
			response.setCharacterEncoding("UTF-8");
			response.getWriter().write(new Gson().toJson(events));

			// --- 기존의 표(Table) 데이터 요청 처리 ---
		} else {
			String yearParam = request.getParameter("year");
			String monthParam = request.getParameter("month");

			if (yearParam != null && monthParam != null) {
				int year = Integer.parseInt(yearParam);
				int month = Integer.parseInt(monthParam);
				List<ReservationCalendarDto> calendarEvents = reservationService.findMyReservationTimesByMonth(studentId, year, month);

				request.setAttribute("calendarEvents", calendarEvents);
				request.getRequestDispatcher("/WEB-INF/views/mypage.jsp").forward(request, response);
			} else {
				// 파라미터가 없으면 그냥 빈 페이지만 보여줌
				request.getRequestDispatcher("/WEB-INF/views/mypage.jsp").forward(request, response);
			}
		}
	}
}
