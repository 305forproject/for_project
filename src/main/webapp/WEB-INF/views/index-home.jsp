<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>원데이 클래스 - 홈</title>
    
    <!-- Swiper 슬라이더 CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css"/>
    
    <!-- 추가 스타일 -->
    <style>
        /* 슬라이더 스타일 */
        .swiper {
            max-width: 1100px;
            margin: 40px auto;
            height: 500px;
            border-radius: var(--border-radius);
            overflow: hidden;
            box-shadow: var(--shadow-lg);
        }
        
        .swiper-slide {
            display: flex;
            justify-content: center;
            align-items: center;
        }
        
        .swiper-slide img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        
        .swiper-button-next,
        .swiper-button-prev {
            color: var(--primary-color);
        }
        
        .swiper-pagination-bullet-active {
            background: var(--primary-color);
        }
        
        /* 반응형 슬라이더 */
        @media screen and (max-width: 768px) {
            .swiper {
                height: 300px;
                margin: 20px 16px;
            }
        }
    </style>
</head>
<body>
    <!-- 공통 헤더 포함 -->
    <jsp:include page="/WEB-INF/views/includes/header.jsp" />

    <!-- 슬라이더 영역 -->
    <div class="swiper mySwiper">
        <div class="swiper-wrapper">
            <c:forEach items="${slideImages}" var="image">
                <div class="swiper-slide">
                    <a href="${pageContext.request.contextPath}/class/detail?classId=${image.classId}">
                        <img src="${pageContext.request.contextPath}${image.imageUrl}" alt="클래스 이미지">
                    </a>
                </div>
            </c:forEach>
        </div>
        <div class="swiper-button-next"></div>
        <div class="swiper-button-prev"></div>
        <div class="swiper-pagination"></div>
    </div>

    <!-- 메인 컨텐츠 영역 -->
    <main class="main-container">
        <!-- 섹션 타이틀 -->
        <div class="items-menu">
            <h2 class="section-title">✨ 추천 강의</h2>
        </div>

        <!-- 카테고리 필터 -->
        <div class="category-filters">
            <a href="${pageContext.request.contextPath}/main?sort=${currentSort}"
               class="${empty currentCategory ? 'active' : ''}">
                전체보기
            </a>
            <c:forEach items="${categories}" var="category">
                <a href="${pageContext.request.contextPath}/main?categoryId=${category.categoryId}&sort=${currentSort}"
                   class="${currentCategory == category.categoryId ? 'active' : ''}">
                    ${category.category}
                </a>
            </c:forEach>
        </div>

        <!-- 정렬 옵션 -->
        <div class="sort-options">
            <a href="${pageContext.request.contextPath}/main?sort=newest<c:if test='${not empty currentCategory}'>&categoryId=${currentCategory}</c:if>"
               class="${currentSort == 'newest' ? 'active' : ''}">최신순</a>
            |
            <a href="${pageContext.request.contextPath}/main?sort=popular<c:if test='${not empty currentCategory}'>&categoryId=${currentCategory}</c:if>"
               class="${currentSort == 'popular' ? 'active' : ''}">인기순</a>
            |
            <a href="${pageContext.request.contextPath}/main?sort=deadline<c:if test='${not empty currentCategory}'>&categoryId=${currentCategory}</c:if>"
               class="${currentSort == 'deadline' ? 'active' : ''}">마감임박순</a>
        </div>

        <!-- 클래스 카드 그리드 -->
        <div class="class-grid">
            <c:forEach items="${classList}" var="classItem">
                <div class="class-card">
                    <a href="${pageContext.request.contextPath}/class/detail?classId=${classItem.classId}">
                        <div class="class-image-wrapper">
                            <img src="${pageContext.request.contextPath}${classItem.representativeImageUrl}"
                                 alt="${classItem.className}"
                                 class="class-image">
                        </div>
                        <div class="class-info">
                            <span class="class-category">${classItem.categoryName}</span>
                            <div class="class-name">${classItem.className}</div>
                            <div class="class-teacher">👤 ${classItem.teacherName}</div>
                        </div>
                    </a>
                </div>
            </c:forEach>
        </div>
    </main>

    <!-- 공통 푸터 포함 -->
    <jsp:include page="/WEB-INF/views/includes/footer.jsp" />

    <!-- JavaScript -->
    <script src="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/static/js/utils.js"></script>
    <script src="${pageContext.request.contextPath}/static/js/signup.js"></script>
    <script src="${pageContext.request.contextPath}/static/js/teacher-page.js"></script>
    
    <script>
        // Swiper 초기화
        var swiper = new Swiper(".mySwiper", {
            loop: true,
            autoplay: {
                delay: 3500,
                disableOnInteraction: false,
            },
            pagination: {
                el: ".swiper-pagination",
                clickable: true,
            },
            navigation: {
                nextEl: ".swiper-button-next",
                prevEl: ".swiper-button-prev",
            },
        });
    </script>
</body>
</html>
