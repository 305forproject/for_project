/**
 * 회원가입 기능을 담당하는 JavaScript 파일
 *
 * 주요 기능:
 * - 회원가입 모달 이벤트 처리
 * - 회원가입 버튼 클릭 이벤트
 */

document.addEventListener('DOMContentLoaded', function () {
    initSignupSystem();
});

/**
 * 회원가입 시스템 초기화
 */
function initSignupSystem() {
    setupSignupEventListeners();
}

/**
 * 회원가입 관련 이벤트 리스너 설정
 */
function setupSignupEventListeners() {
    // 회원가입 버튼 이벤트 리스너 추가
    const joinBtn = document.getElementById('joinBtn');
    const mobileJoinBtn = document.getElementById('mobileJoinBtn');

    if (joinBtn) {
        joinBtn.addEventListener('click', function () {
            document.getElementById('joinModal').style.display = 'flex';
        });
    }

    if (mobileJoinBtn) {
        mobileJoinBtn.addEventListener('click', function () {
            document.getElementById('mobileMenuModal').style.display = 'none';
            document.getElementById('joinModal').style.display = 'flex';
        });
    }
}
