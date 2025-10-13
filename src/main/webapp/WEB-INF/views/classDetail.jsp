<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>${classDetail.className} - 상세 정보</title>
    <%--달력--%>
    <script src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.9/index.global.min.js'></script>
    <%--토스결제--%>
    <script src="https://js.tosspayments.com/v2/standard"></script>
    <style>
        .container { max-width: 800px; margin: 40px auto; }
        .detail-item span { font-weight: bold; }
        #class-date-calendar { max-width: 600px; margin: 20px 0; }
        .modal-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.6);
            display: none; /* 평소에는 숨겨 둠 */
            justify-content: center;
            align-items: center;
            z-index: 1000;
        }
        .modal-content {
            background: white;
            padding: 40px;
            border-radius: 10px;

            /* [수정] 위젯이 깨지지 않도록 최소/최대 너비를 지정합니다. */
            width: 90%;          /* 기본 너비는 화면의 90% */
            max-width: 550px;    /* 화면이 아무리 커도 최대 550px를 넘지 않음 */
            min-width: 300px;    /* 화면이 아무리 작아도 최소 300px 너비를 확보 */
        }
    </style>
</head>
<body>
<div class="container">
    <c:choose>
        <c:when test="${not empty classDetail}">
            <h1>${classDetail.className}</h1>
            <p><strong>강사:</strong> ${classDetail.teacherName}</p>
            <hr>

            <div>
                <div>
                    <c:forEach items="${classDetail.images}" var="image">
                        <div>
                            <img src="${pageContext.request.contextPath}/${image.imageUrl}" alt="클래스 이미지">
                        </div>
                    </c:forEach>
                </div>
            </div>

            <h3>강의 설명</h3>
            <p>${classDetail.description}</p>

            <h3>상세 정보</h3>
            <ul>
                <li>
                    <strong>날짜 및 시간:</strong>
                    <div id="class-date-calendar"></div>
                </li>
                <li><strong>날짜 및 시간:</strong>
                    <fmt:formatDate value="${classDetail.startAtAsDate}" pattern="yyyy년 MM월 dd일 HH:mm"/> ~
                    <fmt:formatDate value="${classDetail.endAtAsDate}" pattern="HH:mm"/>
                </li>
                <li><strong>장소:</strong> ${classDetail.location}</li>
                <li><strong>위도 경도:</strong> ${classDetail.latitude} ${classDetail.longitude}</li>
                <li><strong>가격:</strong> <fmt:formatNumber value="${classDetail.price}" type="currency" currencySymbol="₩"/></li>
                <li><strong>예약 현황:</strong> ${classDetail.currentReservationCount} / ${classDetail.maxStudents} 명</li>
            </ul>

            <button onclick="openPaymentModal()">예약하기</button>

        </c:when>
        <c:otherwise>
            <h1>클래스 정보를 찾을 수 없습니다.</h1>
        </c:otherwise>
    </c:choose>
</div>

<%-- 결제 위젯이 표시될 모달 UI --%>
<div id="payment-modal" class="modal-overlay">
    <div class="modal-content">
        <h3>결제하기</h3>
        <%-- 결제 위젯의 결제수단 UI가 여기에 렌더링됩니다. --%>
        <div id="payment-method"></div>
        <%-- 결제 위젯의 이용약관 UI가 여기에 렌더링됩니다. --%>
        <div id="agreement"></div>
        <%-- 모달 안의 최종 '결제하기' 버튼 --%>
        <button class="button" id="payment-widget-button" style="margin-top: 30px; width: 100%;">결제하기</button>
    </div>
</div>

<script>
    // 페이지가 모두 로드되면 달력을 생성
    document.addEventListener('DOMContentLoaded', function() {
        const calendarEl = document.getElementById('class-date-calendar');

        // 컨트롤러가 넘겨준 classDetail 객체에서 날짜 정보 문자열 변환
        const startDateTime = '${classDetail.startAt.toString()}';
        const endDateTime = '${classDetail.endAt.toString()}';

        const startParts = startDateTime.split('T');
        const startTime = startParts.length > 1 ? startParts[1].substring(0, 5) : '';

        // FullCalendar에 전달할 이벤트 데이터 배열
        const eventsArray = [
            {
                title: startTime,
                start: startDateTime,
                end: endDateTime
            }
        ];

        const calendar = new FullCalendar.Calendar(calendarEl, {
            initialView: 'dayGridMonth', // 월별 달력
            initialDate: startDateTime,
            events: eventsArray,
            displayEventTime: false
        });

        calendar.render();
    });
</script>
<script>
    const clientKey = "test_gck_docs_Ovk5rk1EwkEbP0W43n07xlzm";
    const tossPayments = TossPayments(clientKey);

    let paymentWidgets; // 위젯 객체를 담을 변수

    // --- 2. '예약 및 결제하기' 버튼 클릭 시 모달 열기 ---
    async function openPaymentModal() {
        const customerKey = 'user-' + '${sessionScope.userId}';
        const amount = ${classDetail.price};

        // 위젯 객체 생성
        paymentWidgets = tossPayments.widgets({ customerKey });

        // 금액 설정
        await paymentWidgets.setAmount({ currency: "KRW", value: amount });

        // 결제 UI와 약관 UI를 모달 안에 렌더링
        await Promise.all([
            paymentWidgets.renderPaymentMethods({ selector: "#payment-method", variantKey: "DEFAULT" }),
            paymentWidgets.renderAgreement({ selector: "#agreement", variantKey: "AGREEMENT" })
        ]);

        // 모달을 화면에 보여줌
        document.getElementById('payment-modal').style.display = 'flex';
    }

    // --- 3. 모달 안의 '결제하기' 버튼 클릭 시 결제 요청 ---
    const paymentButton = document.getElementById("payment-widget-button");
    paymentButton.addEventListener("click", async function () {
        const domain = window.location.origin;
        const contextPath = "${pageContext.request.contextPath}";
        const successUrl = domain + contextPath + "/api/payment/success";
        const failUrl = domain + contextPath + "/api/payment/fail";
        const uniqueOrderId = 'oneday-' + '${classDetail.classId}' + '-' + '${sessionScope.userId}' + '-' + Date.now();

        try {
            // 결제 요청
            await paymentWidgets.requestPayment({
                orderId: uniqueOrderId,
                orderName: "${classDetail.className}",
                successUrl: successUrl,
                failUrl: failUrl,
                customerEmail: "customer123@gmail.com",
                customerName: "김토스",
            });
        } catch (error) {
            // 결제창을 닫는 등 에러 처리
            console.error(error);
        }
    });
</script>
</body>
</html>