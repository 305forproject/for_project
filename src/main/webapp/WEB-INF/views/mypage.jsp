<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>내 예약 현황</title>
    <script src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.9/index.global.min.js'></script>
    <script src="${pageContext.request.contextPath}/static/js/calendar.js"></script>
    <style>
        body { font-family: sans-serif; }
        .container { max-width: 1200px; margin: 40px auto; display: flex; gap: 20px; }
        #calendar-container { flex: 2; /* 2:1 비율로 왼쪽이 더 넓게 */ }
        #detail-container { flex: 1; border: 1px solid #ddd; padding: 20px; border-radius: 8px; height: fit-content; }
        .detail-item { margin-bottom: 10px; }
        .detail-item span { font-weight: bold; }
        .placeholder { color: #888; }
    </style>
</head>
<body>

<div class="container">
    <%-- 1. 왼쪽: FullCalendar가 그려질 영역 --%>
    <div id="calendar-container">
        <div id="my-calendar"></div>
    </div>

    <%-- 2. 오른쪽: 예약 상세 내용이 표시될 영역 --%>
    <div id="detail-container">
        <h3>예약 상세 정보</h3>
        <div id="event-detail-box">
            <p class="placeholder">달력에서 예약을 클릭하세요.</p>
        </div>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        // 학생 예약 정보를 JSON으로 보내주는 컨트롤러의 URL
        const studentEventsUrl = "${pageContext.request.contextPath}/users/mypage";

        // 달력 이벤트를 클릭했을 때 상세 정보를 요청할 URL의 앞부분
        const studentDetailUrlPrefix = "${pageContext.request.contextPath}/reservations/";

        // 'my-calendar' div에 달력을 그리라고 명령
        initializeCalendar('my-calendar', studentEventsUrl, studentDetailUrlPrefix);
    });
</script>

</body>
</html>