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
