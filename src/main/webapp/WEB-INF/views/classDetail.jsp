<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${classDetail.className} - 상세 정보</title>

    <!-- 필요한 라이브러리 -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css"/>
    <script src="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.js"></script>
    <script src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.9/index.global.min.js'></script>
    <script src="https://js.tosspayments.com/v2/standard"></script>
    <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${kakaoJsKey}"></script>

    <style>
        /* 클래스 상세 페이지 스타일 */
        .class-detail-container {
            max-width: 1200px;
            margin: 40px auto;
            padding: 0 20px;
        }
        
        .class-summary {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 40px;
            margin-bottom: 60px;
        }
        
        .class-img.swiper {
            width: 100%;
            height: 500px;
            border-radius: var(--border-radius);
            overflow: hidden;
            box-shadow: var(--shadow-md);
        }
        
        .class-side {
            display: flex;
            flex-direction: column;
            justify-content: center;
            padding: 20px;
        }
        
        .class-title {
            font-size: 32px;
            font-weight: 700;
            color: var(--text-primary);
            margin-bottom: 20px;
        }
        
        .class-infomation {
            font-size: 16px;
            color: var(--text-secondary);
            line-height: 1.8;
            margin-bottom: 24px;
        }
        
        .class-price {
            font-size: 36px;
            font-weight: 700;
            color: var(--primary-color);
            margin-bottom: 32px;
        }
        
        .apply-btn {
            width: 100%;
            padding: 18px;
            background: var(--primary-color);
            color: var(--text-white);
            border: none;
            border-radius: var(--border-radius);
            font-size: 18px;
            font-weight: 700;
            cursor: pointer;
            transition: var(--transition);
        }
        
        .apply-btn:hover {
            background: var(--primary-dark);
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
        }
        
        .class-info,
        .reservation-calendar,
        .class-location {
            background: var(--bg-white);
            border-radius: var(--border-radius);
            padding: 40px;
            margin-bottom: 40px;
            box-shadow: var(--shadow-sm);
        }
        
        .class-info h2,
        .reservation-calendar h2,
        .class-location h2 {
            font-size: 24px;
            font-weight: 700;
            color: var(--text-primary);
            margin-bottom: 24px;
            padding-bottom: 16px;
            border-bottom: 2px solid var(--primary-color);
        }
        
        .info-box {
            list-style: none;
            padding: 0;
        }
        
        .info-box li {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 16px 0;
            border-bottom: 1px solid var(--border-color);
            font-size: 16px;
            color: var(--text-secondary);
        }
        
        .info-box li:last-child {
            border-bottom: none;
        }
        
        .info-box img {
            width: 24px;
            height: 24px;
        }
        
        #class-date-calendar {
            margin-top: 20px;
        }
        
        #map {
            width: 100%;
            height: 400px;
            border-radius: var(--border-radius);
            margin-bottom: 16px;
        }
        
        /* 결제 모달 */
        .modal-overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.5);
            z-index: 2000;
            align-items: center;
            justify-content: center;
        }
        
        .modal-overlay .modal-content {
            background: var(--bg-white);
            border-radius: var(--border-radius);
            padding: 40px;
            max-width: 600px;
            width: 90%;
            max-height: 90vh;
            overflow-y: auto;
            position: relative;
        }
        
        .close-btn {
            position: absolute;
            top: 20px;
            right: 20px;
            font-size: 32px;
            color: var(--text-muted);
            background: none;
            border: none;
            cursor: pointer;
        }
        
        .close-btn:hover {
            color: var(--text-primary);
        }
        
        .modal-overlay h3 {
            font-size: 24px;
            font-weight: 700;
            margin-bottom: 24px;
            color: var(--text-primary);
        }
        
        #payment-widget-button {
            width: 100%;
            padding: 18px;
            background: var(--primary-color);
            color: var(--text-white);
            border: none;
            border-radius: var(--border-radius);
            font-size: 18px;
            font-weight: 700;
            cursor: pointer;
            margin-top: 24px;
        }
        
        #payment-widget-button:hover {
            background: var(--primary-dark);
        }
        
        /* 반응형 */
        @media screen and (max-width: 1024px) {
            .class-summary {
                grid-template-columns: 1fr;
                gap: 30px;
            }
            
            .class-img.swiper {
                height: 400px;
            }
        }
        
        @media screen and (max-width: 768px) {
            .class-detail-container {
                padding: 0 16px;
            }
            
            .class-info,
            .reservation-calendar,
            .class-location {
                padding: 24px 16px;
            }
            
            .class-title {
                font-size: 24px;
            }
            
            .class-price {
                font-size: 28px;
            }
            
            #map {
                height: 300px;
            }
        }
    </style>
</head>
<body>
    <!-- 공통 헤더 포함 -->
    <jsp:include page="/WEB-INF/views/includes/header.jsp" />

    <main class="class-detail-container">
        <c:choose>
            <c:when test="${not empty classDetail}">
                <!-- 클래스 요약 정보 -->
                <section class="class-summary">
                    <!-- 이미지 슬라이더 -->
                    <div class="class-img swiper mySwiper">
                        <div class="swiper-wrapper">
                            <c:forEach items="${classDetail.images}" var="image">
                                <div class="swiper-slide">
                                    <img src="${pageContext.request.contextPath}${image.imageUrl}" 
                                         alt="${classDetail.className}">
                                </div>
                            </c:forEach>
                        </div>
                        <div class="swiper-button-next"></div>
                        <div class="swiper-button-prev"></div>
                        <div class="swiper-pagination"></div>
                    </div>

                    <!-- 클래스 정보 -->
                    <div class="class-side">
                        <h2 class="class-title">${classDetail.className}</h2>
                        <p class="class-infomation">${classDetail.description}</p>
                        <p class="class-price">
                            <fmt:formatNumber value="${classDetail.price}" type="currency" currencySymbol="₩"/>
                        </p>
                        <button class="apply-btn" onclick="openPaymentModal()">
                            💳 클래스 신청하기
                        </button>
                    </div>
                </section>

                <!-- 클래스 상세 정보 -->
                <section class="class-info">
                    <h2>📋 클래스 정보</h2>
                    <ul class="info-box">
                        <li>
                            <img src="${pageContext.request.contextPath}/static/img/time-icon.png" alt="시간">
                            <span>
                                <fmt:formatDate value="${classDetail.startAtAsDate}" pattern="HH:mm"/> ~ 
                                <fmt:formatDate value="${classDetail.endAtAsDate}" pattern="HH:mm"/>
                            </span>
                        </li>
                        <li>
                            <img src="${pageContext.request.contextPath}/static/img/location-icon.png" alt="주소">
                            <span>${classDetail.location}</span>
                        </li>
                        <li>
                            <img src="${pageContext.request.contextPath}/static/img/people-icon.png" alt="인원">
                            <span>
                                ${classDetail.currentReservationCount} / ${classDetail.maxStudents} 명
                            </span>
                        </li>
                    </ul>
                </section>

                <!-- 운영 시간 (캘린더) -->
                <section class="reservation-calendar">
                    <h2>📅 운영 시간</h2>
                    <div id="class-date-calendar"></div>
                </section>

                <!-- 클래스 위치 (지도) -->
                <section class="class-location">
                    <h2>📍 클래스 위치</h2>
                    <div id="map"></div>
                    <p style="display: flex; align-items: center; gap: 8px; color: var(--text-secondary);">
                        <img src="${pageContext.request.contextPath}/static/img/location-icon.png" 
                             alt="주소" style="width: 20px;">
                        ${classDetail.location}
                    </p>
                </section>

            </c:when>
            <c:otherwise>
                <div class="no-classes">
                    <h1>클래스 정보를 찾을 수 없습니다.</h1>
                </div>
            </c:otherwise>
        </c:choose>
    </main>

    <!-- 공통 푸터 포함 -->
    <jsp:include page="/WEB-INF/views/includes/footer.jsp" />

    <!-- 결제 모달 -->
    <div id="payment-modal" class="modal-overlay">
        <div class="modal-content">
            <button class="close-btn" onclick="closePaymentModal()">×</button>
            <h3>결제하기</h3>
            <div id="payment-method"></div>
            <div id="agreement"></div>
            <button id="payment-widget-button">결제하기</button>
        </div>
    </div>

    <!-- JavaScript -->
    <script>
        // Swiper 초기화
        var swiper = new Swiper(".mySwiper", {
            navigation: { 
                nextEl: ".swiper-button-next", 
                prevEl: ".swiper-button-prev" 
            },
            pagination: { 
                el: ".swiper-pagination", 
                clickable: true 
            },
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
                events: [{ 
                    title: startTime + ' - ' + endTime, 
                    start: startDateTime, 
                    end: endDateTime 
                }],
                displayEventTime: false
            });
            calendar.render();
        });

        // 토스페이먼츠 결제
        let paymentWidgets;
        const clientKey = "test_gck_docs_Ovk5rk1EwkEbP0W43n07xlzm";
        const tossPayments = TossPayments(clientKey);
        const customerKey = 'user-' + '${sessionScope.userId}';
        const amount = ${classDetail.price};

        document.addEventListener('DOMContentLoaded', async function () {
            paymentWidgets = tossPayments.widgets({ customerKey });
            await paymentWidgets.setAmount({ currency: "KRW", value: amount });
            await Promise.all([
                paymentWidgets.renderPaymentMethods({ 
                    selector: "#payment-method", 
                    variantKey: "DEFAULT" 
                }),
                paymentWidgets.renderAgreement({ 
                    selector: "#agreement", 
                    variantKey: "AGREEMENT" 
                })
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
            const uniqueOrderId = 'oneday-' + '${classDetail.classId}' + '-' + 
                                 '${sessionScope.userId}' + '-' + Date.now();
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

    <!-- 지도 초기화 -->
    <script src="${pageContext.request.contextPath}/static/js/kakaoMap.js"></script>
    <script>
        initKakaoMap('${classDetail.latitude}', '${classDetail.longitude}', '${classDetail.className}');
    </script>
</body>
</html>
