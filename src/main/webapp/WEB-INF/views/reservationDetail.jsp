<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>예약 상세 정보</title>
    <style>
        body { font-family: sans-serif; }
        .container { width: 600px; margin: 20px auto; padding: 20px; border: 1px solid #ddd; border-radius: 8px; }
        .detail-item { margin-bottom: 10px; }
        .detail-item span { font-weight: bold; }
    </style>
</head>
<body>
<div class="container">
    <h1>예약 상세 정보</h1>
    <c:choose>
        <c:when test="${not empty reservationDetail}">
            <div class="detail-item">
                <span>강의명:</span> ${reservationDetail.className}
            </div>
            <div class="detail-item">
                <span>수업 시작:</span> <fmt:formatDate value="${reservationDetail.startAtAsDate}" pattern="yyyy년 MM월 dd일 HH:mm"/>
            </div>
            <div class="detail-item">
                <span>수업 종료:</span> <fmt:formatDate value="${reservationDetail.endAtAsDate}" pattern="yyyy년 MM월 dd일 HH:mm"/>
            </div>
            <div class="detail-item">
                <span>장소:</span> ${reservationDetail.location}
            </div>
        </c:when>
        <c:otherwise>
            <p>예약 정보를 찾을 수 없거나 조회할 권한이 없습니다.</p>
        </c:otherwise>
    </c:choose>
    <br>
    <a href="javascript:history.back()">뒤로가기</a>
</div>
</body>
</html>