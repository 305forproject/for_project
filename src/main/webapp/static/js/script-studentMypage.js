// 모바일 메뉴 토글 스크립트
document.addEventListener('DOMContentLoaded', function () {
    const menuBtn = document.querySelector('.mobile-menu-toggle');
    const modal = document.getElementById('mobileMenuModal');
    const closeBtn = document.getElementById('closeMobileMenu');

    if (menuBtn && modal && closeBtn) {
        // 메뉴 열기
        menuBtn.addEventListener('click', function () {
            modal.style.display = 'block';
        });

        // 메뉴 닫기 (X 버튼)
        closeBtn.addEventListener('click', function () {
            modal.style.display = 'none';
        });

        // 모달 바깥 클릭 시 닫기
        modal.addEventListener('click', function (e) {
            if (e.target === modal) {
                modal.style.display = 'none';
            }
        });
    }
});