/**
 * FullCalendar를 초기화하고 렌더링하는 함수
 * @param {string} elementId - 달력을 렌더링할 HTML 요소의 ID
 * @param {string} eventsUrl - 이벤트 데이터를 가져올 서버의 URL
 * @param {string | null} clickUrlPrefix - 이벤트를 클릭했을 때 이동할 URL의 앞부분. null이면 클릭 비활성화.
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

        // [수정] eventClick 로직 변경
        eventClick: function(info) {
            // 1. clickUrlPrefix 값이 있고, 비어있지 않은지 확인합니다.
            if (clickUrlPrefix && clickUrlPrefix.trim() !== '') {
                const eventId = info.event.id;
                if (eventId) {
                    // 2. 전달받은 URL 앞부분과 이벤트 ID를 조합하여 최종 URL을 만듭니다.
                    window.location.href = clickUrlPrefix + eventId;
                }
            }
            // 3. clickUrlPrefix가 null이거나 비어있으면 아무 동작도 하지 않습니다.
        }
    });

    calendar.render();
}