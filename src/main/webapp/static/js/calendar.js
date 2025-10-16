/**
 * FullCalendar를 초기화하고 렌더링하는 함수
 * @param {string} elementId - 달력을 렌더링할 HTML 요소의 ID
 * @param {string} eventsUrl - 달력에 표시할 이벤트 데이터를 가져올 서버의 URL
 * @param {string | null} clickUrlPrefix - 이벤트를 클릭했을 때 상세 정보를 요청할 URL의 앞부분
 */
function initializeCalendar(elementId, eventsUrl, clickUrlPrefix) {
    const calendarEl = document.getElementById(elementId);
    const calendar = new FullCalendar.Calendar(calendarEl, {
        initialView: 'dayGridMonth',
        headerToolbar: {
            left: 'prev,next today',
            center: 'title',
            right: 'dayGridMonth,timeGridWeek'
        },
        events: eventsUrl,
        displayEventTime: false,

        eventClick: async function (info) {
            if (clickUrlPrefix && clickUrlPrefix.trim() !== '') {
                const eventId = info.event.id;
                if (eventId) {
                    try {
                        // 1. 서버에 상세 데이터 비동기(AJAX) 요청
                        const response = await fetch(clickUrlPrefix + eventId);
                        if (!response.ok) {
                            throw new Error('데이터를 불러오는데 실패했습니다.');
                        }
                        const data = await response.json();

                        // 2. 받아온 데이터로 상세 정보 박스 업데이트
                        updateDetailBox(data);

                    } catch (error) {
                        console.error('Error fetching event details:', error);
                        updateDetailBox(null);
                    }
                }
            }
        }
    });

    calendar.render();
}

/**
 * [추가] 상세 정보 박스의 내용을 업데이트하는 함수
 * @param {object | null} data - 서버로부터 받은 상세 정보 데이터 (JSON 객체)
 */
function updateDetailBox(data) {
    const detailBox = document.getElementById('event-detail-box');

    if (data) {
        const start = data.startAt.replace('T', ' ');
        const end = data.endAt.replace('T', ' ');
        const startparts = start.split(' ');
        const endparts = end.split(' ');
        const starttimePart = startparts[1];
        const endtimePart = endparts[1];
        const formattedStartTime = starttimePart.substring(0, 5);
        const formattedEndTime = endtimePart.substring(0, 5);
        let detailHtml = '';

        // data 객체에 currentReservationCount 필드가 있는지 확인하여 학생/선생님을 구분
        if (data.currentReservationCount !== undefined) {
            // --- 선생님용 상세 정보 HTML ---
            detailHtml = `
        <div class="detail-item"><span>강의명:</span> ${data.className}</div>
        <div class="detail-item"><span>카테고리:</span> ${data.categoryName}</div>
        <div class="detail-item"><span>수업 시작:</span> ${formattedStartTime}</div>
        <div class="detail-item"><span>수업 종료:</span> ${formattedEndTime}</div>
        <div class="detail-item"><span>장소:</span> ${data.location}</div>
        <div class="detail-item"><span>예약 현황:</span> ${data.currentReservationCount} / ${data.maxCapacity} 명</div>
      `;
        } else {
            // --- 학생용 상세 정보 HTML ---
            detailHtml = `
        <div class="detail-item"><span>강의명:</span> ${data.className}</div>
        <div class="detail-item"><span>카테고리:</span> ${data.categoryName}</div>
        <div class="detail-item"><span>수업 시작:</span> ${formattedStartTime}</div>
        <div class="detail-item"><span>수업 종료:</span> ${formattedEndTime}</div>
        <div class="detail-item"><span>장소:</span> ${data.location}</div>
      `;
        }
        detailBox.innerHTML = detailHtml;

        // 카카오 맵 초기화 (위도, 경도, 클래스명 전달)
        if (data.latitude && data.longitude) {
            initKakaoMap(data.latitude, data.longitude, data.className);
        } else {
            displayMapError();
        }
    } else {
        detailBox.innerHTML = '<p class="placeholder">정보를 불러올 수 없습니다.</p>';
        displayMapError();
    }
}