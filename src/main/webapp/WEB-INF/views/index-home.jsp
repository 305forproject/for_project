<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
    <%--  슬라이더 api css  --%>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/home.css">

    <title>Home</title>

</head>

<body>
<!-- Header 영역 -->
<header class="header">
    <div class="header-container">
        <!-- 로고 영역 -->
        <div class="logo">
            <div class="logo-img">
                <img src="${pageContext.request.contextPath}/static/img/mainlogo.png" alt="logoimg">
            </div>
            <div class="logo-text">로고</div>
        </div>

        <!-- 마이페이지 아이콘 영역 -->
        <div class="mypage-icon">
            <div class="icons">
                <!-- 강사 아이콘 -->
                <button type="button" class="mypage-icon-lecturer-img">
                    <img src="${pageContext.request.contextPath}/static/img/mypage-icon-lecturer.png"
                         alt="icon-lecturer">
                </button>

                <!-- 학생 아이콘 -->
                <button type="button" class="mypage-icon-student-img">
                    <img src="${pageContext.request.contextPath}/static/img/mypage-icon-student.png" alt="icon-student">

                </button>
            </div>
        </div>

        <!-- 모바일 메뉴 (선택사항) -->
        <button class="mobile-menu-toggle" aria-label="메뉴 열기" type="button">
            <span></span>
            <span></span>
            <span></span>
        </button>
    </div>
</header>

<!-- 모바일 메뉴 모달 -->
<div id="mobileMenuModal" class="mobile-menu-modal">
    <div class="mobile-menu-modal-content">
        <div class="mobile-menu-header">
            <h2>원데이클래스</h2>
            <button id="closeMobileMenu" class="close">></button>
        </div>
        <div id="mobileAuthButtons" class="mobile-auth-buttons">
            <button id="mobileLoginBtn" class="mobile-auth-btn">로그인</button>
            <button id="mobileJoinBtn" class="mobile-auth-btn">회원가입</button>
            <button id="mobileLogoutBtn" class="mobile-auth-btn" style="display: none;">로그아웃</button>
        </div>
        <ul>
            <li><a href="#">강사 마이페이지</a></li>
            <li><a href="#">학생 마이페이지</a></li>
        </ul>
    </div>
</div>

<!--login, logout, join-->
<div class="login-container">
    <button id="loginBtn" class="btn btn-login-main">로그인</button>
    <button id="joinBtn" class="btn btn-join-main">회원가입</button>
    <button id="logoutBtn" class="btn btn-logout" style="display: none;">로그아웃</button>
</div>

<!-- Slider 영역 -->
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


<!--  강의 카드 영역 -->
<main class="main-container">
    <div class="items-menu">
        <h2>추천 강의</h2>
    </div>
    <%-- 카테고리 필터 버튼 영역 --%>
    <div class="category-filters">
        <a href="${pageContext.request.contextPath}/main?sort=${currentSort}">전체보기</a>

        <c:forEach items="${categories}" var="category">
            <a href="${pageContext.request.contextPath}/main?categoryId=${category.categoryId}&sort=${currentSort}">
                    ${category.category}
            </a>
        </c:forEach>
    </div>

    <%-- 정렬 옵션 영역 --%>
    <div class="sort-options">
        <%--
          '최신순' 링크: 현재 카테고리(currentCategory)는 유지하면서 sort 값만 'newest'로 변경
        --%>
        <a href="${pageContext.request.contextPath}/main?sort=newest<c:if test='${not empty currentCategory}'>&categoryId=${currentCategory}</c:if>">최신순</a> |
        <a href="${pageContext.request.contextPath}/main?sort=popular<c:if test='${not empty currentCategory}'>&categoryId=${currentCategory}</c:if>">인기순</a> |
        <a href="${pageContext.request.contextPath}/main?sort=deadline<c:if test='${not empty currentCategory}'>&categoryId=${currentCategory}</c:if>">마감임박순</a>
    </div>
    </div>
    <div class="items">
        <c:forEach items="${classList}" var="classItem">
            <article class="card">
                    <%-- 각 카드의 링크(href)를 동적으로 생성합니다. --%>
                <a href="${pageContext.request.contextPath}/class/detail?classId=${classItem.classId}">
                    <div class="img-card">
                            <%-- 4. 대표 이미지 URL을 동적으로 설정합니다. --%>
                        <img src="${pageContext.request.contextPath}${classItem.representativeImageUrl}"
                             alt="${classItem.className} 이미지">
                    </div>
                    <div class="card-body">
                        <p class="info1">${classItem.categoryName}</p>
                        <h3 class="class-name">${classItem.className}</h3>
                        <p class="info2">${classItem.teacherName}</p>
                    </div>
                </a>
            </article>
        </c:forEach>
</main>


<!-- Footer 영역 -->
<footer class="footer">
    <div class="footer-container">
        <div class="footer-top">
            <!-- 로고 프레임 -->
            <div class="footer-logo-frame">
                <div class="footer-logo">로고</div>
                <div class="footer-info">웹사이트 정보</div>
            </div>

            <!-- 고객센터, 운영시간, 연락처 -->
            <div class="footer-contents">
                <p>고객센터</p>
            </div>
            <div class="footer-contents">
                <p>운영시간</p>
                평일/주말 <br>
                10:00 - 17:00<br>
                (점심 : 12:00 - 13:00)
            </div>
            <div class="footer-contents">
                <p>연락처</p>
                010-1234-5678<br>
                oneday@class.com
            </div>
        </div>

        <hr>

        <div class="footer-down">
            <!-- 이용약관, 사업자 정보 -->
            <div class="footer-contents">
                <P>사업자 정보</P>
                사업자 등록번호: 123-45-67890<br>
                대표자: 홍길동<br>
                주소: 서울특별시 강남구 테헤란로 123, 45
            </div>

            <div class="footer-contents">
                <P>이용약관</P>
                개인정보처리방침
            </div>

        </div>
    </div>
</footer>

<!-- 로그인 모달 -->
<div id="loginModal" class="modal">
    <div class="modal-content">
        <div class="mobile-menu-header">
            <h2>로그인</h2>
            <% if (request.getAttribute("error") != null) { %>
            <p style="color: red;">${error}</p>
            <% } %>
            <span class="close">&times;</span>
        </div>
        <form id="loginForm" method="post" action="${pageContext.request.contextPath}/login">
            <input type="text" id="username" name="loginId" placeholder="아이디" required><br>
            <input type="password" id="password" name="password" placeholder="비밀번호" required><br>
            <button type="submit" class="btn btn-login-modal">로그인</button>
            <button type="button" class="btn btn-join-modal">회원가입</button>
        </form>
    </div>
</div>

<!-- 회원가입 모달 -->
<div id="joinModal" class="modal">
    <div class="modal-content">
        <div class="mobile-menu-header">
            <h2>회원가입</h2>
            <% if (request.getAttribute("signupError") != null) { %>
            <p style="color: red;">${signupError}</p>
            <% } %>
            <span class="close">&times;</span>
        </div>
        <form id="joinForm" method="post" action="${pageContext.request.contextPath}/signup">
            <input type="text" id="joinName" name="name" placeholder="이름" required><br>
            <input type="text" id="joinUsername" name="loginId" placeholder="아이디" required><br>
            <input type="password" id="joinPassword" name="password" placeholder="비밀번호" required><br>
            <small style="color: #666;">영문, 숫자 포함 8~20자를 입력해 주세요</small><br>
            <input type="password" id="joinPasswordConfirm" name="passwordConfirm" placeholder="비밀번호 확인" required><br>
            <small style="color: #666;">영문, 숫자 포함 8~20자를 입력해 주세요</small><br>
            <button type="submit" class="btn btn-join-modal">회원가입</button>
        </form>
    </div>
</div>

<!-- 성공/실패 메시지 모달 -->
<div id="messageModal" class="modal">
    <div class="modal-content">
        <div class="mobile-menu-header">
            <h2 id="messageTitle">알림</h2>
            <span class="close">&times;</span>
        </div>
        <p id="messageText">메시지가 여기에 표시됩니다.</p>
        <button id="messageOkBtn" class="btn btn-check">확인</button>
    </div>
</div>

<!-- 강사 계좌번호 등록 모달 -->
<div id="teacherAccountModal" class="modal">
    <div class="modal-content">
        <div class="mobile-menu-header">
            <h2>강사 계좌번호 등록</h2>
            <span class="close">&times;</span>
        </div>
        <form id="teacherAccountForm" method="post" action="${pageContext.request.contextPath}/teacher-page">
            <input type="text" id="accountNumber" name="accountNumber"
                   placeholder="계좌번호를 입력해주세요 (예: 국민은행 123-456-789012)" required maxlength="50"><br>
            <small style="color: #666; font-size: 12px; margin-bottom: 15px; display: block;">
                은행명과 계좌번호를 정확히 입력해주세요
            </small>
            <button type="submit" class="btn btn-login-modal">등록</button>
            <button type="button" class="btn btn-join-modal" onclick="closeTeacherAccountModal()">취소</button>
        </form>
    </div>
</div>

<%--js 파일 헤더에 위치시 태그 생성 전이라 인식을 하지 못함
따라서 가능하면 body 태그가 끝나기 전에 호출 할 것--%>
<script src="${pageContext.request.contextPath}/static/js/utils.js"></script>
<script src="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/static/js/script-home.js"></script>
<script src="${pageContext.request.contextPath}/static/js/auth.js"></script>
<script src="${pageContext.request.contextPath}/static/js/signup.js"></script>
<script src="${pageContext.request.contextPath}/static/js/teacher-account.js"></script>

<!-- 로그인 에러 처리를 위한 스크립트 -->
<% if (request.getAttribute("error") != null) { %>
<script>
    document.addEventListener('DOMContentLoaded', function () {
        const loginModal = document.getElementById('loginModal');
        if (loginModal) {
            loginModal.style.display = 'flex';
        }
    });
</script>
<% } %>

<!-- 회원가입 에러 처리를 위한 스크립트 -->
<% if (request.getAttribute("signupError") != null) { %>
<script>
    document.addEventListener('DOMContentLoaded', function () {
        const joinModal = document.getElementById('joinModal');
        if (joinModal) {
            joinModal.style.display = 'flex';
        }
    });
</script>
<% } %>

<!-- 회원가입 성공 처리를 위한 스크립트 -->
<% if (request.getAttribute("signupSuccess") != null) { %>
<script>
    document.addEventListener('DOMContentLoaded', function () {
        const messageModal = document.getElementById('messageModal');
        const messageTitle = document.getElementById('messageTitle');
        const messageText = document.getElementById('messageText');

        if (messageModal && messageTitle && messageText) {
            messageTitle.textContent = '회원가입 완료';
            messageText.textContent = '${signupSuccess}';
            messageModal.style.display = 'flex';

            // 확인 버튼 클릭 시 모달 닫기
            const messageOkBtn = document.getElementById('messageOkBtn');
            if (messageOkBtn) {
                messageOkBtn.onclick = function () {
                    messageModal.style.display = 'none';
                };
            }
        }
    });
</script>
<% } %>

<!-- 강사 등록 성공 처리를 위한 스크립트 -->
<% if (request.getAttribute("successMessage") != null) { %>
<script>
    document.addEventListener('DOMContentLoaded', function () {
        const messageModal = document.getElementById('messageModal');
        const messageTitle = document.getElementById('messageTitle');
        const messageText = document.getElementById('messageText');

        if (messageModal && messageTitle && messageText) {
            messageTitle.textContent = '강사 등록 완료';
            messageText.textContent = '${successMessage}';
            messageModal.style.display = 'flex';

            // 확인 버튼 클릭 시 모달 닫기
            const messageOkBtn = document.getElementById('messageOkBtn');
            if (messageOkBtn) {
                messageOkBtn.onclick = function () {
                    messageModal.style.display = 'none';
                };
            }
        }
    });
</script>
<% } %>

</body>

</html>
