// 모바일 메뉴 토글 스크립트
document.addEventListener('DOMContentLoaded', function () {
    const menuBtn = document.querySelector('.mobile-menu-toggle');
    const modal = document.getElementById('mobileMenuModal');
    const closeBtn = document.getElementById('closeMobileMenu');
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
        console.log("이벤트가 인식되었습니다.");
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


// slide
// script-home.js - 무한 루프(carousel) 구현 + dot(인디케이터) 업데이트 + 터치 스와이프 포함
// 주요 설계 포인트(주석 참고):
// - 무한 루프를 위해 앞뒤에 클론을 추가하고 transitionend에서 순간 점프 보정
// - 터치 이동과 즉시 반영(픽셀 단위)을 위해 transform 계산을 px로 통일
// - transitionend에서 안전 검사(가드)를 두어 예외 발생으로 전체 로직이 멈추는 것을 방지
// - 자동재생은 setInterval로 제어하고 사용자 상호작용시 일시정지
document.addEventListener('DOMContentLoaded', function () {
    (function () {
        const slidesEl = document.getElementById('slides');
        const originalSlides = Array.from(slidesEl.children);
        const dotsEl = document.getElementById('dots');
        const prevBtn = document.getElementById('prev');
        const nextBtn = document.getElementById('next');
        const slider = document.getElementById('slider');

        let index = 1; // clone 고려한 시작 인덱스
        const intervalMs = 3500;
        let timer = null;
        let isDragging = false;
        let startX = 0;
        let currentTranslate = 0;

        // 무한 루프를 위한 "클론 슬라이드" 추가
        // 이유: 마지막에서 다음으로 넘어갈 때 시각적으로 연속되게 보이도록
        // 첫/마지막 요소를 복제해 앞뒤에 붙인 후, transition 종료 시 실제 인덱스로 점프시킴
        const firstClone = originalSlides[0].cloneNode(true);
        const lastClone = originalSlides[originalSlides.length - 1].cloneNode(true);
        slidesEl.appendChild(firstClone);
        slidesEl.insertBefore(lastClone, slidesEl.firstChild);
        const slides = Array.from(slidesEl.children);

        // 초기 위치 설정
        // 픽셀(px) 단위로 계산하는 이유: 터치 이벤트에서 얻은 이동량(dx)이 px 단위이므로
        // 퍼센트(%)와 혼용하면 계산 불일치로 인해 슬라이드가 빈 영역으로 이동할 수 있음.
        // 따라서 모든 transform 계산은 slider.clientWidth를 기준으로 px로 통일합니다.
        slidesEl.style.transform = `translateX(${-index * slider.clientWidth}px)`;

        // dots 생성 (원본 슬라이드 수 기준)
        // 도트는 원본 슬라이드 수와 매칭되며, aria-label에 data-title을 사용해 접근성 보완.
        originalSlides.forEach((s, i) => {
            const btn = document.createElement('button');
            btn.className = 'dot';
            btn.setAttribute('aria-label', s.dataset.title || `슬라이드 ${i + 1}`);
            btn.addEventListener('click', () => {
                goTo(i + 1);
                resetTimer();
            });
            dotsEl.appendChild(btn);
        });
        const dots = Array.from(dotsEl.children);

        // transition 토글 함수
        // 애니메이션이 필요 없는 순간(예: 터치 이동 중이거나 클론 보정 시)에는 transition을 끄고
        // 시각적으로 이동만 즉시 반영합니다.
        function setTransition(on) {
            slidesEl.style.transition = on ? 'transform .5s ease' : 'none';
        }

        //dots 표시를 갱신
        function updateDotsByIndex(i) {
            // i 는 clone 포함 인덱스. 실제 인덱스(0..n-1)는 i-1
            let realIndex = i - 1;
            if (realIndex < 0) realIndex = originalSlides.length - 1;
            if (realIndex >= originalSlides.length) realIndex = 0;
            dots.forEach((d, idx) => d.setAttribute('aria-current', idx === realIndex));
        }

        // 슬라이드 전환 핵심 (px 단위 사용)
        // update는 index를 기준으로 transform을 설정하고 도트 상태를 갱신합니다.
        // setTransition(true)를 호출해 CSS 애니메이션이 실행되도록 합니다.
        function update() {
            setTransition(true);
            slidesEl.style.transform = `translateX(${-index * slider.clientWidth}px)`;
            updateDotsByIndex(index);
        }

        function next() {
            index++;
            update();
        }

        function prev() {
            index--;
            update();
        }

        function goTo(i) {
            index = i;
            update();
        }

        nextBtn.addEventListener('click', () => {
            next();
            resetTimer();
        });
        prevBtn.addEventListener('click', () => {
            prev();
            resetTimer();
        });

        // transitionend 처리: 클론 보정
        // 목적: 클론으로 이동한 경우(시각적 continuity를 위해) 애니메이션이 끝난 뒤
        // 즉시(transition 없이) 실제 원본 인덱스로 점프해 사용자가 무한 루프처럼 느끼게 함.
        // 또한 slides[index]가 undefined인 경우를 대비해 안전 검사(가드)를 넣어
        // 예외 발생으로 전체 스크립트가 중단되는 것을 방지합니다.
        slidesEl.addEventListener('transitionend', () => {
            // 안전 검사: slides[index]가 존재하는지 확인
            if (!slides[index]) {
                // 인덱스 범위를 벗어난 경우 안전하게 보정
                setTransition(false);
                if (index <= 0) index = 1;
                if (index >= slides.length) index = slides.length - 2;
                slidesEl.style.transform = `translateX(${-index * slider.clientWidth}px)`;
                updateDotsByIndex(index);
                return;
            }

            if (slides[index].isSameNode(firstClone)) {
                // firstClone에 도달했을 때는 실제 첫 번째 원본으로 점프
                setTransition(false);
                index = 1;
                slidesEl.style.transform = `translateX(${-index * slider.clientWidth}px)`;
            }
            if (slides[index].isSameNode(lastClone)) {
                // lastClone에 도달했을 때는 실제 마지막 원본으로 점프
                setTransition(false);
                index = slides.length - 2;
                slidesEl.style.transform = `translateX(${-index * slider.clientWidth}px)`;
            }
            // 항상 dots 업데이트
            updateDotsByIndex(index);
        });

        // autoplay 타이머 관련 함수
        // startTimer: 기존 타이머가 있으면 지우고 새 타이머 시작
        // stopTimer: 타이머 정지
        // resetTimer: 사용자 인터랙션 후 자동재생을 재시작할 때 사용
        function startTimer() {
            if (timer) clearInterval(timer);
            timer = setInterval(() => {
                next();
            }, intervalMs);
        }

        function stopTimer() {
            if (timer) {
                clearInterval(timer);
                timer = null;
            }
        }

        function resetTimer() {
            stopTimer();
            startTimer();
        }

        // pause on hover/focus->마우스를 올리면 멈추고, 내리면 다시 시작
        slider.addEventListener('mouseenter', stopTimer);
        slider.addEventListener('mouseleave', startTimer);
        slider.addEventListener('focusin', stopTimer);
        slider.addEventListener('focusout', startTimer);

        // 터치 스와이프 (모바일)
        // passive:true를 사용해 기본 스크롤 성능을 유지하도록 했습니다.
        // touchmove에서 preventDefault를 사용하려면 passive 옵션을 false로 바꿔야 합니다.
        slidesEl.addEventListener('touchstart', touchStart, {passive: true});
        slidesEl.addEventListener('touchmove', touchMove, {passive: true});
        slidesEl.addEventListener('touchend', touchEnd);

        function touchStart(e) {
            // 터치 시작 시 자동재생 중지하고 드래그 상태로 전환
            stopTimer();
            isDragging = true;
            startX = e.touches[0].clientX;
            // 현재 슬라이드의 픽셀 위치를 기준으로 이후 move에서 더할 수 있게 설정
            currentTranslate = -index * slider.clientWidth; // px 기준
            // 터치 드래그중에는 transition을 끄고 즉시 위치 반영
            setTransition(false);
        }

        function touchMove(e) {
            // 드래그 중이면 손가락 움직임을 따라 슬라이드를 실시간으로 이동
            if (!isDragging) return;
            const dx = e.touches[0].clientX - startX;
            const move = currentTranslate + dx;
            slidesEl.style.transform = `translateX(${move}px)`;
        }

        function touchEnd(e) {
            // 드래그 끝나면 이동량이 임계값(threshold)을 초과하는지 검사해
            // 다음/이전으로 전환할지 판단하고, 애니메이션을 켠 뒤 복원합니다.
            if (!isDragging) return;
            isDragging = false;
            const dx = e.changedTouches[0].clientX - startX;
            const threshold = slider.clientWidth * 0.2; // 화면 너비의 20%를 기준으로 함
            setTransition(true);
            if (Math.abs(dx) > threshold) {
                if (dx < 0) {
                    index++;
                } else {
                    index--;
                }
            }
            // 복원: px 단위로 복원
            slidesEl.style.transform = `translateX(${-index * slider.clientWidth}px)`;
            // 보정 필요하면 transitionend 이벤트에서 처리
            resetTimer();
        }

        // 초기 dots 상태, 시작
        updateDotsByIndex(index);
        startTimer();

        // 윈도우 리사이즈 처리
        // 리사이즈 시 slider.clientWidth가 변경되므로 현재 index 기반 위치를 재계산
        // transition을 끄고 위치를 맞춘 뒤 짧은 시간 뒤 transition을 복원합니다.
        window.addEventListener('resize', () => {
            // 리사이즈 시에도 px 단위로 재계산
            setTransition(false);
            slidesEl.style.transform = `translateX(${-index * slider.clientWidth}px)`;
            // 작은 시간 뒤에 transition 복원
            setTimeout(() => setTransition(true), 50);
        });
    })();
});

// 카테고리 필터링 시스템 - 동적 카드 지원 버전
class CategoryFilter {
    constructor() {
        this.currentCategory = 'all';
        this.itemsContainer = document.querySelector('.items');
        
        this.init();
        this.setupMutationObserver(); // 새 카드 감지용
    }
    
    // 카테고리 버튼들을 동적으로 가져오는 함수
    getCategoryButtons() {
        return document.querySelectorAll('.category-btn');
    }
    
    init() {
        this.bindEvents();
        this.filterCards('all'); // 초기 전체 표시
    }
    
    // DOM 변화 감지 (새 카드 추가 시 자동으로 필터링 적용)
    setupMutationObserver() {
        const observer = new MutationObserver((mutations) => {
            mutations.forEach((mutation) => {
                if (mutation.type === 'childList') {
                    // 새로 추가된 노드들 확인
                    mutation.addedNodes.forEach((node) => {
                        if (node.nodeType === Node.ELEMENT_NODE) {
                            // 새로 추가된 카드가 있는지 확인
                            const newCards = node.classList && node.classList.contains('card') 
                                ? [node] 
                                : node.querySelectorAll ? node.querySelectorAll('.card') : [];
                            
                            newCards.forEach(card => {
                                this.initializeCardCategory(card);
                                this.applyCurrentFilter(card);
                            });
                        }
                    });
                }
            });
        });
        
        // items 컨테이너의 자식 노드 변화 감지
        observer.observe(this.itemsContainer, {
            childList: true,
            subtree: true
        });
    }
    
    // 개별 카드에 카테고리 초기화
    initializeCardCategory(card) {
        // 이미 초기화된 카드는 스킵
        if (card.getAttribute('data-category')) return;
        
        // 카드의 카테고리 정보 추출 (info1 텍스트에서)
        const categoryText = card.querySelector('.info1');
        let category = '기타'; // 기본값
        
        if (categoryText) {
            const text = categoryText.textContent;
            const match = text.match(/\[([^\]]+)\]/);
            if (match) {
                category = match[1];
            }
        }
        
        // 카테고리 데이터 속성 설정
        card.setAttribute('data-category', category);
    }
    
    // 현재 필터를 새 카드에 적용
    applyCurrentFilter(card) {
        const cardCategory = card.getAttribute('data-category');
        const shouldShow = this.currentCategory === 'all' || cardCategory === this.currentCategory;
        
        if (shouldShow) {
            this.showCard(card);
        } else {
            this.hideCard(card);
        }
    }
    
    bindEvents() {
        // 이벤트 위임을 사용하여 동적으로 생성된 버튼들도 처리
        document.addEventListener('click', (e) => {
            if (e.target.classList.contains('category-btn')) {
                const category = e.target.getAttribute('data-category');
                this.setActiveCategory(category);
                this.filterCards(category);
            }
        });
    }
    
    setActiveCategory(category) {
        // 현재 존재하는 모든 카테고리 버튼에서 active 제거
        this.getCategoryButtons().forEach(btn => btn.classList.remove('active'));
        
        // 새로 선택된 카테고리 버튼에 active 추가
        const activeBtns = document.querySelectorAll(`[data-category="${category}"]`);
        activeBtns.forEach(btn => btn.classList.add('active'));
        
        this.currentCategory = category;
    }
    
    // 모든 카드를 다시 찾아서 필터링 (동적 카드 포함)
    filterCards(category) {
        // 현재 존재하는 모든 카드 찾기 (템플릿 제외)
        const allCards = document.querySelectorAll('.card:not(#card-template)');
        
        allCards.forEach(card => {
            // 카드가 아직 초기화되지 않았다면 초기화
            this.initializeCardCategory(card);
            
            const cardCategory = card.getAttribute('data-category');
            const shouldShow = category === 'all' || cardCategory === category;
            
            if (shouldShow) {
                this.showCard(card);
            } else {
                this.hideCard(card);
            }
        });
    }
    
    showCard(card) {
        card.classList.remove('hidden', 'fade-out');
        card.classList.add('fade-in');
        card.style.display = 'block';
    }
    
    hideCard(card) {
        card.classList.add('fade-out');
        setTimeout(() => {
            card.classList.add('hidden');
            card.classList.remove('fade-in');
        }, 300);
    }
    
    // 외부에서 새 카드 추가 시 호출할 수 있는 메서드
    refreshFilter() {
        this.filterCards(this.currentCategory);
    }
}

// 전역 카테고리 필터 인스턴스 (외부에서 접근 가능하도록)
let categoryFilterInstance = null;

// 서버에서 클래스 목록을 받아와서 카드를 동적으로 생성
async function loadClassesFromServer() {
    try {
        const response = await fetch('/api/classes');
        const classes = await response.json();
        
        const itemsContainer = document.querySelector('.items');
        const template = document.getElementById('card-template');
        
        // 기존 카드들 제거 (템플릿 제외)
        const existingCards = itemsContainer.querySelectorAll('.card:not(#card-template)');
        existingCards.forEach(card => card.remove());
        
        // 새로운 카드들 생성
        classes.forEach(classData => {
            const card = template.content.cloneNode(true);
            
            // 카드 데이터 설정
            const img = card.querySelector('.img-card img');
            const category = card.querySelector('.info1');
            const title = card.querySelector('.class-name');
            const description = card.querySelector('.info2');
            const link = card.querySelector('a');
            
            img.src = classData.imageUrl || '';
            img.alt = classData.title || '클래스 이미지';
            category.textContent = `[${classData.category}]`;
            title.textContent = classData.title;
            description.textContent = classData.description;
            link.href = `/class/${classData.id}`;
            
            // 카테고리 데이터 속성 설정
            card.querySelector('.card').setAttribute('data-category', classData.category);
            
            itemsContainer.appendChild(card);
        });
        
        // 카테고리 필터 새로고침
        if (categoryFilterInstance) {
            categoryFilterInstance.refreshFilter();
        }
        
    } catch (error) {
        console.error('클래스 데이터 로딩 실패:', error);
    }
}

// 외부에서 새 카드 추가 시 필터링 새로고침을 위한 전역 함수
window.refreshCategoryFilter = function() {
    if (categoryFilterInstance) {
        categoryFilterInstance.refreshFilter();
    }
};

// 외부에서 서버 데이터 로드 함수 호출 가능하도록 전역 등록
window.loadClassesFromServer = loadClassesFromServer;

// 카테고리 슬라이더 클래스
class CategorySlider {
    constructor() {
        this.container = document.getElementById('category-slider');
        this.slidesEl = document.getElementById('categorySlides');
        this.prevBtn = document.getElementById('categoryPrev');
        this.nextBtn = document.getElementById('categoryNext');
        
        // 필요한 요소들이 존재하는지 확인
        if (!this.container || !this.slidesEl || !this.prevBtn || !this.nextBtn) {
            console.warn('카테고리 슬라이더 초기화 실패: 필요한 요소들이 없습니다.');
            return;
        }
        
        this.allButtons = this.getAllButtons();
        this.currentIndex = 0;
        this.buttonsPerView = this.getButtonsPerView();
        
        this.init();
    }
    
    init() {
        // 초기 슬라이드 구성
        this.reorganizeSlides();
        
        // 버튼 이벤트 등록
        this.prevBtn.addEventListener('click', () => this.prevSlide());
        this.nextBtn.addEventListener('click', () => this.nextSlide());
        
        // 리사이즈 이벤트 등록
        window.addEventListener('resize', () => this.handleResize());
        
        // 초기 상태 설정
        this.updateSlider();
        this.updateButtons();
    }
    
    getAllButtons() {
        const buttons = [];
        const slides = Array.from(this.slidesEl.children);
        slides.forEach(slide => {
            const slideButtons = Array.from(slide.querySelectorAll('.category-btn'));
            buttons.push(...slideButtons);
        });
        return buttons;
    }
    
    reorganizeSlides() {
        // 현재 활성 카테고리 저장
        const activeButton = document.querySelector('.category-btn.active');
        const activeCategory = activeButton ? activeButton.getAttribute('data-category') : 'all';
        
        // 기존 슬라이드들 제거
        this.slidesEl.innerHTML = '';
        
        // 화면 크기에 맞게 버튼들을 새로운 슬라이드로 재구성
        const buttonsPerSlide = this.buttonsPerView;
        let currentSlide = null;
        
        this.allButtons.forEach((button, index) => {
            if (index % buttonsPerSlide === 0) {
                // 새 슬라이드 생성
                currentSlide = document.createElement('div');
                currentSlide.className = 'category-slide';
                this.slidesEl.appendChild(currentSlide);
            }
            
            // 버튼을 현재 슬라이드에 추가 (이벤트도 함께 복사됨)
            const clonedButton = button.cloneNode(true);
            
            // 활성 상태 복원
            if (button.getAttribute('data-category') === activeCategory) {
                clonedButton.classList.add('active');
            }
            
            currentSlide.appendChild(clonedButton);
        });
        
        // 슬라이드 배열 업데이트
        this.slides = Array.from(this.slidesEl.children);
    }
    
    getButtonsPerView() {
        const containerWidth = this.container.clientWidth;
        const buttonMinWidth = 140; // CSS의 기본 min-width
        const gap = 16; // CSS의 기본 gap
        
        // 화면 크기별 버튼 수 계산
        if (containerWidth <= 320) {
            return 2; // 매우 작은 화면
        } else if (containerWidth <= 480) {
            return 3; // 소형 모바일
        } else if (containerWidth <= 768) {
            return 4; // 모바일
        } else if (containerWidth <= 1024) {
            return 5; // 태블릿
        } else {
            return 6; // 데스크탑
        }
    }
    
    getTotalSlides() {
        return this.slides.length;
    }
    
    handleResize() {
        const newButtonsPerView = this.getButtonsPerView();
        if (newButtonsPerView !== this.buttonsPerView) {
            this.buttonsPerView = newButtonsPerView;
            
            // 슬라이드 재구성
            this.reorganizeSlides();
            
            // 현재 인덱스가 새로운 화면에서 유효한지 확인
            const maxIndex = Math.max(0, this.slides.length - 1);
            if (this.currentIndex > maxIndex) {
                this.currentIndex = maxIndex;
            }
            
            this.updateSlider();
            this.updateButtons();
        }
    }
    
    prevSlide() {
        if (this.currentIndex > 0) {
            this.currentIndex--;
            this.updateSlider();
            this.updateButtons();
        }
    }
    
    nextSlide() {
        const maxIndex = Math.max(0, this.slides.length - 1);
        if (this.currentIndex < maxIndex) {
            this.currentIndex++;
            this.updateSlider();
            this.updateButtons();
        }
    }
    
    updateSlider() {
        const translateX = -this.currentIndex * 100;
        this.slidesEl.style.transform = `translateX(${translateX}%)`;
    }
    
    updateButtons() {
        const maxIndex = Math.max(0, this.slides.length - 1);
        
        // 이전 버튼 상태
        this.prevBtn.style.opacity = this.currentIndex === 0 ? '0.3' : '1';
        this.prevBtn.style.pointerEvents = this.currentIndex === 0 ? 'none' : 'auto';
        
        // 다음 버튼 상태
        this.nextBtn.style.opacity = this.currentIndex >= maxIndex ? '0.3' : '1';
        this.nextBtn.style.pointerEvents = this.currentIndex >= maxIndex ? 'none' : 'auto';
        
        // 슬라이드가 1개뿐이면 슬라이드 버튼 숨기기
        if (this.slides.length <= 1) {
            this.prevBtn.style.display = 'none';
            this.nextBtn.style.display = 'none';
        } else {
            this.prevBtn.style.display = 'flex';
            this.nextBtn.style.display = 'flex';
        }
    }
}

// DOM 로드 완료 후 카테고리 필터 초기화
document.addEventListener('DOMContentLoaded', function() {
    // 기존 슬라이더 초기화 코드는 위에 이미 있음...
    
    // 카테고리 슬라이더 초기화 (요소가 존재하는 경우에만)
    const categorySliderElement = document.getElementById('category-slider');
    if (categorySliderElement) {
        const categorySlider = new CategorySlider();
    }
    
    // 카테고리 필터 초기화
    categoryFilterInstance = new CategoryFilter();
    
    // 페이지 로드 시 서버에서 데이터 로드 (선택사항)
    // loadClassesFromServer();
});


