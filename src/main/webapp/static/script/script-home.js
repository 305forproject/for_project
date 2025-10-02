// 모바일 메뉴 토글 스크립트
document.addEventListener('DOMContentLoaded', function() {
        var menuBtn = document.querySelector('.mobile-menu-toggle');
        var modal = document.getElementById('mobileMenuModal');
        var closeBtn = document.getElementById('closeMobileMenu');
        if(menuBtn && modal && closeBtn) {
            menuBtn.addEventListener('click', function() {
                modal.style.display = 'block';
            });
            closeBtn.addEventListener('click', function() {
                modal.style.display = 'none';
            });
            // 바깥 클릭 시 닫기
            modal.addEventListener('click', function(e) {
                if(e.target === modal) {
                    modal.style.display = 'none';
            }
        });
    }
});



document.addEventListener('DOMContentLoaded', function() {
    // ...모바일 메뉴 토글 코드...
    const loginBtn = document.getElementById("loginBtn");
    const joinBtn = document.getElementById("joinBtn");
    const logoutBtn = document.getElementById("logoutBtn");
    const loginModal = document.getElementById("loginModal");
    const joinModal = document.getElementById("joinModal");
    const messageModal = document.getElementById("messageModal");
    const closeBtns = document.querySelectorAll(".close");
    const loginForm = document.getElementById("loginForm");
    const joinForm = document.getElementById("joinForm");
    const messageOkBtn = document.getElementById("messageOkBtn");
    const messageTitle = document.getElementById("messageTitle");
    const messageText = document.getElementById("messageText");

    // 로그인 상태 확인 (초기 로드 시)
    let isLoggedIn = false;

    // 메시지 모달 표시 함수
    function showMessage(title, text) {
        messageTitle.textContent = title;
        messageText.textContent = text;
        messageModal.style.display = "flex";
    }

    // 로그인 상태에 따른 버튼 표시/숨김
    function updateButtonVisibility() {
        if (isLoggedIn) {
            loginBtn.style.display = "none";
            joinBtn.style.display = "none";
            logoutBtn.style.display = "inline-block";
        } else {
            loginBtn.style.display = "inline-block";
            joinBtn.style.display = "inline-block";
            logoutBtn.style.display = "none";
        }
    }

    // 초기 버튼 상태 설정
    updateButtonVisibility();

    // 로그인 버튼 → 로그인 모달 열기
    loginBtn.addEventListener("click", () => {
        loginModal.style.display = "flex";
    });

    // 회원가입 버튼 → 회원가입 모달 열기
    joinBtn.addEventListener("click", () => {
        joinModal.style.display = "flex";
    });

    // 로그인 모달 내 회원가입 버튼 → 회원가입 모달 열기
    const loginJoinBtn = loginModal.querySelector('.btn-join-modal');
    loginJoinBtn.addEventListener("click", (e) => {
        e.preventDefault(); // 폼 제출 방지
        loginModal.style.display = "none";
        joinModal.style.display = "flex";
    });

    // 모든 닫기 버튼에 대해 모달 닫기 이벤트 등록
    closeBtns.forEach(btn => {
        btn.addEventListener("click", () => {
            const modal = btn.closest(".modal");
            if (modal) modal.style.display = "none";
        });
    });

    // 메시지 확인 버튼
    messageOkBtn.addEventListener("click", () => {
        messageModal.style.display = "none";
    });



    // 로그인 처리
    loginForm.addEventListener("submit", (e) => {
        e.preventDefault();
        const username = document.getElementById("username").value;
        const password = document.getElementById("password").value;
        
        // 간단한 로그인 검증
        if (username && password) {
            isLoggedIn = true;
            updateButtonVisibility();
            loginModal.style.display = "none";
            showMessage("로그인 성공", "로그인에 성공했습니다");
        } else {
            showMessage("로그인 실패", "아이디와 비밀번호를 입력해주세요.");
        }
    });

    // 회원가입 처리
    joinForm.addEventListener("submit", (e) => {
        e.preventDefault();
        const username = document.getElementById("joinUsername").value;
        const password = document.getElementById("joinPassword").value;
        const passwordConfirm = document.getElementById("joinPasswordConfirm").value;
        
        // 간단한 회원가입 검증
        if (username && password && passwordConfirm) {
            if (password === passwordConfirm) {
                joinModal.style.display = "none";
                showMessage("회원가입 성공", "회원가입에 성공했습니다");
            } else {
                showMessage("회원가입 실패", "비밀번호가 일치하지 않습니다.");
            }
        } else {
            showMessage("회원가입 실패", "모든 필드를 입력해주세요.");
        }
    });

    // 로그아웃 처리
    logoutBtn.addEventListener("click", () => {
        isLoggedIn = false;
        updateButtonVisibility();
        showMessage("로그아웃", "로그아웃 되었습니다.");
    });
});