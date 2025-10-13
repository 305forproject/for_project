<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>원데이 클래스 - 메인</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
        }

        h1 {
            text-align: center;
            color: #333;
            margin-bottom: 30px;
        }

        .class-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 20px;
            padding: 20px;
        }

        .class-card {
            border: 1px solid #ddd;
            border-radius: 8px;
            overflow: hidden;
            cursor: pointer;
            transition: transform 0.2s;
            background: white;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        .class-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
        }

        .class-image {
            width: 100%;
            height: 200px;
            object-fit: cover;
        }

        .class-info {
            padding: 15px;
        }

        .class-name {
            font-size: 18px;
            font-weight: bold;
            margin-bottom: 8px;
            color: #333;
        }

        .class-teacher {
            color: #666;
            margin-bottom: 5px;
        }

        .class-price {
            color: #e74c3c;
            font-weight: bold;
            margin-bottom: 5px;
            font-size: 16px;
        }

        .class-date {
            color: #555;
            font-size: 14px;
            margin-bottom: 5px;
        }

        .class-location {
            color: #777;
            font-size: 14px;
        }

        .no-classes {
            text-align: center;
            padding: 50px;
            color: #666;
            font-size: 18px;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
        }

        .no-image-placeholder {
            display: flex;
            height: 200px;
            background-color: #f0f0f0;
            align-items: center;
            justify-content: center;
            color: #666;
        }
    </style>
</head>
<body>
<div class="container">
    <h1>원데이 클래스</h1>

    <c:if test="${empty classList}">
        <div class="no-classes">
            <p>등록된 강의가 없습니다.</p>
        </div>
    </c:if>

    <c:if test="${not empty classList}">
        <div class="class-grid">
            <c:forEach var="clazz" items="${classList}">
                <div class="class-card" onclick="goToClassDetail('${clazz.classId}')">
                    <c:choose>
                        <c:when test="${not empty clazz.representativeImageUrl}">
                            <img src="${pageContext.request.contextPath}${clazz.representativeImageUrl}"
                                 alt="${clazz.className}"
                                 class="class-image"
                                 onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
                        </c:when>
                        <c:otherwise>
                            <div class="no-image-placeholder" style="display: flex;">
                                <span>이미지 없음</span>
                            </div>
                        </c:otherwise>
                    </c:choose>

                    <div class="no-image-placeholder"
                         style="display: none; height: 200px; background-color: #f0f0f0; align-items: center; justify-content: center; color: #666;">
                        <span>이미지를 불러올 수 없습니다</span>
                    </div>

                    <div class="class-info">
                        <div class="class-name">${clazz.className}</div>
                        <div class="class-teacher">강사: ${clazz.teacherName}</div>
                        <div class="class-price">
                            <fmt:formatNumber value="${clazz.price}" pattern="#,###"/>원
                        </div>
                        <div class="class-date">일시: ${clazz.startAt}</div>
                        <div class="class-location">장소: ${clazz.location}</div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </c:if>
</div>

<script>
    function goToClassDetail(classId) {
        // 강의 상세 페이지로 이동 (실제 URL은 프로젝트에 맞게 수정)
        window.location.href = '${pageContext.request.contextPath}/class/detail?classId=' + classId;
    }
</script>
</body>
</html>
