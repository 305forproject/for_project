<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
    <title>${classDetail.className} - 상세 정보</title>

    <%-- 1. 필요한 라이브러리들을 모두 불러옵니다. --%>
    <%-- Swiper (슬라이더) --%>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css"/>
    <script src="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.js"></script>
    <%-- FullCalendar (달력) --%>
    <script src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.9/index.global.min.js'></script>
    <%-- Toss Payments (결제) --%>
    <script src="https://js.tosspayments.com/v2/standard"></script>
    <%-- Kakao Map API --%>
    <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${kakaoJsKey}"></script>

    <%-- CSS 파일 경로를 올바르게 수정합니다. --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/detailPage.css">

    <%-- 모달 및 캘린더를 위한 추가 스타일 --%>
    <style>
        /* 모달 스타일 */
        .modal-overlay {
            position: fixed; top: 0; left: 0; width: 100%; height: 100%;
            background: rgba(0, 0, 0, 0.6); display: none; justify-content: center; align-items: center; z-index: 1000;
        }
        .modal-content {
            position: relative; background: white; padding: 40px; border-radius: 10px;
            width: 90%; max-width: 550px; min-width: 300px;
        }
        .close-btn {
            position: absolute; top: 10px; right: 15px; font-size: 24px;
            background: none; border: none; cursor: pointer; color: #888;
        }
        .close-btn:hover { color: #000; }

        /* Swiper 이미지 스타일 */
        .swiper-slide img {
            display: block; width: 100%; height: 100%; object-fit: cover;
        }
    </style>
</head>

<body>
<%--<jsp:include page="/WEB-INF/views/common/header.jsp" />--%>

<main>
    <c:choose>
        <c:when test="${not empty classDetail}">
            <section class="class-summary">
                    <%-- 2. 이미지 슬라이더: Swiper 라이브러리 구조에 맞게 수정 --%>
                <div class="class-img swiper mySwiper">
                    <div class="swiper-wrapper">
                        <c:forEach items="${classDetail.images}" var="image">
                            <div class="swiper-slide">
                                <img src="${pageContext.request.contextPath}${image.imageUrl}" alt="${classDetail.className} 이미지">
                            </div>
                        </c:forEach>
                    </div>
                    <div class="swiper-button-next"></div>
                    <div class="swiper-button-prev"></div>
                    <div class="swiper-pagination"></div>
                </div>

                <div class="class-side">
                        <%-- 3. 클래스 기본 정보: JSTL/EL을 사용하여 동적으로 데이터 표시 --%>
                    <h2 class="class-title">${classDetail.className}</h2>
                    <p class="class-infomation">${classDetail.description}</p>
                    <p class="class-price"><fmt:formatNumber value="${classDetail.price}" type="currency" currencySymbol="₩"/></p>
                    <button class="apply-btn" onclick="openPaymentModal()">클래스 신청</button>
                </div>
            </section>

            <section class="class-info">
                <h2>${classDetail.className}</h2>
                <ul class="info-box">
                    <li>
                        <img src="${pageContext.request.contextPath}/static/img/time-icon.png" alt="시간">
                        <span><fmt:formatDate value="${classDetail.startAtAsDate}" pattern="HH:mm"/> ~ <fmt:formatDate value="${classDetail.endAtAsDate}" pattern="HH:mm"/></span>
                    </li>
                    <li>
                        <img src="${pageContext.request.contextPath}/static/img/location-icon.png" alt="주소">
                        <span>${classDetail.location}</span>
                    </li>
                    <li>
                        <img src="${pageContext.request.contextPath}/static/img/people-icon.png" alt="수용인원">
                        <span>${classDetail.currentReservationCount} / ${classDetail.maxStudents} 명</span>
                    </li>
                </ul>
            </section>

            <%-- 4. FullCalendar가 표시될 영역 --%>
            <section id="class-hours" class="reservation-calendar">
                <h2>운영시간</h2>
                <div id="class-date-calendar" style="max-width: 700px; margin: 20px auto;"></div>
            </section>

            <%-- 5. KAKAO MAP 표시될 영역 --%>
            <section class="class-location">
                <h2>클래스 위치</h2>
                <div id="map" style="width:55%; height:400px; border-radius: 10px; margin: 20px auto;"></div>
                <p style="color: #666; font-size: 14px; margin-top: 15px; text-align: center;">
                    <img src="${pageContext.request.contextPath}/static/img/location-icon.png" alt="주소" style="width: 16px; vertical-align: middle; margin-right: 5px;">
                    ${classDetail.location}
                </p>
            </section>

        </c:when>
        <c:otherwise>
            <h1>클래스 정보를 찾을 수 없습니다.</h1>
        </c:otherwise>
    </c:choose>
</main>

<%--<jsp:include page="/WEB-INF/views/common/footer.jsp" />--%>

<%-- 5. 결제 위젯 모달 UI --%>
<div id="payment-modal" class="modal-overlay">
    <div class="modal-content">
        <button class="close-btn" onclick="closePaymentModal()">×</button>
        <h3>결제하기</h3>
        <div id="payment-method"></div>
        <div id="agreement"></div>
        <button class="button" id="payment-widget-button" style="margin-top: 30px; width: 100%;">결제하기</button>
    </div>
</div>

<%-- 6. 모든 JavaScript 로직 --%>
<script>
    // Swiper 슬라이더 초기화
    var swiper = new Swiper(".mySwiper", {
        navigation: { nextEl: ".swiper-button-next", prevEl: ".swiper-button-prev" },
        pagination: { el: ".swiper-pagination", clickable: true },
        loop: true,
    });

    // FullCalendar 초기화
    document.addEventListener('DOMContentLoaded', function () {
        const calendarEl = document.getElementById('class-date-calendar');
        const startDateTime = '${classDetail.startAt.toString()}';
        const endDateTime = '${classDetail.endAt.toString()}';
        const startTime = startDateTime.split('T')[1].substring(0, 5);
        const endTime = endDateTime.split('T')[1].substring(0, 5);

        const calendar = new FullCalendar.Calendar(calendarEl, {
            initialView: 'dayGridMonth',
            initialDate: startDateTime,
            events: [{ title: startTime + ' - ' + endTime, start: startDateTime, end: endDateTime }],
            displayEventTime: false
        });
        calendar.render();
    });

    // 토스페이먼츠 결제 위젯 로직
    let paymentWidgets;
    const clientKey = "test_gck_docs_Ovk5rk1EwkEbP0W43n07xlzm";
    const tossPayments = TossPayments(clientKey);
    const customerKey = 'user-' + '${sessionScope.userId}';
    const amount = ${classDetail.price};

    document.addEventListener('DOMContentLoaded', async function () {
        paymentWidgets = tossPayments.widgets({ customerKey });
        await paymentWidgets.setAmount({ currency: "KRW", value: amount });
        await Promise.all([
            paymentWidgets.renderPaymentMethods({ selector: "#payment-method", variantKey: "DEFAULT" }),
            paymentWidgets.renderAgreement({ selector: "#agreement", variantKey: "AGREEMENT" })
        ]);
    });

    function openPaymentModal() {
        document.getElementById('payment-modal').style.display = 'flex';
    }

    function closePaymentModal() {
        document.getElementById('payment-modal').style.display = 'none';
    }

    document.getElementById("payment-widget-button").addEventListener("click", async function () {
        const domain = window.location.origin;
        const contextPath = "${pageContext.request.contextPath}";
        const uniqueOrderId = 'oneday-' + '${classDetail.classId}' + '-' + '${sessionScope.userId}' + '-' + Date.now();
        try {
            await paymentWidgets.requestPayment({
                orderId: uniqueOrderId,
                orderName: "${classDetail.className}",
                successUrl: domain + contextPath + "/api/payment/success",
                failUrl: domain + contextPath + "/api/payment/fail",
            });
        } catch (error) {
            console.error(error);
        }
    });

    document.getElementById('payment-modal').addEventListener('click', function(event) {
        if (event.target === this) closePaymentModal();
    });
</script>

<%-- 지도 초기화 스크립트 --%>
<script src="${pageContext.request.contextPath}/static/js/kakaoMap.js"></script>
<script>
    // 지도 초기화 함수 호출
    initKakaoMap('${classDetail.latitude}', '${classDetail.longitude}', '${classDetail.className}');
</script>
</body>
</html>