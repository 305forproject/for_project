<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="oneday.util.PropertyUtil" %>
<html>
<head>
    <title>내 예약 현황</title>
    <script src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.9/index.global.min.js'></script>
    <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=<%= PropertyUtil.getKakaoJavascriptKey() %>"></script>
    <script src="${pageContext.request.contextPath}/static/js/calendar.js"></script>
    <script src="${pageContext.request.contextPath}/static/js/kakaoMap.js"></script>
    <style>
        body { font-family: sans-serif; }
        .container { max-width: 1200px; margin: 40px auto; display: flex; gap: 20px; }
        #calendar-container { flex: 2; }
        #right-section { flex: 1; display: flex; flex-direction: column; gap: 20px; }
        #detail-container { border: 1px solid #ddd; padding: 20px; border-radius: 8px; }
        #map-container { border: 1px solid #ddd; border-radius: 8px; overflow: hidden; }
        #map { width: 100%; height: 400px; }
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

    <%-- 2. 오른쪽: 예약 상세 정보 + 카카오 맵 --%>
    <div id="right-section">
        <%-- 2-1. 예약 상세 정보 영역 --%>
        <div id="detail-container">
            <h3>예약 상세 정보</h3>
            <div id="event-detail-box">
                <p class="placeholder">달력에서 예약을 클릭하세요.</p>
            </div>
        </div>

        <%-- 2-2. 카카오 맵 영역 --%>
        <div id="map-container">
            <div id="map"></div>
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