<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/detailPage.css">
    <script src="${pageContext.request.contextPath}/static/js/script-detailPage.js"></script>

    <title>Detail Page</title>

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
        <div class="mypage-icons">
            <div class="icons">
                <!-- 강사 아이콘 -->
                <button type="button" class="mypage-icon">
                    <img src="${pageContext.request.contextPath}/static/img/mypage-icon-lecturer.png"
                         alt="icon-teacher">
                </button>

                <!-- 학생 아이콘 -->
                <button type="button" class="mypage-icon">
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


<!--main-->
<!-- 클래스 썸네일 및 기본 정보 -->
<main>
    <section class="class-summary">
        <div class="class-img">
            <!-- Slider copied from home for class-img -->
            <div class="slider" id="slider" aria-roledescription="carousel">
                <div class="slides" id="slides">

                    <!-- JS에서 동적으로 이미지 삽입 -->

                    <section class="slide s1" data-title="이미지 1">
                        <div class="content">
                            <h2>요리 클래스</h2>
                            <p>맛있는 요리를 배워보세요! 전문 셰프와 함께하는 특별한 시간입니다.</p>
                        </div>
                    </section>
                    <section class="slide s2" data-title="이미지 2">
                        <div class="content">
                            <h2>아트 클래스</h2>
                            <p>창의적인 예술 작품을 만들어보세요. 모든 재료가 제공됩니다.</p>
                        </div>
                    </section>
                    <section class="slide s3" data-title="이미지 3">
                        <div class="content">
                            <h2>음악 클래스</h2>
                            <p>악기 연주의 기초부터 실전까지 배울 수 있는 기회입니다.</p>
                        </div>
                    </section>
                </div>

                <div class="controls">
                    <button class="slide-btn prev" id="prev">◀</button>
                    <button class="slide-btn next" id="next">▶</button>
                </div>
                <div class="dots" id="dots" role="tablist" aria-label="슬라이드 인디케이터"></div>
            </div>
        </div>

        <div class="class-side">
            <h2 class="class-title" id="className">클래스이름</h2>
            <p class="class-infomation" id="classDescription">클래스 간단 소개글</p>
            <p class="class-price" id="classPrice">10,000원</p>
            <button class="apply-btn">클래스 신청</button>
        </div>
    </section>

    <!--  클래스 상세 정보 -->
    <section class="class-info">
        <h2 id="classDetailTitle">클래스이름</h2>
        <ul class="info-box">
            <li>
                <span id="classType">클래스 유형</span>
            </li>
            <li>
                <img src="${pageContext.request.contextPath}/static/img/time-icon.png" alt="시간">
                <span id="classDuration">60분</span>
            </li>
            <li>
                <img src="${pageContext.request.contextPath}/static/img/location-icon.png" alt="주소">
                <span id="classLocation">주소</span>
            </li>
            <li>
                <img src="${pageContext.request.contextPath}/static/img/level-icon.png" alt="클래스 등급">
                <span id="classLevel">클래스 등급</span>
            </li>
            <li>
                <img src="${pageContext.request.contextPath}/static/img/people-icon.png" alt="수용인원">
                <span id="classCapacity">수용인원</span>
            </li>
        </ul>
    </section>

    <!--  클래스 소개 / 운영시간 / 예약 / 위치 바로가기-->
    <section class="class-tabs">
        <ul>
            <a href="#class-intro">
                <li>클래스 소개</li>
            </a>
            <a href="#class-hours">
                <li>운영시간</li>
            </a>
            <a href="#class-reservation">
                <li>예약</li>
            </a>
            <a href="#class-location">
                <li>위치</li>
            </a>
        </ul>
    </section>
</main>

<div class="reservation-calendar">
    달력
</div>

<div class="map-address">
    지도
</div>

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
        <div class="modal-content-header">
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
        <div class="modal-content-header">
            <h2>회원가입</h2>
            <span class="close">&times;</span>
        </div>
        <form id="joinForm" method="post" action="${pageContext.request.contextPath}/signup">
            <input type="text" id="joinName" name="name" placeholder="이름" required><br>
            <input type="text" id="joinUsername" name="loginId" placeholder="아이디" required><br>
            <input type="password" id="joinPassword" name="password" placeholder="비밀번호" required><br>
            영문, 숫자 포함 8~20자를 입력해 주세요<br>
            <input type="password" id="joinPasswordConfirm" name="passwordConfirm" placeholder="비밀번호 확인" required><br>
            영문, 숫자 포함 8~20자를 입력해 주세요<br>
            <button type="submit" class="btn btn-join-modal">회원가입</button>
        </form>
    </div>
</div>

<!-- 성공/실패 메시지 모달 -->
<div id="messageModal" class="modal">
    <div class="modal-content">
        <div class="modal-content-header">
            <h2 id="messageTitle">알림</h2>
            <span class="close">&times;</span>
        </div>
        <p id="messageText">메시지가 여기에 표시됩니다.</p>
        <button id="messageOkBtn" class="btn btn-check">확인</button>
    </div>
</div>

</body>

</html>