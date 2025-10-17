<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>원데이 클래스 - 메인</title>
</head>
<body>
    <!-- 공통 헤더 포함 -->
    <jsp:include page="/WEB-INF/views/includes/header.jsp" />

    <!-- 메인 컨텐츠 영역 -->
    <div class="main-container">
        <h1 class="section-title">🎨 특별한 원데이 클래스를 만나보세요</h1>

        <!-- 빈 목록 상태 -->
        <c:if test="${empty classList}">
            <div class="no-classes">
                <p>😊 등록된 강의가 없습니다.</p>
                <p style="font-size: 14px; color: var(--text-muted);">
                    새로운 클래스가 곧 업데이트될 예정입니다.
                </p>
            </div>
        </c:if>

        <!-- 클래스 목록 -->
        <c:if test="${not empty classList}">
            <div class="class-grid">
                <c:forEach var="clazz" items="${classList}">
                    <div class="class-card" onclick="goToClassDetail(${clazz.classId})">
                        <!-- 이미지 영역 -->
                        <div class="class-image-wrapper">
                            <c:choose>
                                <c:when test="${not empty clazz.representativeImageUrl}">
                                    <img src="${pageContext.request.contextPath}${clazz.representativeImageUrl}"
                                         alt="${clazz.className}"
                                         class="class-image"
                                         onerror="this.style.display='none'; this.parentElement.querySelector('.no-image-placeholder').style.display='flex';">
                                </c:when>
                                <c:otherwise>
                                    <div class="no-image-placeholder" style="display: flex;">
                                        <span>이미지 없음</span>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                            
                            <!-- 이미지 로드 실패 시 표시될 플레이스홀더 -->
                            <div class="no-image-placeholder" style="display: none;">
                                <span>이미지를 불러올 수 없습니다</span>
                            </div>
                        </div>

                        <!-- 정보 영역 -->
                        <div class="class-info">
                            <!-- 카테고리 배지 (있는 경우) -->
                            <c:if test="${not empty clazz.categoryName}">
                                <span class="class-category">${clazz.categoryName}</span>
                            </c:if>
                            
                            <div class="class-name">${clazz.className}</div>
                            <div class="class-teacher">👤 ${clazz.teacherName}</div>
                            <div class="class-price">
                                <fmt:formatNumber value="${clazz.price}" pattern="#,###"/>원
                            </div>
                            <div class="class-date">
                                <fmt:formatDate value="${clazz.startAtAsDate}" pattern="yyyy.MM.dd HH:mm"/>
                            </div>
                            <div class="class-location">${clazz.location}</div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:if>
    </div>

    <!-- 공통 푸터 포함 -->
    <jsp:include page="/WEB-INF/views/includes/footer.jsp" />

    <!-- JavaScript -->
    <script>
        function goToClassDetail(classId) {
            window.location.href = '${pageContext.request.contextPath}/class/detail?classId=' + classId;
        }
    </script>
</body>
</html>
