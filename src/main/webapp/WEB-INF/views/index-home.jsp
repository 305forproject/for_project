<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/home.css">
    <script src="${pageContext.request.contextPath}/static/js/auth.js"></script>
    <script src="${pageContext.request.contextPath}/static/js/script-home.js"></script>


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
<div class="slider" id="slider" aria-roledescription="carousel">
    <div class="slides" id="slides">
        <section class="slide s1" data-title="슬라이드 1">
            <div class="content">
                <h2>슬라이드 1</h2>
                <p>첫번째 슬라이드입니다.</p>
            </div>
        </section>
        <section class="slide s2" data-title="슬라이드 2">
            <div class="content">
                <h2>슬라이드 2</h2>
                <p>두번째 슬라이드입니다.</p>
            </div>
        </section>
        <section class="slide s3" data-title="슬라이드 3">
            <div class="content">
                <h2>슬라이드 3</h2>
                <p>세번째 슬라이드입니다.</p>
            </div>
        </section>
        <section class="slide s4" data-title="슬라이드 4">
            <div class="content">
                <h2>슬라이드 4</h2>
                <p>네번째 슬라이드입니다.</p>
            </div>
        </section>
        <section class="slide s5" data-title="슬라이드 5">
            <div class="content">
                <h2>슬라이드 5</h2>
                <p>마지막 슬라이드입니다.</p>
            </div>
        </section>
    </div>

    <!--slide 좌우 조절-->
    <div class="controls">
        <button class="slide-btn prev" id="prev">◀</button>
        <button class="slide-btn next" id="next">▶</button>
    </div>
    <div class="dots" id="dots" role="tablist" aria-label="슬라이드 인디케이터"></div>
</div>


<!--  강의 카드 영역 -->
<main class="main-container">
    <div class="items-menu">
        <h2>추천 강의</h2>
    </div>
    <div class="items">
        <!-- 카드 동적 추가용 템플릿 -->
        <!-- 새로 등록된 강의가 맨 앞에 추가될 영역 -->
        <article class="card">
            <a href="#">
                <div class="img-card">
                    <img src="" alt="클래스 이미지">
                </div>
                <div class="card-body">
                    <p class="info1">카테고리</p>
                    <h3 class="class-name">클래스 이름</h3>
                    <p class="info2">클래스 상세 정보</p>
                </div>
            </a>
        </article>

        <!-- 카드 템플릿 예시 -->
        <template id="card-template">
            <article class="card">
                <a href="#">
                    <div class="img-card">
                        <img src="" alt="">
                    </div>
                    <div class="card-body">
                        <p class="info1"></p>
                        <h3 class="class-name"></h3>
                        <p class="info2"></p>
                    </div>
                </a>
            </article>
        </template>

        <article class="card">
            <a href="#">
                <div class="img-card">
                    <img src="" alt="클래스 이미지">
                </div>
                <div class="card-body">
                    <p class="info1">[고급] 웹디자인</p>
                    <h3 class="class-name">Figma로 웹페이 만들기</h3>
                    <p class="info2">실제 디자인을 웹페이지로 구현해보세요</p>
                </div>
            </a>
        </article>
        <article class="card">
            <a href="#">
                <div class="img-card">
                    <img src="" alt="클래스 이미지">
                </div>
                <div class="card-body">
                    <p class="info1">[중급] 웹디자인</p>
                    <h3 class="class-name">Figma로 디자인 시작하기</h3>
                    <p class="info2">프로토타이핑부터 협업까지 한 번에 익히기</p>
                </div>
            </a>
        </article>
        <article class="card">
            <a href="#">
                <div class="img-card">
                    <img src="" alt="클래스 이미지">
                </div>
                <div class="card-body">
                    <p class="info1">[초급] 그림 기초</p>
                    <h3 class="class-name">색연필로 배우는 정물화</h3>
                    <p class="info2">생동감 있게 표현하는 방법을 배워보세요</p>
                </div>
            </a>
        </article>
    </div>


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
        <div class="mobile-menu-header">
            <h2 id="messageTitle">알림</h2>
            <span class="close">&times;</span>
        </div>
        <p id="messageText">메시지가 여기에 표시됩니다.</p>
        <button id="messageOkBtn" class="btn btn-check">확인</button>
    </div>
</div
</body>

</html>
