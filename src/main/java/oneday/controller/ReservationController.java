package oneday.controller;

import oneday.dto.ReservationDetailDto;
import oneday.dto.ReservationRequestDto;
import oneday.model.Reservation;
import oneday.service.ReservationService;
import oneday.util.LocalDateTimeAdapter;
import oneday.util.LoggerUtil;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;


import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.logging.Level;
import java.util.logging.Logger;

import org.apache.commons.beanutils.BeanUtils;

@WebServlet("/reservations/*")
public class ReservationController extends HttpServlet {
	private final ReservationService reservationService = ReservationService.getInstance();
	private static final Logger logger = LoggerUtil.getLogger(String.valueOf(ReservationService.class));

	private final Gson gson = new GsonBuilder()
		.registerTypeAdapter(LocalDateTime.class, new LocalDateTimeAdapter())
		.create();

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

		if (pathInfo != null && !pathInfo.equals("/")) {
			try {
				int reservationId = Integer.parseInt(pathInfo.substring(1));
				HttpSession session = request.getSession(false); // 세션이 없으면 null 반환
				if (session == null || session.getAttribute("userId") == null) {
					// 로그인이 안 된 상태이므로, '인증 필요' 오류를 보냅니다.
					response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "로그인이 필요합니다.");
					return; // 메소드 즉시 종료
				}
				int studentId = (Integer) session.getAttribute("userId");

				ReservationDetailDto detail = reservationService.findMyReservationDetails(reservationId, studentId);

				if (detail != null) {
					response.setContentType("application/json");
					response.setCharacterEncoding("UTF-8");
					response.getWriter().write(gson.toJson(detail));
				} else {
					// 조회된 데이터가 없거나 권한이 없는 경우
					response.sendError(HttpServletResponse.SC_NOT_FOUND, "예약 정보를 찾을 수 없습니다.");
				}

			} catch (NumberFormatException e) {
				// [처리 1] 숫자 변환 실패 시: 400 에러 응답
				logger.log(Level.WARNING, "잘못된 예약 ID 형식으로 요청 들어옴", e);
				response.sendError(HttpServletResponse.SC_BAD_REQUEST, "잘못된 예약 ID 형식입니다.");

				// [처리 2] 예상치 못한 다른 모든 예외 발생 시 (이전에 500 에러를 일으켰던 원인)
			} catch (Exception e) {
				// 1. 로거로 심각한 오류 기록 (개발자가 볼 수 있도록)
				logger.log(Level.SEVERE, "예약 상세 정보 조회 중 심각한 오류 발생", e);
				// 2. 클라이언트(브라우저)에게는 서버 내부 오류가 발생했다고 알려줌
				response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "요청 처리 중 서버에 문제가 발생했습니다.");
			}
		} else {
			response.sendError(HttpServletResponse.SC_BAD_REQUEST, "예약 ID가 필요합니다.");
		}
	}

}