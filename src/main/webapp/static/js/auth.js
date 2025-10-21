/**
 * 로그인/로그아웃 인증 관련 기능을 담당하는 JavaScript 파일
 *
 * 주요 기능:
 * - 로그인 상태 확인 및 UI 업데이트
 * - 로그인/로그아웃 버튼 이벤트 처리
 * - 쿠키 기반 인증 상태 관리
 */

document.addEventListener('DOMContentLoaded', function () {
    initAuthSystem();
});

/**
 * 인증 시스템 초기화
 */
function initAuthSystem() {
    checkLoginStatus();
    setupAuthEventListeners();
}

/**
 * 로그인/로그아웃 관련 이벤트 리스너 설정
 */
function setupAuthEventListeners() {
    // 로그인 버튼 이벤트 리스너
    const loginBtn = document.getElementById('loginBtn');
    const mobileLoginBtn = document.getElementById('mobileLoginBtn');

    if (loginBtn) {
        loginBtn.addEventListener('click', function () {
            document.getElementById('loginModal').style.display = 'flex';
        });
    }

    if (mobileLoginBtn) {
        mobileLoginBtn.addEventListener('click', function () {
            document.getElementById('mobileMenuModal').style.display = 'none';
            document.getElementById('loginModal').style.display = 'flex';
        });
    }

    // 학생 아이콘 이벤트 리스너
    const studentIconBtn = document.querySelector('.mypage-icon-student-img');
    if (studentIconBtn) {
        studentIconBtn.addEventListener('click', function () {
            if (!isLoggedIn()) {
                document.getElementById('loginModal').style.display = 'flex';
                return;
            }
            window.location.href = contextPath + '/users/mypage';
        });
    }

    // 로그아웃 버튼 이벤트 리스너
    const logoutBtn = document.getElementById('logoutBtn');
    const mobileLogoutBtn = document.getElementById('mobileLogoutBtn');

    if (logoutBtn) {
        logoutBtn.addEventListener('click', function () {
            window.location.href = 'logout';
        });
    }

    if (mobileLogoutBtn) {
        mobileLogoutBtn.addEventListener('click', function () {
            document.getElementById('mobileMenuModal').style.display = 'none';
            window.location.href = 'logout';
        });
    }
}

/**
 * 로그인 상태 확인 및 UI 업데이트
 */
function checkLoginStatus() {
    // UI 요소 가져오기
    const loginBtn = document.getElementById('loginBtn');
    const joinBtn = document.getElementById('joinBtn');
    const logoutBtn = document.getElementById('logoutBtn');
    const mobileLoginBtn = document.getElementById('mobileLoginBtn');
    const mobileJoinBtn = document.getElementById('mobileJoinBtn');
    const mobileLogoutBtn = document.getElementById('mobileLogoutBtn');

    if (isLoggedIn()) {
        // 로그인된 상태: 로그인/회원가입 버튼 숨기고 로그아웃 버튼 표시
        if (loginBtn) loginBtn.style.display = 'none';
        if (joinBtn) joinBtn.style.display = 'none';
        if (logoutBtn) logoutBtn.style.display = 'block';

        // 모바일 버튼도 동일하게 처리
        if (mobileLoginBtn) mobileLoginBtn.style.display = 'none';
        if (mobileJoinBtn) mobileJoinBtn.style.display = 'none';
        if (mobileLogoutBtn) mobileLogoutBtn.style.display = 'block';
    } else {
        // 로그인되지 않은 상태: 로그인/회원가입 버튼 표시하고 로그아웃 버튼 숨김
        if (loginBtn) loginBtn.style.display = 'block';
        if (joinBtn) joinBtn.style.display = 'block';
        if (logoutBtn) logoutBtn.style.display = 'none';

        // 모바일 버튼도 동일하게 처리
        if (mobileLoginBtn) mobileLoginBtn.style.display = 'block';
        if (mobileJoinBtn) mobileJoinBtn.style.display = 'block';
        if (mobileLogoutBtn) mobileLogoutBtn.style.display = 'none';
    }
}
