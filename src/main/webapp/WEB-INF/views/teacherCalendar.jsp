<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="oneday.util.PropertyUtil" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>내 강의 현황 - 원데이 클래스</title>
    
    <script src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.9/index.global.min.js'></script>
    <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=<%= PropertyUtil.getKakaoJavascriptKey() %>&autoload=false"></script>
    <style>
        .teacher-calendar-container {
            max-width: 1400px;
            margin: 40px auto;
            padding: 0 20px;
        }
        
        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 40px;
            flex-wrap: wrap;
            gap: 20px;
        }
        
        .page-title {
            font-size: 32px;
            font-weight: 700;
            color: var(--text-primary);
        }
        
        .register-button {
            padding: 14px 28px;
            background: var(--primary-color);
            color: var(--text-white);
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: var(--transition);
        }
        
        .register-button:hover {
            background: var(--primary-dark);
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
        }
        
        .calendar-content {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 32px;
        }
        
        .calendar-section,
        .detail-section {
            background: var(--bg-white);
            border-radius: var(--border-radius);
            padding: 32px;
            box-shadow: var(--shadow-md);
        }
        
        .section-title {
            font-size: 24px;
            font-weight: 700;
            color: var(--text-primary);
            margin-bottom: 24px;
            padding-bottom: 16px;
            border-bottom: 2px solid var(--primary-color);
        }
        
        #teacher-calendar {
            margin-top: 20px;
        }
        
        .detail-item {
            margin-bottom: 16px;
            padding: 12px 0;
            border-bottom: 1px solid var(--border-color);
        }
        
        .detail-item:last-child {
            border-bottom: none;
        }
        
        .detail-item span {
            font-weight: 600;
            color: var(--text-primary);
            display: inline-block;
            width: 100px;
        }
        
        .placeholder {
            text-align: center;
            padding: 40px 20px;
            color: var(--text-muted);
            font-size: 16px;
        }
        
        #map {
            width: 100%;
            height: 300px;
            margin-top: 20px;
            border-radius: var(--border-radius);
            box-shadow: var(--shadow-sm);
        }
        
        /* 반응형 */
        @media screen and (max-width: 1024px) {
            .calendar-content {
                grid-template-columns: 1fr;
            }
        }
        
        @media screen and (max-width: 768px) {
            .teacher-calendar-container {
                padding: 0 16px;
                margin: 20px auto;
            }
            
            .page-header {
                flex-direction: column;
                align-items: flex-start;
            }
            
            .page-title {
                font-size: 24px;
            }
            
            .register-button {
                width: 100%;
                justify-content: center;
            }
            
            .calendar-section,
            .detail-section {
                padding: 20px 16px;
            }
            
            #map {
                height: 250px;
            }
        }
    </style>
</head>
<body>
    <!-- 공통 헤더 포함 -->
    <jsp:include page="/WEB-INF/views/includes/header.jsp" />

    <div class="teacher-calendar-container">
        <!-- 페이지 헤더 -->
        <div class="page-header">
            <h1 class="page-title">📚 내 강의 현황</h1>
            <a href="${pageContext.request.contextPath}/teachers/classes/register" class="register-button">
                ➕ 클래스 등록하기
            </a>
        </div>

        <!-- 캘린더 및 상세 정보 -->
        <div class="calendar-content">
            <!-- 왼쪽: 캘린더 -->
            <div class="calendar-section">
                <h3 class="section-title">강의 캘린더</h3>
                <div id="teacher-calendar"></div>
            </div>

            <!-- 오른쪽: 상세 정보 -->
            <div class="detail-section">
                <h3 class="section-title">강의 상세 정보</h3>
                <div id="event-detail-box">
                    <p class="placeholder">
                        달력에서 강의를 클릭하면<br>
                        상세 정보가 표시됩니다.
                    </p>
                </div>
                
                <!-- 카카오 맵 -->
                <div id="map"></div>
            </div>
        </div>
    </div>

    <!-- 공통 푸터 포함 -->
    <jsp:include page="/WEB-INF/views/includes/footer.jsp" />

    <!-- JavaScript -->
    <script src="${pageContext.request.contextPath}/static/js/kakaoMap.js"></script>
    <script src="${pageContext.request.contextPath}/static/js/calendar.js"></script>
    
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const teacherEventsUrl = "${pageContext.request.contextPath}/teachers/classes/events";
            const teacherDetailUrlPrefix = "${pageContext.request.contextPath}/teachers/classes/";
            
            // 캘린더 초기화
            initializeCalendar('teacher-calendar', teacherEventsUrl, teacherDetailUrlPrefix);
        });
    </script>
</body>
</html>
