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
    checkLoginError(); // 로그인 에러 확인 추가
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
    const userId = getCookie('userId');
    const isStudentCookie = getCookie('isStudent');

    // 안전한 boolean 변환 - falsy 값들을 모두 false로 처리
    const isStudent = !!(isStudentCookie && isStudentCookie !== 'false' && isStudentCookie !== 'null');

    // UI 요소 가져오기
    const loginBtn = document.getElementById('loginBtn');
    const joinBtn = document.getElementById('joinBtn');
    const logoutBtn = document.getElementById('logoutBtn');
    const mobileLoginBtn = document.getElementById('mobileLoginBtn');
    const mobileJoinBtn = document.getElementById('mobileJoinBtn');
    const mobileLogoutBtn = document.getElementById('mobileLogoutBtn');

    if (userId && userId !== 'null' && userId !== '' && userId !== 'undefined') {
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

/**
 * 로그인 에러 확인
 */
function checkLoginError() {
    const loginError = getCookie('loginError');

    if (loginError && loginError === 'true') {
        // 로그인 에러가 있는 경우, 로그인 모달을 표시
        document.getElementById('loginModal').style.display = 'flex';

        // 에러 메시지 표시 (추가적인 에러 처리 로직 가능)
        const errorMessage = document.getElementById('loginErrorMessage');
        if (errorMessage) {
            errorMessage.style.display = 'block';
            errorMessage.innerText = '로그인에 실패하였습니다. 아이디와 비밀번호를 확인하세요.';
        }
    }
}

/**
 * 쿠키 값 가져오기 함수
 * @param {string} name - 쿠키 이름
 * @returns {string|null} 쿠키 값 또는 null
 */
function getCookie(name) {
    const value = "; " + document.cookie;
    const parts = value.split("; " + name + "=");
    if (parts.length === 2) {
        const cookieValue = parts.pop().split(";").shift();
        return decodeURIComponent(cookieValue);
    }
    return null;
}
