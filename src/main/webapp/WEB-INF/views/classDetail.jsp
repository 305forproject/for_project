<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>${classDetail.className} - 상세 정보</title>
    <script src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.9/index.global.min.js'></script>
    <style>
        .container { max-width: 800px; margin: 40px auto; }
        .detail-item span { font-weight: bold; }
        #class-date-calendar { max-width: 600px; margin: 20px 0; }
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

            <button>예약하기</button>

        </c:when>
        <c:otherwise>
            <h1>클래스 정보를 찾을 수 없습니다.</h1>
        </c:otherwise>
    </c:choose>
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
</body>
</html>