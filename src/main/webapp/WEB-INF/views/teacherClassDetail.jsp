<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>강의 상세 정보</title>
    <style>
        body { font-family: sans-serif; }
        .container { width: 600px; margin: 20px auto; padding: 20px; border: 1px solid #ddd; border-radius: 8px; }
        .detail-item { margin-bottom: 10px; }
        .detail-item span { font-weight: bold; min-width: 120px; display: inline-block; }
    </style>
</head>
<body>
<div class="container">
    <h1>강의 상세 정보</h1>
    <c:choose>
        <c:when test="${not empty classDetail}">
            <div class="detail-item">
                <span>강의명:</span> ${classDetail.className}
            </div>
            <div class="detail-item">
                <span>수업 시작:</span> <fmt:formatDate value="${classDetail.startAt}" pattern="yyyy년 MM월 dd일 HH:mm"/>
            </div>
            <div class="detail-item">
                <span>수업 종료:</span> <fmt:formatDate value="${classDetail.endAt}" pattern="yyyy년 MM월 dd일 HH:mm"/>
            </div>
            <div class="detail-item">
                <span>장소:</span> ${classDetail.location}
            </div>
            <div class="detail-item">
                <span>현재 예약 인원:</span> ${classDetail.currentReservationCount} 명
            </div>
            <div class="detail-item">
                <span>최대 수용 인원:</span> ${classDetail.maxCapacity} 명
            </div>
        </c:when>
        <c:otherwise>
            <p>강의 정보를 찾을 수 없거나 조회할 권한이 없습니다.</p>
        </c:otherwise>
    </c:choose>
    <br>
    <a href="javascript:history.back()">목록으로 돌아가기</a>
</div>
</body>
</html>