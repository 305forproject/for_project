<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>내 예약 달력</title>
    <style>
        body { font-family: sans-serif; }
        .container { width: 800px; margin: 20px auto; }
        .filter-form { margin-bottom: 20px; }
        table { width: 100%; border-collapse: collapse; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #f2f2f2; }
        .no-result { color: #888; }
    </style>
</head>
<body>

<div class="container">
    <h1>내 예약 달력</h1>

    <%-- 연/월 선택 폼 --%>
    <form class="filter-form" action="${pageContext.request.contextPath}/api/users/myPage" method="GET">
        <select name="year">
            <option value="2025">2025년</option>
            <option value="2024">2024년</option>
        </select>
        <select name="month">
            <c:forEach begin="1" end="12" var="m">
                <option value="${m}">${m}월</option>
            </c:forEach>
        </select>
        <button type="submit">조회하기</button>
    </form>

    <%-- 조회 결과 표시 --%>
    <hr>
    <h3>조회 결과</h3>
    <table>
        <thead>
        <tr>
            <th>예약 ID</th>
            <th>카테고리</th>
            <th>수업 시작 시간</th>
            <th>수업 종료 시간</th>
        </tr>
        </thead>
        <tbody>
        <c:choose>
            <c:when test="${not empty calendarEvents}">
                <c:forEach items="${calendarEvents}" var="event">
                    <tr>
                        <td>
                                <%-- 예약 ID를 클릭 가능한 링크로 변경 --%>
                            <a href="${pageContext.request.contextPath}/api/reservations/${event.reservationId}">
                                    ${event.reservationId}
                            </a>
                        </td>
                        <td>${event.category}</td>
                        <td><fmt:formatDate value="${event.startAt}" pattern="yyyy-MM-dd HH:mm"/></td>
                        <td><fmt:formatDate value="${event.endAt}" pattern="yyyy-MM-dd HH:mm"/></td>
                    </tr>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <tr>
                    <td colspan="4" class="no-result">해당 월에 예약이 없습니다.</td>
                </tr>
            </c:otherwise>
        </c:choose>
        </tbody>
    </table>
</div>

</body>
</html>