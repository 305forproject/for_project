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

    // 모달 닫기 이벤트 리스너
    document.addEventListener('click', function (e) {
        if (e.target.classList.contains('close')) {
            e.target.closest('.modal').style.display = 'none';
        }

        // 모달 외부 클릭 시 닫기
        if (e.target.classList.contains('modal')) {
            e.target.style.display = 'none';
        }
    });
});

// 슬라이더
const swiper = new Swiper(".mySwiper", {
    navigation: { // 좌우 버튼 설정
        nextEl: ".swiper-button-next",
        prevEl: ".swiper-button-prev",
    },
    pagination: { // 하단 점 페이지네이션 설정
        el: ".swiper-pagination",
        clickable: true, // 클릭하여 이동 가능
    },
    loop: true, // 무한 반복
});


// 카테고리 슬라이더
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
document.addEventListener('DOMContentLoaded', function () {
    // 기존 슬라이더 초기화 코드는 위에 이미 있음...

    // 카테고리 슬라이더 초기화 (요소가 존재하는 경우에만)
    const categorySliderElement = document.getElementById('category-slider');
    if (categorySliderElement) {
        const categorySlider = new CategorySlider();
    }

    // 카테고리 필터 초기화
    new CategoryFilter();
});

// 카테고리 매핑 테이블 - 영어 키워드를 한국어 카테고리명으로 변환
const CATEGORY_MAPPING = {
    'all': '전체',
    'painting': '그림',
    'pottery': '도자기', 
    'baking': '베이킹',
    'cooking': '요리',
    'flower': '플라워',
    'metalworking': '금속공예',
    'bookmaking': '책만들기'
};

// 카테고리 필터링 시스템 - 서버 데이터와 연동
class CategoryFilter {
    constructor() {
        this.currentCategory = 'all';
        this.itemsContainer = document.querySelector('.items');
        this.init();
    }

    init() {
        this.bindEvents();
        this.initializeAllCards(); // 모든 기존 카드 초기화
        this.filterCards('all'); // 초기 전체 표시
    }

    // 모든 카드 초기화 (서버에서 data-category가 이미 설정되어 있을 것으로 예상)
    initializeAllCards() {
        const cards = document.querySelectorAll('.card');
        cards.forEach(card => {
            // 서버에서 data-category가 설정되지 않은 경우를 위한 fallback
            if (!card.getAttribute('data-category')) {
                const categoryText = card.querySelector('.info1');
                if (categoryText) {
                    const category = categoryText.textContent.trim();
                    card.setAttribute('data-category', category);
                }
            }
        });
    }

    bindEvents() {
        // 카테고리 슬라이더 버튼들에 이벤트 리스너 추가
        document.addEventListener('click', (e) => {
            if (e.target.classList.contains('category-btn')) {
                e.preventDefault(); // 기본 동작 방지
                
                const categoryKey = e.target.getAttribute('data-category');
                this.setActiveCategory(e.target);
                this.filterCards(categoryKey);
            }
        });
    }

    // 활성 카테고리 버튼 설정
    setActiveCategory(clickedBtn) {
        // 모든 카테고리 버튼에서 active 클래스 제거
        document.querySelectorAll('.category-btn').forEach(btn => {
            btn.classList.remove('active');
        });
        
        // 클릭된 버튼에 active 클래스 추가
        clickedBtn.classList.add('active');
    }

    // 카드 필터링
    filterCards(categoryKey) {
        this.currentCategory = categoryKey;
        const cards = document.querySelectorAll('.card');
        
        cards.forEach(card => {
            const cardCategory = card.getAttribute('data-category');
            let shouldShow = false;

            if (categoryKey === 'all') {
                shouldShow = true;
            } else {
                // 영어 키워드를 한국어 카테고리명으로 변환하여 비교
                const targetCategory = CATEGORY_MAPPING[categoryKey];
                shouldShow = cardCategory === targetCategory;
            }

            if (shouldShow) {
                this.showCard(card);
            } else {
                this.hideCard(card);
            }
        });

        this.updateItemsTitle(categoryKey);
    }

    // 카드 표시
    showCard(card) {
        card.classList.remove('hidden', 'fade-out');
        card.classList.add('fade-in');
        card.style.display = 'block';
    }

    // 카드 숨김
    hideCard(card) {
        card.classList.add('fade-out');
        setTimeout(() => {
            card.classList.add('hidden');
            card.classList.remove('fade-in');
            card.style.display = 'none';
        }, 300);
    }

    // 아이템 제목 업데이트
    updateItemsTitle(categoryKey) {
        const titleElement = document.querySelector('.items-menu h2');
        if (titleElement) {
            const categoryName = CATEGORY_MAPPING[categoryKey] || '전체';
            titleElement.textContent = categoryKey === 'all' ? '추천 강의' : `${categoryName} 강의`;
        }
    }
}


