<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>내 예약 달력</title>

    <%-- 1. FullCalendar 라이브러리 CSS, JS를 불러옵니다. --%>
    <script src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.9/index.global.min.js'></script>

    <%-- 2. 우리가 만든 calendar.js 파일을 불러옵니다. --%>
    <script src="${pageContext.request.contextPath}/static/js/calendar.js"></script>

    <style>
        body { font-family: sans-serif; }
        .container { max-width: 900px; margin: 40px auto; }
    </style>
</head>
<body>

<div class="container">
    <h1>내 예약 달력</h1>

    <%-- 3. FullCalendar가 그려질 비어있는 div 영역만 남겨둡니다. --%>
    <div id="my-calendar"></div>
</div>

<script>
    // 4. 페이지가 로드되면, 우리가 만든 달력 초기화 함수를 호출합니다.
    document.addEventListener('DOMContentLoaded', function() {
        // 학생 예약 정보를 JSON으로 보내주는 컨트롤러의 URL
        const studentEventsUrl = "${pageContext.request.contextPath}/users/myPage";

        // 달력 이벤트를 클릭했을 때 이동할 상세 페이지 URL의 앞부분
        const studentDetailUrlPrefix = "${pageContext.request.contextPath}/reservations/";

        // 'my-calendar'라는 ID를 가진 div에, 위 URL들을 사용하여 달력을 그리라고 명령합니다.
        initializeCalendar('my-calendar', studentEventsUrl, studentDetailUrlPrefix);
    });
</script>

</body>
</html>