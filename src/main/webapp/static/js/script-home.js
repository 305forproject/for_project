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
