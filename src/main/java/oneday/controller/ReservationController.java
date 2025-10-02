package oneday.controller;

import oneday.dto.ReservationDetailDto;
import oneday.dto.ReservationRequestDto;
import oneday.model.Reservation;
import oneday.service.ReservationService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.sql.SQLException;

import org.apache.commons.beanutils.BeanUtils;

@WebServlet("/reservations/*")
public class ReservationController extends HttpServlet {
	private final ReservationService reservationService = ReservationService.getInstance();

	//예약 생성
	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws
		ServletException,
		IOException {

		// 1. DTO 객체 생성
		ReservationRequestDto reservationDto = new ReservationRequestDto();

		try {
			// 2. 요청 파라미터를 DTO에 자동 채우기
			// request.getParameterMap()의 key와 DTO의 필드 이름이 일치
			BeanUtils.populate(reservationDto, request.getParameterMap());

		} catch (IllegalAccessException | InvocationTargetException e) {
			throw new ServletException("DTO 파라미터 매핑 오류", e);
		}

		// 3. 세션에서 사용자 ID 가져오기
		int studentId = (Integer)request.getSession().getAttribute("userId");

		try {
			// 4. 서비스를 호출하여 예약 생성 (이후 로직은 동일)
			Reservation createdReservation = reservationService.createReservation(reservationDto, studentId);

			// 5. 성공 시 응답 (단순 성공 메시지 또는 페이지 리디렉션)
			response.setStatus(HttpServletResponse.SC_CREATED);
			response.getWriter().write(createdReservation.getReservationId() + "예약 완료 ");

		} catch (Exception e) {
			response.sendError(HttpServletResponse.SC_BAD_REQUEST, e.getMessage());
		}
	}

	//예약 상세 확인
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws
		ServletException,
		IOException {
		String pathInfo = request.getPathInfo();

		// URL 뒷부분이 있는지 확인
		if (pathInfo != null && !pathInfo.equals("/")) {
			try {
				// 1. URL에서 예약 ID 추출 (예: "/123" -> 123)
				int reservationId = Integer.parseInt(pathInfo.substring(1));

				// 2. 세션에서 현재 로그인한 사용자 ID 가져오기 (보안 검사용)
				int studentId = (Integer)request.getSession().getAttribute("userId");

				// 3. 서비스를 호출하여 예약 상세 정보 조회
				ReservationDetailDto detail = reservationService.findMyReservationDetails(reservationId, studentId);

				// 4. 조회된 데이터를 request에 담아 JSP로 포워딩
				request.setAttribute("reservationDetail", detail);
				request.getRequestDispatcher("/WEB-INF/views/reservationDetail.jsp").forward(request, response);

			} catch (NumberFormatException e) {
				response.sendError(HttpServletResponse.SC_BAD_REQUEST, "잘못된 예약 ID 형식입니다.");
			} catch (SQLException e) {
				throw new RuntimeException(e);
			}
		} else {
			// ID가 없는 요청은 잘못된 요청으로 처리
			response.sendError(HttpServletResponse.SC_BAD_REQUEST, "예약 ID가 필요합니다.");
		}
	}

}