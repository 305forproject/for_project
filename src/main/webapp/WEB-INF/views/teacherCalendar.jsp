<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>내 강의 현황</title>
    <script src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.9/index.global.min.js'></script>
    <script src="${pageContext.request.contextPath}/static/js/calendar.js"></script>
    <style>
        body { font-family: sans-serif; }
        .container { max-width: 1200px; margin: 40px auto; display: flex; gap: 20px; }
        #calendar-container { flex: 2; }
        #detail-container { flex: 1; border: 1px solid #ddd; padding: 20px; border-radius: 8px; height: fit-content; }
        .detail-item { margin-bottom: 10px; }
        .detail-item span { font-weight: bold; }
        .placeholder { color: #888; }
    </style>
</head>
<body>

<div class="container">
    <div id="calendar-container">
        <h1>내 강의 현황</h1>
        <div id="teacher-calendar"></div>
    </div>

    <div id="detail-container">
        <h3>강의 상세 정보</h3>
        <div id="event-detail-box">
            <p class="placeholder">달력에서 강의를 클릭하세요.</p>
        </div>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        // 선생님 강의 정보를 JSON으로 보내주는 컨트롤러의 URL
        const teacherEventsUrl = "${pageContext.request.contextPath}/teachers/classes";

        // 달력 이벤트를 클릭했을 때 상세 정보를 요청할 URL의 앞부분
        const teacherDetailUrlPrefix = "${pageContext.request.contextPath}/teachers/classes/";

        initializeCalendar('teacher-calendar', '/oneday/teachers/classes/events', teacherDetailUrlPrefix);
    });
</script>

</body>
</html>