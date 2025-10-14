package oneday.controller;

import oneday.config.PaymentConfig;
import oneday.service.PaymentService;
import oneday.service.ReservationService;

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
			String paymentKey = request.getParameter("paymentKey");
			String orderIdFromToss = request.getParameter("orderId");
			String amountStr = request.getParameter("amount");

			int classId = -1;
			int studentId = -1;

			try {
				//orderId에서 classId와 studentId를 다시 추출
				String[] parts = orderIdFromToss.split("-");
				if (parts.length >= 3 && parts[0].equals("oneday")) {
					classId = Integer.parseInt(parts[1]);
					studentId = Integer.parseInt(parts[2]);
				}
			} catch (Exception e) {
				e.printStackTrace();
			}

			try {
				// 토스페이먼츠에 최종 결제 승인 요청
				JSONObject responseJson = requestPaymentConfirm(paymentKey, orderIdFromToss, amountStr);

				paymentService.createReservationAndPayment(classId, studentId, responseJson);

				// 성공시 success.jsp로 이동
				request.setAttribute("isSuccess", true);
				request.setAttribute("paymentResult", responseJson);
				request.getRequestDispatcher("/WEB-INF/views/payment/success.jsp").forward(request, response);

			} catch (Exception e) {
				request.setAttribute("message", e.getMessage());
				request.setAttribute("code", "SERVER_ERROR");
				request.getRequestDispatcher("/WEB-INF/views/payment/fail.jsp").forward(request, response);
			}
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

