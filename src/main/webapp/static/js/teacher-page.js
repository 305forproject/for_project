/**
 * 강사 계좌번호 등록 모달 관련 기능
 */

document.addEventListener('DOMContentLoaded', function () {
    initTeacherAccountModal();
});

/**
 * 강사 계좌번호 모달 초기화
 */
function initTeacherAccountModal() {
    setupTeacherIconClickEvent();
    setupTeacherAccountModalEvents();
}

/**
 * 강사 아이콘 클릭 이벤트 설정
 */
function setupTeacherIconClickEvent() {
    const teacherIconBtn = document.querySelector('.mypage-icon-lecturer-img');

    if (teacherIconBtn) {
        teacherIconBtn.addEventListener('click', function () {
            // 로그인 상태 확인
            if (!isLoggedIn()) {
                // 로그인하지 않은 경우 로그인 모달 표시
                document.getElementById('loginModal').style.display = 'flex';
                return;
            }

            // 강사 여부 확인
            if (!isTeacher()) {
                // 강사가 아닌 경우 계좌번호 등록 모달 표시
                document.getElementById('teacherAccountModal').style.display = 'flex';
            } else {
                // 강사인 경우 강사 마이페이지로 이동
                window.location.href = contextPath + '/teacher-page';
            }
        });
    }
}

/**
 * 강사 계좌번호 모달 이벤트 설정
 */
function setupTeacherAccountModalEvents() {
    const modal = document.getElementById('teacherAccountModal');
    if (!modal) return;

    const closeBtn = modal.querySelector('.close');
    const form = document.getElementById('teacherAccountForm');

    // X 버튼 클릭 시 모달 닫기
    if (closeBtn) {
        closeBtn.addEventListener('click', function () {
            closeTeacherAccountModal();
        });
    }

    // 모달 외부 클릭 시 닫기
    window.addEventListener('click', function (event) {
        if (event.target === modal) {
            closeTeacherAccountModal();
        }
    });

    // 폼 제출 처리
    if (form) {
        form.addEventListener('submit', function (e) {
            e.preventDefault();
            submitTeacherAccount();
        });
    }
}

/**
 * 강사 계좌번호 모달 닫기
 */
function closeTeacherAccountModal() {
    const modal = document.getElementById('teacherAccountModal');
    if (modal) {
        modal.style.display = 'none';
        // 폼 초기화
        const form = document.getElementById('teacherAccountForm');
        if (form) {
            form.reset();
        }
    }
}

/**
 * 강사 계좌번호 등록 제출
 */
function submitTeacherAccount() {
    const accountNumber = document.getElementById('accountNumber').value.trim();

    if (!accountNumber) {
        alert('계좌번호를 입력해주세요.');
        return;
    }

    // 간단한 계좌번호 유효성 검사
    if (accountNumber.length < 10) {
        alert('올바른 계좌번호를 입력해주세요.');
        return;
    }

    // 서버로 전송
    const form = document.getElementById('teacherAccountForm');
    if (form) {
        form.submit();
    }
}
