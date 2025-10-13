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

		// --- 1. 요청의 Body에 담긴 JSON 데이터를 읽기 위한 준비 ---
		// 클라이언트가 보낸 데이터가 JSON 형식이므로, getParameter 대신 getReader를 사용합니다.
		Gson gson = new Gson();
		ReservationRequestDto reservationDto = null;
		try {
			// request.getReader()로 읽어온 JSON 문자열을 ReservationRequestDto 객체로 자동 변환합니다.
			reservationDto = gson.fromJson(request.getReader(), ReservationRequestDto.class);
		} catch (Exception e) {
			logger.log(Level.WARNING, "JSON 파싱 오류", e);
			response.sendError(HttpServletResponse.SC_BAD_REQUEST, "잘못된 요청 형식입니다.");
			return;
		}

		// --- 2. 세션에서 로그인된 사용자 ID를 안전하게 가져오기 ---
		HttpSession session = request.getSession(false);
		if (session == null || session.getAttribute("userId") == null) {
			response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "로그인이 필요합니다.");
			return;
		}
		int studentId = (Integer) session.getAttribute("userId");

		try {
			// --- 3. 서비스를 호출하여 예약 생성 로직 실행 ---
			// Service는 정원 초과, 중복 예약 등의 규칙을 검사하고 예외를 발생시킬 수 있습니다.
			Reservation createdReservation = reservationService.createReservation(reservationDto, studentId);

			// --- 4. 성공 시: 생성된 예약 정보를 JSON으로 변환하여 응답 ---
			// 클라이언트(JavaScript)는 이 JSON 데이터를 받아 토스페이먼츠 결제창을 띄우는 데 사용합니다.
			response.setStatus(HttpServletResponse.SC_CREATED); // '성공적으로 생성됨'을 의미하는 201 상태 코드
			response.setContentType("application/json");
			response.setCharacterEncoding("UTF-8");
			response.getWriter().write(gson.toJson(createdReservation));

		} catch (Exception e) {
			// --- 5. 실패 시: Service에서 발생한 오류 메시지를 JSON으로 변환하여 응답 ---
			// 클라이언트(JavaScript)는 이 오류 메시지를 받아 alert() 창으로 사용자에게 보여줍니다.
			logger.log(Level.INFO, "예약 생성 실패: " + e.getMessage()); // 서버에는 정보성 로그를 남김
			response.setStatus(HttpServletResponse.SC_BAD_REQUEST); // '잘못된 요청'을 의미하는 400 상태 코드
			response.setContentType("application/json");
			response.setCharacterEncoding("UTF-8");
			// {"message": "정원이 모두 마감되었습니다."} 와 같은 JSON 응답 생성
			response.getWriter().write("{\"message\": \"" + e.getMessage() + "\"}");
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