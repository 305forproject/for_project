package oneday.controller;

import oneday.config.PaymentConfig;
import oneday.service.PaymentService;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.Base64;

@WebServlet(urlPatterns = {"/api/payment/success", "/api/payment/fail"})
public class PaymentController extends HttpServlet {

	private final PaymentService paymentService = PaymentService.getInstance();

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String requestUri = request.getRequestURI();

		//성공 로직
		if (requestUri.endsWith("/success")) {
			int reservationId = -1;

			String paymentKey = request.getParameter("paymentKey");
			String orderId = request.getParameter("orderId");
			String amount = request.getParameter("amount");
			System.out.println(orderId);

			// 이런 예약 번호에서 `oneday-reservation_Id-현재시간`
			// reservationid만 추출
			try {
				String[] parts = orderId.split("-");
				if (parts.length >= 2 && parts[0].equals("oneday")) {
					reservationId = Integer.parseInt(parts[1]);
				}
			} catch (Exception e) {
				e.printStackTrace();
			}

			// reservationId를 제대로 추출하지 못한 경우, 잘못된 요청으로 처리
			if (reservationId == -1) {
				response.sendError(HttpServletResponse.SC_BAD_REQUEST, "잘못된 주문번호입니다.");
				return;
			}

			try {
				// 토스페이먼츠에 최종 결제 승인 요청
				JSONObject responseJson = requestPaymentConfirm(paymentKey, orderId, amount);
				boolean processingResult = paymentService.processPayment(responseJson, reservationId);
				request.setAttribute("isSuccess", processingResult);
				// 서비스 계층에 최종 처리 위임
				paymentService.processPayment(responseJson, reservationId);

				request.setAttribute("isSuccess", true);
				request.setAttribute("paymentResult", responseJson);

			} catch (Exception e) {
				request.setAttribute("isSuccess", false);
				request.setAttribute("errorMsg", e.getMessage());
			}
			request.getRequestDispatcher("/WEB-INF/views/payment/success.jsp").forward(request, response);

		} else if (requestUri.endsWith("/fail")) {
			request.setAttribute("message", request.getParameter("message"));
			request.setAttribute("code", request.getParameter("code"));
			request.getRequestDispatcher("/WEB-INF/views/payment/fail.jsp").forward(request, response);
		}
	}

	// 토스의 결제 api 호출 메소드
	private JSONObject requestPaymentConfirm(String paymentKey, String orderId, String amount) throws Exception {
		// 시크릿키 암호화해 전달
		String secretKey = PaymentConfig.getSecretKey();
		Base64.Encoder encoder = Base64.getEncoder();
		byte[] encodedBytes = encoder.encode((secretKey + ":").getBytes(StandardCharsets.UTF_8));
		String authorizations = "Basic " + new String(encodedBytes);

		//데이터 json 변환후 전달
		URL url = new URL("https://api.tosspayments.com/v1/payments/confirm");
		HttpURLConnection connection = (HttpURLConnection) url.openConnection();
		connection.setRequestProperty("Authorization", authorizations);
		connection.setRequestProperty("Content-Type", "application/json");
		connection.setRequestMethod("POST");
		connection.setDoOutput(true);

		JSONObject obj = new JSONObject();
		obj.put("paymentKey", paymentKey);
		obj.put("orderId", orderId);
		obj.put("amount", amount);

		//  json  스트링 변환, 바이트 변환 후
		//데이터 전송
		OutputStream outputStream = connection.getOutputStream();
		outputStream.write(obj.toString().getBytes(StandardCharsets.UTF_8));

		//응답 받기
		int code = connection.getResponseCode();
		boolean isSuccess = (code == 200);

		InputStream responseStream = isSuccess ? connection.getInputStream() : connection.getErrorStream();
		Reader reader = new InputStreamReader(responseStream, StandardCharsets.UTF_8);
		JSONParser parser = new JSONParser();
		JSONObject jsonObject = (JSONObject) parser.parse(reader);
		responseStream.close();

		if (!isSuccess) {
			throw new Exception((String) jsonObject.get("message"));
		}
		return jsonObject;
	}
}

