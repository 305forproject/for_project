package oneday.controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import oneday.dto.ReservationCalendarDto;
import oneday.service.ReservationService;

@WebServlet("/users/myPage")
public class StudentReservationController extends HttpServlet {
	private final ReservationService reservationService = ReservationService.getInstance();

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException,
		IOException {
		int studentId = (Integer)request.getSession().getAttribute("userId");
		String yearParam = request.getParameter("year");
		String monthParam = request.getParameter("month");

		if (yearParam != null && monthParam != null) {
			int year = Integer.parseInt(yearParam);
			int month = Integer.parseInt(monthParam);

			// 서비스 호출하여 달력 조회
			List<ReservationCalendarDto> calendarEvents = reservationService.findMyReservationTimesByMonth(studentId,
				year, month);

			request.setAttribute("calendarEvents", calendarEvents);
			request.getRequestDispatcher("/WEB-INF/views/mypage.jsp").forward(request, response);

		} else {
			response.sendError(HttpServletResponse.SC_BAD_REQUEST, "year와 month 파라미터가 필요합니다.");
		}
	}
}
