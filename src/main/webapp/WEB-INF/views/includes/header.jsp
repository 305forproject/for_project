<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- 
    공통 헤더 파일
    모든 페이지에서 include하여 사용
-->

<!-- Google Fonts: Noto Sans KR -->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;600;700&display=swap" rel="stylesheet">

<!-- 공통 CSS -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/common.css">

<!-- Header 영역 -->
<header class="header">
    <div class="header-container">
        <!-- 로고 영역 -->
        <a href="${pageContext.request.contextPath}/main" class="logo">
            <div class="logo-img">
                <img src="${pageContext.request.contextPath}/static/img/mainlogo.png" alt="원데이 클래스 로고">
            </div>
            <div class="logo-text">원데이클래스</div>
        </a>

        <!-- 마이페이지 아이콘 영역 (데스크톱) -->
        <div class="mypage-icons">
            <!-- 강사 마이페이지 -->
            <a href="${pageContext.request.contextPath}/teacher-page" class="mypage-icon" title="강사 페이지">
                <img src="${pageContext.request.contextPath}/static/img/mypage-icon-lecturer.png" 
                     alt="강사 아이콘">
            </a>
            
            <!-- 학생 마이페이지 -->
            <a href="${pageContext.request.contextPath}/users/mypage" class="mypage-icon" title="마이페이지">
                <img src="${pageContext.request.contextPath}/static/img/mypage-icon-student.png" 
                     alt="학생 아이콘">
            </a>
        </div>

        <!-- 모바일 메뉴 토글 버튼 -->
        <button class="mobile-menu-toggle" aria-label="메뉴 열기" type="button" onclick="toggleMobileMenu()">
            <span></span>
            <span></span>
            <span></span>
        </button>
    </div>
</header>

<!-- 로그인/회원가입 버튼 영역 (데스크톱) -->
<div class="login-container">
    <button id="loginBtn" class="btn btn-login-main">로그인</button>
    <button id="joinBtn" class="btn btn-join-main">회원가입</button>
    <button id="logoutBtn" class="btn btn-logout" style="display: none;">로그아웃</button>
</div>

<!-- 모바일 메뉴 모달 -->
<div id="mobileMenuModal" class="mobile-menu-modal" onclick="closeMobileMenu(event)">
    <div class="mobile-menu-modal-content" onclick="event.stopPropagation()">
        <div class="mobile-menu-header">
            <h2>메뉴</h2>
            <button class="close" onclick="closeMobileMenu()">&times;</button>
        </div>
        
        <!-- 모바일 로그인/회원가입 버튼 -->
        <div class="mobile-auth-buttons">
            <button id="mobileLoginBtn" class="mobile-auth-btn">로그인</button>
            <button id="mobileJoinBtn" class="mobile-auth-btn">회원가입</button>
            <button id="mobileLogoutBtn" class="mobile-auth-btn" style="display: none;">로그아웃</button>
        </div>
        
        <!-- 메뉴 링크 -->
        <ul>
            <li><a href="${pageContext.request.contextPath}/teacher-page">강사 마이페이지</a></li>
            <li><a href="${pageContext.request.contextPath}/users/mypage">학생 마이페이지</a></li>
        </ul>
    </div>
</div>

<!-- 로그인 모달 -->
<div id="loginModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h2>로그인</h2>
            <span class="close" onclick="closeLoginModal()">&times;</span>
        </div>
        <c:if test="${not empty error}">
            <p style="color: red; margin-bottom: 16px;">${error}</p>
        </c:if>
        <form id="loginForm" method="post" action="${pageContext.request.contextPath}/login">
            <input type="text" id="username" name="loginId" placeholder="아이디" required>
            <input type="password" id="password" name="password" placeholder="비밀번호" required>
            <button type="submit" class="btn-login-modal">로그인</button>
            <button type="button" class="btn-join-modal" onclick="openJoinModal()">회원가입</button>
        </form>
    </div>
</div>

<!-- 회원가입 모달 -->
<div id="joinModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h2>회원가입</h2>
            <span class="close" onclick="closeJoinModal()">&times;</span>
        </div>
        <c:if test="${not empty signupError}">
            <p style="color: red; margin-bottom: 16px;">${signupError}</p>
        </c:if>
        <form id="joinForm" method="post" action="${pageContext.request.contextPath}/signup">
            <input type="text" name="name" placeholder="이름" required>
            <input type="text" name="loginId" placeholder="아이디" required>
            <input type="password" name="password" placeholder="비밀번호" required>
            <small style="color: #777;">영문, 숫자 포함 8~20자를 입력해 주세요</small>
            <input type="password" name="passwordConfirm" placeholder="비밀번호 확인" required>
            <button type="submit" class="btn-login-modal">회원가입</button>
        </form>
    </div>
</div>

<!-- 메시지 모달 (성공/실패 알림용) -->
<div id="messageModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h2 id="messageTitle">알림</h2>
            <span class="close" onclick="closeMessageModal()">&times;</span>
        </div>
        <p id="messageText" style="margin-bottom: 20px;">메시지가 여기에 표시됩니다.</p>
        <button class="btn-login-modal" onclick="closeMessageModal()">확인</button>
    </div>
</div>

<!-- 강사 계좌번호 등록 모달 -->
<div id="teacherAccountModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h2>강사 계좌번호 등록</h2>
            <span class="close" onclick="closeTeacherAccountModal()">&times;</span>
        </div>
        <form method="post" action="${pageContext.request.contextPath}/teacher-page">
            <input type="text" name="accountNumber" 
                   placeholder="계좌번호를 입력해주세요 (예: 국민은행 123-456-789012)" 
                   required maxlength="50">
            <small style="color: #777; font-size: 12px; display: block; margin-bottom: 16px;">
                은행명과 계좌번호를 정확히 입력해주세요
            </small>
            <button type="submit" class="btn-login-modal">등록</button>
            <button type="button" class="btn-join-modal" onclick="closeTeacherAccountModal()">취소</button>
        </form>
    </div>
</div>

<script>
    const contextPath = '${pageContext.request.contextPath}';
    
    // 모바일 메뉴 토글
    function toggleMobileMenu() {
        const modal = document.getElementById('mobileMenuModal');
        modal.style.display = modal.style.display === 'block' ? 'none' : 'block';
    }
    
    function closeMobileMenu(event) {
        const modal = document.getElementById('mobileMenuModal');
        if (!event || event.target === modal) {
            modal.style.display = 'none';
        }
    }
    
    // 로그인 모달
    function openLoginModal() {
        document.getElementById('loginModal').style.display = 'flex';
    }
    
    function closeLoginModal() {
        document.getElementById('loginModal').style.display = 'none';
    }
    
    // 회원가입 모달
    function openJoinModal() {
        closeLoginModal();
        document.getElementById('joinModal').style.display = 'flex';
    }
    
    function closeJoinModal() {
        document.getElementById('joinModal').style.display = 'none';
    }
    
    // 메시지 모달
    function closeMessageModal() {
        document.getElementById('messageModal').style.display = 'none';
    }
    
    // 강사 계좌 모달
    function closeTeacherAccountModal() {
        document.getElementById('teacherAccountModal').style.display = 'none';
    }
    
    // 로그인 버튼 클릭 이벤트
    document.addEventListener('DOMContentLoaded', function() {
        const loginBtn = document.getElementById('loginBtn');
        const joinBtn = document.getElementById('joinBtn');
        const mobileLoginBtn = document.getElementById('mobileLoginBtn');
        const mobileJoinBtn = document.getElementById('mobileJoinBtn');
        
        if (loginBtn) loginBtn.addEventListener('click', openLoginModal);
        if (joinBtn) joinBtn.addEventListener('click', openJoinModal);
        if (mobileLoginBtn) mobileLoginBtn.addEventListener('click', openLoginModal);
        if (mobileJoinBtn) mobileJoinBtn.addEventListener('click', openJoinModal);
        
        // 모달 외부 클릭 시 닫기
        window.onclick = function(event) {
            const loginModal = document.getElementById('loginModal');
            const joinModal = document.getElementById('joinModal');
            const messageModal = document.getElementById('messageModal');
            const teacherModal = document.getElementById('teacherAccountModal');
            
            if (event.target === loginModal) closeLoginModal();
            if (event.target === joinModal) closeJoinModal();
            if (event.target === messageModal) closeMessageModal();
            if (event.target === teacherModal) closeTeacherAccountModal();
        };
    });
</script>

<!-- 에러 처리 스크립트 -->
<c:if test="${not empty error}">
<script>
    document.addEventListener('DOMContentLoaded', function() {
        openLoginModal();
    });
</script>
</c:if>

<c:if test="${not empty signupError}">
<script>
    document.addEventListener('DOMContentLoaded', function() {
        openJoinModal();
    });
</script>
</c:if>

<c:if test="${not empty signupSuccess}">
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const messageModal = document.getElementById('messageModal');
        const messageTitle = document.getElementById('messageTitle');
        const messageText = document.getElementById('messageText');
        messageTitle.textContent = '회원가입 완료';
        messageText.textContent = '${signupSuccess}';
        messageModal.style.display = 'flex';
    });
</script>
</c:if>

<c:if test="${not empty successMessage}">
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const messageModal = document.getElementById('messageModal');
        const messageTitle = document.getElementById('messageTitle');
        const messageText = document.getElementById('messageText');
        messageTitle.textContent = '완료';
        messageText.textContent = '${successMessage}';
        messageModal.style.display = 'flex';
    });
</script>
</c:if>
