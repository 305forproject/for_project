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
});

// 슬라이더 스크립트
(function(){
const slidesEl = document.getElementById('slides');
const slides = Array.from(slidesEl.children);
const dotsEl = document.getElementById('dots');
const prevBtn = document.getElementById('prev');
const nextBtn = document.getElementById('next');
const slider = document.getElementById('slider');

let index = 1; // clone 고려 시작 index
const intervalMs = 3500;
let timer = null;

// 무한 루프용 클론 추가
const firstClone = slides[0].cloneNode(true);
const lastClone = slides[slides.length-1].cloneNode(true);
slidesEl.appendChild(firstClone);
slidesEl.insertBefore(lastClone, slidesEl.firstChild);
const newSlides = Array.from(slidesEl.children);

slidesEl.style.transform = `translateX(${-index*100}%)`;

// dots 생성 (실제 슬라이드 기준)
slides.forEach((s,i)=>{
const btn = document.createElement('button');
btn.className='dot';
btn.addEventListener('click',()=>goTo(i+1));
dotsEl.appendChild(btn);
});
const dots = Array.from(dotsEl.children);

function update(){
slidesEl.style.transition = 'transform .6s ease';
slidesEl.style.transform = `translateX(${-index*100}%)`;
// dots 표시 업데이트 (clone 제외)
let realIndex = index-1;
if(realIndex < 0) realIndex = slides.length-1;
if(realIndex >= slides.length) realIndex = 0;
dots.forEach((d,i)=>d.setAttribute('aria-current', i===realIndex));
}


function next(){ index++; update(); }
function prev(){ index--; update(); }
function goTo(i){ index=i; update(); }


nextBtn.addEventListener('click', ()=>{ next(); resetTimer(); });
prevBtn.addEventListener('click', ()=>{ prev(); resetTimer(); });


slidesEl.addEventListener('transitionend', ()=>{
if(newSlides[index].isSameNode(firstClone)){
slidesEl.style.transition='none';
index=1;
slidesEl.style.transform=`translateX(${-index*100}%)`;
}
if(newSlides[index].isSameNode(lastClone)){
slidesEl.style.transition='none';
index=newSlides.length-2;
slidesEl.style.transform=`translateX(${-index*100}%)`;
}
// dots 업데이트 재호출
let realIndex = index-1;
if(realIndex < 0) realIndex = slides.length-1;
if(realIndex >= slides.length) realIndex = 0;
dots.forEach((d,i)=>d.setAttribute('aria-current', i===realIndex));
});


function startTimer(){ if(timer) clearInterval(timer); timer=setInterval(next,intervalMs); }
function stopTimer(){ if(timer){ clearInterval(timer); timer=null; } }
function resetTimer(){ stopTimer(); startTimer(); }


slider.addEventListener('mouseenter', stopTimer);
slider.addEventListener('mouseleave', startTimer);


update();
startTimer();
})();


