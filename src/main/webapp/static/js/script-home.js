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

// 카테고리 필터 가로 스크롤 기능
document.addEventListener('DOMContentLoaded', function() {
    const categoryFilters = document.querySelector('.category-filters');
    
    if (!categoryFilters) return;
    
    // 마우스 휠을 가로 스크롤로 변환
    categoryFilters.addEventListener('wheel', function(e) {
        if (Math.abs(e.deltaY) > Math.abs(e.deltaX)) {
            e.preventDefault();
            const scrollSpeed = 0.8; // 스크롤 감도 조절
            this.scrollLeft += e.deltaY * scrollSpeed;
        }
    }, { passive: false });
});
