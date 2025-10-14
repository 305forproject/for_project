// 모바일 메뉴 토글 스크립트
document.addEventListener('DOMContentLoaded', function () {
    var menuBtn = document.querySelector('.mobile-menu-toggle');
    var modal = document.getElementById('mobileMenuModal');
    var closeBtn = document.getElementById('closeMobileMenu');
    if (menuBtn && modal && closeBtn) {
        menuBtn.addEventListener('click', function () {
            modal.style.display = 'block';
        });
        closeBtn.addEventListener('click', function () {
            modal.style.display = 'none';
        });
        // 바깥 클릭 시 닫기
        modal.addEventListener('click', function (e) {
            if (e.target === modal) {
                modal.style.display = 'none';
            }
        });
    }
    // ...모바일 메뉴 토글 코드...
    const loginBtn = document.getElementById("loginBtn");
    const joinBtn = document.getElementById("joinBtn");
    const logoutBtn = document.getElementById("logoutBtn");
    const mobileLoginBtn = document.getElementById("mobileLoginBtn");
    const mobileJoinBtn = document.getElementById("mobileJoinBtn");
    const mobileLogoutBtn = document.getElementById("mobileLogoutBtn");
    const loginModal = document.getElementById("loginModal");
    const joinModal = document.getElementById("joinModal");
    const messageModal = document.getElementById("messageModal");
    const mobileMenuModal = document.getElementById("mobileMenuModal");
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
            // 데스크톱 버튼
            loginBtn.style.display = "none";
            joinBtn.style.display = "none";
            logoutBtn.style.display = "inline-block";
            // 모바일 버튼
            mobileLoginBtn.style.display = "none";
            mobileJoinBtn.style.display = "none";
            mobileLogoutBtn.style.display = "block";
        } else {
            // 데스크톱 버튼
            loginBtn.style.display = "inline-block";
            joinBtn.style.display = "inline-block";
            logoutBtn.style.display = "none";
            // 모바일 버튼
            mobileLoginBtn.style.display = "block";
            mobileJoinBtn.style.display = "block";
            mobileLogoutBtn.style.display = "none";
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

    // 모바일 로그인 버튼 → 로그인 모달 열기
    mobileLoginBtn.addEventListener("click", () => {
        mobileMenuModal.style.display = "none";
        loginModal.style.display = "flex";
    });

    // 모바일 회원가입 버튼 → 회원가입 모달 열기
    mobileJoinBtn.addEventListener("click", () => {
        mobileMenuModal.style.display = "none";
        joinModal.style.display = "flex";
    });

    // 모바일 로그아웃 버튼
    mobileLogoutBtn.addEventListener("click", () => {
        isLoggedIn = false;
        updateButtonVisibility();
        mobileMenuModal.style.display = "none";
        showMessage("로그아웃", "로그아웃 되었습니다.");
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

    // 클래스 신청 함수 (전역 함수로 선언)
    window.applyClass = function(classId) {
        if (!isLoggedIn) {
            showMessage("로그인 필요", "클래스 신청을 위해 로그인이 필요합니다.");
            return;
        }
        
        // 클래스 신청 처리
        fetch('/api/classes/' + classId + '/apply', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                classId: classId,
                userId: getCurrentUserId() // 현재 로그인한 사용자 ID
            })
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                showMessage("신청 완료", "클래스 신청이 완료되었습니다.");
            } else {
                showMessage("신청 실패", data.message || "클래스 신청에 실패했습니다.");
            }
        })
        .catch(error => {
            console.error('Error:', error);
            showMessage("오류 발생", "클래스 신청 중 오류가 발생했습니다.");
        });
    };

    // 현재 로그인한 사용자 ID 가져오기 (실제 구현 시 세션에서 가져와야 함)
    function getCurrentUserId() {
        // 서버에서 렌더링 시 <meta name="current-user-id" content="실제사용자ID"> 태그에 삽입
        var meta = document.querySelector('meta[name="current-user-id"]');
        return meta ? meta.getAttribute('content') : null;
    }

    /* ===== slider for detail page (no auto-play) ===== */
(function initDetailSlider(){
    const slider = document.getElementById('slider');
    const slidesEl = document.getElementById('slides');
    const prevBtn = document.getElementById('prev');
    const nextBtn = document.getElementById('next');
    const dotsEl = document.getElementById('dots');
    if (!slider || !slidesEl) return;

    const originalSlides = Array.from(slidesEl.children);
    if (originalSlides.length === 0) return;

    // 무한 루프를 위한 클론 추가
    const firstClone = originalSlides[0].cloneNode(true);
    const lastClone = originalSlides[originalSlides.length - 1].cloneNode(true);
    slidesEl.appendChild(firstClone);
    slidesEl.insertBefore(lastClone, slidesEl.firstChild);
    const slides = Array.from(slidesEl.children);

    let index = 1; // 첫 번째 실제 슬라이드에서 시작
    let isDragging = false;
    let startX = 0;

    function slideWidth() { return slider.clientWidth; }
    function setTransition(on){ slidesEl.style.transition = on ? 'transform .5s ease' : 'none'; }
    function setTranslate(x){ slidesEl.style.transform = `translateX(${x}px)`; }

    function update(){
        setTransition(true);
        const x = -index * slideWidth();
        setTranslate(x);
        updateDots();
    }

    // 도트 생성 및 갱신
    function updateDots(){
        if (!dotsEl || dotsEl.children.length === 0) return;
        const n = originalSlides.length;
        let active = index - 1; // 클론을 고려한 실제 인덱스
        
        // 인덱스 범위 보정
        if (active < 0) active = n - 1;
        if (active >= n) active = 0;
        
        Array.from(dotsEl.children).forEach((dot,i)=>{
            dot.setAttribute('aria-current', i === active ? 'true' : 'false');
        });
    }

    if (dotsEl){
        originalSlides.forEach((s,i)=>{
            const dot = document.createElement('button');
            dot.className = 'dot';
            dot.setAttribute('aria-label', s.dataset.title || `슬라이드 ${i+1}`);
            dot.addEventListener('click', ()=>{ goTo(i+1); });
            dotsEl.appendChild(dot);
        });
    }

    function next(){ index++; update(); }
    function prev(){ index--; update(); }
    function goTo(i){ index = i; update(); }

    nextBtn.addEventListener('click', next);
    prevBtn.addEventListener('click', prev);

    slidesEl.addEventListener('transitionend', ()=>{
        // 마지막 클론(첫 번째 슬라이드의 클론)에 도달했을 때
        if (index === slides.length - 1){
            setTransition(false);
            index = 1; // 첫 번째 실제 슬라이드로 이동
            setTranslate(-index * slideWidth());
        }
        // 첫 번째 클론(마지막 슬라이드의 클론)에 도달했을 때
        if (index === 0){
            setTransition(false);
            index = originalSlides.length; // 마지막 실제 슬라이드로 이동
            setTranslate(-index * slideWidth());
        }
    });

    // 터치/드래그 이동 (모바일 대응)
    slider.addEventListener('touchstart', e=>{
        isDragging = true;
        startX = e.touches[0].clientX;
        setTransition(false);
    }, {passive: true});
    
    slider.addEventListener('touchmove', e=>{
        if(!isDragging) return;
        e.preventDefault();
        const dx = e.touches[0].clientX - startX;
        setTranslate(-index * slideWidth() + dx);
    }, {passive: false});
    
    slider.addEventListener('touchend', e=>{
        if(!isDragging) return;
        isDragging = false;
        const dx = e.changedTouches[0].clientX - startX;
        if (Math.abs(dx) < 10) {
            // 작은 움직임은 클릭으로 간주
            update();
            return;
        }
        if (dx < -50) next();
        else if (dx > 50) prev();
        else update();
    }, {passive: true});

    // 윈도우 리사이즈 처리
    window.addEventListener('resize', ()=>{
        setTransition(false);
        setTranslate(-index * slideWidth());
    });

    // 초기 위치 설정
    setTimeout(()=>{
        setTransition(false);
        setTranslate(-index * slideWidth());
        updateDots();
    }, 100);
})();

});




