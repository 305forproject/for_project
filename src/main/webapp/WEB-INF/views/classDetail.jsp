<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>
<head>
    <title>${classDetail.className} - 상세 정보</title>
    <%-- Swiper CSS, JS--%>
    <script src="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css"/>
    <%--달력--%>
    <script src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.9/index.global.min.js'></script>
    <%--토스결제--%>
    <script src="https://js.tosspayments.com/v2/standard"></script>
    <style>
        .container {
            max-width: 800px;
            margin: 40px auto;
        }

        .detail-item span {
            font-weight: bold;
        }

        #class-date-calendar {
            max-width: 600px;
            margin: 20px 0;
        }

        /*Swiper */
        .swiper {
            width: 100%; /* 부모 요소에 맞춰 너비 100% */
            height: 300px; /* 이미지 높이에 맞게 조정하거나 반응형으로 처리 */
        }

        .swiper-slide {
            text-align: center;
            font-size: 18px;
            background: #fff;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .swiper-slide img {
            display: block;
            width: 100%;
            height: 100%;
            object-fit: contain; /* 이미지 비율을 유지하면서 컨테이너에 맞게 */
        }

        /* Swiper 기본 색상 변경 */
        :root {
            --swiper-navigation-color: #E0A7DD; /* 좌우 화살표 색상 */
            --swiper-pagination-color: #E0A7DD; /* 활성화된 점(bullet) 색상 */
        }

        /*  모달   */
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
            position: relative;
            background: white;
            padding: 40px;
            border-radius: 10px;

            /*위젯이 깨지지 않도록 최소/최대 너비를 지정 */
            width: 90%; /* 기본 너비는 화면의 90% */
            max-width: 550px; /* 화면이 아무리 커도 최대 550px를 넘지 않음 */
            min-width: 300px; /* 화면이 아무리 작아도 최소 300px 너비를 확보 */
        }

        .close-btn {
            position: absolute;
            top: 10px;
            right: 15px;
            font-size: 24px;
            background: none;
            border: none;
            cursor: pointer;
            color: #888;
        }

        .close-btn:hover {
            color: #000;
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

            <div class="swiper mySwiper">
                <div class="swiper-wrapper">
                    <c:forEach items="${classDetail.images}" var="image">
                        <div class="swiper-slide">
                            <img src="${pageContext.request.contextPath}${image.imageUrl}" alt="클래스 이미지">
                        </div>
                    </c:forEach>
                </div>
                <div class="swiper-button-next"></div>
                <div class="swiper-button-prev"></div>
                <div class="swiper-pagination"></div>
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
                <li><strong>가격:</strong> <fmt:formatNumber value="${classDetail.price}" type="currency"
                                                           currencySymbol="₩"/></li>
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
        <%-- 닫기(X) 버튼 --%>
        <button class="close-btn" onclick="closePaymentModal()">×</button>
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
    var swiper = new Swiper(".mySwiper", {
        cssMode: true, // CSS Mode 활성화 (선택 사항, 필요에 따라)
        navigation: { // 좌우 버튼 설정
            nextEl: ".swiper-button-next",
            prevEl: ".swiper-button-prev",
        },
        pagination: { // 하단 점 페이지네이션 설정
            el: ".swiper-pagination",
            clickable: true, // 클릭하여 이동 가능
        },
        mousewheel: true, // 마우스 휠로 슬라이드 이동
        keyboard: true, // 키보드 화살표로 슬라이드 이동
        loop: true, // 무한 반복
    });
</script>

<script>
    // 페이지가 모두 로드되면 달력을 생성
    document.addEventListener('DOMContentLoaded', function () {
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
    let paymentWidgets;

    const clientKey = "test_gck_docs_Ovk5rk1EwkEbP0W43n07xlzm";
    const tossPayments = TossPayments(clientKey);
    const customerKey = 'user-' + '${sessionScope.userId}';
    const amount = ${classDetail.price};

    // 페이지가 처음 로드시 위젯을 미리 생성
    document.addEventListener('DOMContentLoaded', async function () {
        // 위젯 객체 생성
        paymentWidgets = tossPayments.widgets({customerKey});

        // 금액 설정
        await paymentWidgets.setAmount({currency: "KRW", value: amount});

        // 결제 UI와 약관 UI를 숨겨진 모달 안에 미리 렌더링
        await Promise.all([
            paymentWidgets.renderPaymentMethods({selector: "#payment-method", variantKey: "DEFAULT"}),
            paymentWidgets.renderAgreement({selector: "#agreement", variantKey: "AGREEMENT"})
        ]);
    });

    // --- 모달 닫기 ---
    function closePaymentModal() {
        document.getElementById('payment-modal').style.display = 'none';
    }

    // --- 모달 바깥의 어두운 영역을 클릭하면 닫히도록 설정 ---
    const modalOverlay = document.getElementById('payment-modal');
    modalOverlay.addEventListener('click', function (event) {
        if (event.target === modalOverlay) { // 클릭된 대상이 어두운 영역 자체일 때만
            closePaymentModal();
        }
    });

    // --- 예약하기 버튼 클릭 시 모달 열기 ---
    async function openPaymentModal() {
        // 모달 화면에 보여줌
        document.getElementById('payment-modal').style.display = 'flex';
    }

    // --- 모달 안의 '결제하기' 버튼 클릭 시 결제 요청 ---
    const paymentButton = document.getElementById("payment-widget-button");
    paymentButton.addEventListener("click", async function () {
        const domain = window.location.origin;
        const contextPath = "${pageContext.request.contextPath}";
        const successUrl = domain + contextPath + "/api/payment/success";
        const failUrl = domain + contextPath + "/api/payment/fail";
        const uniqueOrderId = 'oneday-' + '${classDetail.classId}' + '-' + '${sessionScope.userId}' + '-' + Date.now();

        try {
            // 결제 요청
            // 테스트 키라 결제 확인도 못하니
            // 이름 이메일은 저장하지 않고 그냥 하드코딩
            await paymentWidgets.requestPayment({
                orderId: uniqueOrderId,
                orderName: "${classDetail.className}",
                successUrl: successUrl,
                failUrl: failUrl,
                customerEmail: "customer123@gmail.com",
                customerName: "김토스",
            });
        } catch (error) {
            console.error(error);
        }
    });
</script>
</body>
</html>