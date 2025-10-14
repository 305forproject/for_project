// 토스트 알림 함수
function showToast(message, type = 'info') {
    // 기존 토스트와 오버레이 제거
    const existingToast = document.querySelector('.toast');
    const existingOverlay = document.querySelector('.toast-overlay');
    if (existingToast) existingToast.remove();
    if (existingOverlay) existingOverlay.remove();

    // 오버레이 생성
    const overlay = document.createElement('div');
    overlay.className = 'toast-overlay';
    document.body.appendChild(overlay);

    // 토스트 생성
    const toast = document.createElement('div');
    toast.className = 'toast';
    toast.textContent = message;

    // 닫기 버튼 추가
    const closeBtn = document.createElement('button');
    closeBtn.className = 'toast-close-btn';
    closeBtn.innerHTML = '×';
    closeBtn.onclick = hideToast;
    toast.appendChild(closeBtn);

    document.body.appendChild(toast);

    // 토스트 표시
    setTimeout(() => {
        overlay.classList.add('show');
        toast.classList.add('show');
    }, 10);

    // 3초 후 자동 닫기
    setTimeout(hideToast, 3000);

    function hideToast() {
        if (toast) toast.classList.remove('show');
        if (overlay) overlay.classList.remove('show');
        setTimeout(() => {
            if (toast && toast.parentNode) toast.remove();
            if (overlay && overlay.parentNode) overlay.remove();
        }, 400);
    }
}

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

    // Flatpickr 날짜 선택기 초기화
    if (typeof flatpickr !== 'undefined') {
        // 시작 날짜 선택기
        const startDatePicker = flatpickr("#startDate", {
            locale: "ko",
            dateFormat: "Y-m-d",
            minDate: "today",
            onChange: function(selectedDates, dateStr) {
                // 시작 날짜가 선택되면 끝 날짜의 최소값을 시작 날짜로 설정
                if (endDatePicker) {
                    endDatePicker.set('minDate', dateStr);
                }
            }
        });

        // 끝 날짜 선택기
        const endDatePicker = flatpickr("#endDate", {
            locale: "ko",
            dateFormat: "Y-m-d",
            minDate: "today",
            onChange: function(selectedDates, dateStr) {
                // 끝 날짜가 시작 날짜보다 이전이면 시작 날짜와 같게 설정
                const startDate = startDatePicker.selectedDates[0];
                if (startDate && selectedDates[0] < startDate) {
                    this.setDate(startDate);
                }
            }
        });

        // 시간 선택기
        flatpickr("#startTime", {
            enableTime: true,
            noCalendar: true,
            dateFormat: "H:i",
            time_24hr: true,
            minuteIncrement: 30
        });

        flatpickr("#endTime", {
            enableTime: true,
            noCalendar: true,
            dateFormat: "H:i",
            time_24hr: true,
            minuteIncrement: 30
        });
    }

    // 이미지 드롭 영역 기능
    const dropZone = document.getElementById('imageDropZone');
    const fileInput = document.getElementById('mainImage');
    const dropText = dropZone.querySelector('.drop-text');

    if (dropZone && fileInput) {
        // 클릭으로 파일 선택
        dropZone.addEventListener('click', function() {
            fileInput.click();
        });

        // 드래그 오버
        dropZone.addEventListener('dragover', function(e) {
            e.preventDefault();
            dropZone.classList.add('drag-over');
        });

        // 드래그 리브
        dropZone.addEventListener('dragleave', function(e) {
            e.preventDefault();
            dropZone.classList.remove('drag-over');
        });

        // 파일 드롭
        dropZone.addEventListener('drop', function(e) {
            e.preventDefault();
            dropZone.classList.remove('drag-over');
            
            const files = e.dataTransfer.files;
            if (files.length > 0) {
                handleFileSelect(files[0]);
            }
        });

        // 파일 선택
        fileInput.addEventListener('change', function(e) {
            if (e.target.files.length > 0) {
                handleFileSelect(e.target.files[0]);
            }
        });

        // 파일 처리 함수
        function handleFileSelect(file) {
            if (file.type.startsWith('image/')) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    // 기존 이미지 제거
                    const existingImage = dropZone.querySelector('.preview-image');
                    if (existingImage) {
                        existingImage.remove();
                    }
                    
                    // 새 이미지 표시
                    const img = document.createElement('img');
                    img.src = e.target.result;
                    img.className = 'preview-image';
                    dropZone.appendChild(img);
                    
                    // 텍스트 숨기기
                    dropText.style.display = 'none';
                    dropZone.classList.add('has-image');
                };
                reader.readAsDataURL(file);
            } else {
                showToast('이미지 파일만 업로드 가능합니다.', 'error');
            }
        }
    }

    // 추가 이미지 업로드 기능
    const additionalImageSlots = document.querySelectorAll('.additional-image-slot');
    
    additionalImageSlots.forEach((slot, index) => {
        const dropZone = slot.querySelector('.additional-drop-zone');
        const fileInput = slot.querySelector(`#additionalImage${index}`);
        const dropText = dropZone.querySelector('.drop-text');

        if (dropZone && fileInput) {
            // 클릭으로 파일 선택
            dropZone.addEventListener('click', function(e) {
                // 삭제 버튼 클릭 시 파일 선택 방지
                if (e.target.classList.contains('remove-image-btn')) {
                    return;
                }
                fileInput.click();
            });

            // 드래그 오버
            dropZone.addEventListener('dragover', function(e) {
                e.preventDefault();
                dropZone.classList.add('drag-over');
            });

            // 드래그 리브
            dropZone.addEventListener('dragleave', function(e) {
                e.preventDefault();
                dropZone.classList.remove('drag-over');
            });

            // 파일 드롭
            dropZone.addEventListener('drop', function(e) {
                e.preventDefault();
                dropZone.classList.remove('drag-over');
                
                const files = e.dataTransfer.files;
                if (files.length > 0) {
                    handleAdditionalFileSelect(files[0], dropZone, fileInput, dropText);
                }
            });

            // 파일 선택
            fileInput.addEventListener('change', function(e) {
                if (e.target.files.length > 0) {
                    handleAdditionalFileSelect(e.target.files[0], dropZone, fileInput, dropText);
                }
            });
        }
    });

    // 추가 이미지 파일 처리 함수
    function handleAdditionalFileSelect(file, dropZone, fileInput, dropText) {
        if (file.type.startsWith('image/')) {
            const reader = new FileReader();
            reader.onload = function(e) {
                // 기존 이미지와 삭제 버튼 제거
                const existingImage = dropZone.querySelector('.preview-image');
                const existingRemoveBtn = dropZone.querySelector('.remove-image-btn');
                if (existingImage) existingImage.remove();
                if (existingRemoveBtn) existingRemoveBtn.remove();
                
                // 새 이미지 표시
                const img = document.createElement('img');
                img.src = e.target.result;
                img.className = 'preview-image';
                dropZone.appendChild(img);
                
                // 삭제 버튼 추가
                const removeBtn = document.createElement('button');
                removeBtn.className = 'remove-image-btn';
                removeBtn.innerHTML = '×';
                removeBtn.type = 'button';
                removeBtn.addEventListener('click', function(e) {
                    e.stopPropagation();
                    removeAdditionalImage(dropZone, fileInput, dropText);
                });
                dropZone.appendChild(removeBtn);
                
                // 텍스트 숨기기 및 상태 변경
                dropText.style.display = 'none';
                dropZone.classList.add('has-image');
            };
            reader.readAsDataURL(file);
        } else {
            showToast('이미지 파일만 업로드 가능합니다.', 'error');
        }
    }

    // 추가 이미지 삭제 함수
    function removeAdditionalImage(dropZone, fileInput, dropText) {
        // 이미지와 삭제 버튼 제거
        const existingImage = dropZone.querySelector('.preview-image');
        const existingRemoveBtn = dropZone.querySelector('.remove-image-btn');
        if (existingImage) existingImage.remove();
        if (existingRemoveBtn) existingRemoveBtn.remove();
        
        // 파일 입력 초기화
        fileInput.value = '';
        
        // 텍스트 다시 표시 및 상태 초기화
        dropText.style.display = 'block';
        dropZone.classList.remove('has-image');
    }
});