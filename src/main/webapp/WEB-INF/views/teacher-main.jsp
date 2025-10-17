<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>강사 페이지 - 원데이 클래스</title>
    
    <style>
        .teacher-container {
            max-width: 1200px;
            margin: 60px auto;
            padding: 0 20px;
        }
        
        .teacher-header {
            text-align: center;
            margin-bottom: 60px;
        }
        
        .teacher-header h1 {
            font-size: 36px;
            font-weight: 700;
            color: var(--text-primary);
            margin-bottom: 16px;
        }
        
        .teacher-header p {
            font-size: 18px;
            color: var(--text-secondary);
        }
        
        .teacher-welcome {
            background: linear-gradient(135deg, var(--primary-light) 0%, var(--bg-white) 100%);
            border-radius: var(--border-radius);
            padding: 40px;
            margin-bottom: 48px;
            text-align: center;
            box-shadow: var(--shadow-sm);
        }
        
        .teacher-welcome h2 {
            font-size: 28px;
            font-weight: 700;
            color: var(--text-primary);
            margin-bottom: 12px;
        }
        
        .teacher-welcome p {
            font-size: 16px;
            color: var(--text-secondary);
        }
        
        .teacher-functions {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 24px;
            margin-bottom: 48px;
        }
        
        .function-card {
            background: var(--bg-white);
            border-radius: var(--border-radius);
            padding: 32px;
            text-align: center;
            box-shadow: var(--shadow-md);
            transition: var(--transition);
            border: 2px solid transparent;
        }
        
        .function-card:hover {
            transform: translateY(-8px);
            border-color: var(--primary-color);
            box-shadow: var(--shadow-lg);
        }
        
        .function-card .icon {
            font-size: 48px;
            margin-bottom: 16px;
        }
        
        .function-card h3 {
            font-size: 20px;
            font-weight: 700;
            color: var(--text-primary);
            margin-bottom: 12px;
        }
        
        .function-card p {
            font-size: 14px;
            color: var(--text-muted);
            line-height: 1.6;
            margin-bottom: 20px;
        }
        
        .function-card .btn {
            display: inline-block;
            padding: 12px 24px;
            background: var(--primary-color);
            color: var(--text-white);
            border-radius: 8px;
            font-weight: 600;
            text-decoration: none;
            transition: var(--transition);
        }
        
        .function-card .btn:hover {
            background: var(--primary-dark);
            transform: scale(1.05);
        }
        
        .back-button {
            text-align: center;
            margin-top: 40px;
        }
        
        .back-button a {
            display: inline-block;
            padding: 14px 32px;
            background: var(--bg-gray);
            color: var(--text-primary);
            border-radius: 8px;
            font-weight: 600;
            text-decoration: none;
            transition: var(--transition);
        }
        
        .back-button a:hover {
            background: var(--primary-light);
            color: var(--primary-dark);
        }
        
        /* 반응형 */
        @media screen and (max-width: 768px) {
            .teacher-container {
                padding: 0 16px;
                margin: 40px auto;
            }
            
            .teacher-header h1 {
                font-size: 28px;
            }
            
            .teacher-welcome {
                padding: 24px;
            }
            
            .teacher-welcome h2 {
                font-size: 22px;
            }
            
            .teacher-functions {
                grid-template-columns: 1fr;
            }
            
            .function-card {
                padding: 24px;
            }
        }
    </style>
</head>
<body>
    <!-- 공통 헤더 포함 -->
    <jsp:include page="/WEB-INF/views/includes/header.jsp" />

    <div class="teacher-container">
        <!-- 헤더 -->
        <div class="teacher-header">
            <h1>👨‍🏫 강사 페이지</h1>
            <p>클래스를 관리하고 학생들과 소통하세요</p>
        </div>

        <!-- 환영 메시지 -->
        <div class="teacher-welcome">
            <h2>환영합니다, 선생님!</h2>
            <p>사용자 ID: ${userId}</p>
        </div>

        <!-- 기능 카드 -->
        <div class="teacher-functions">
            <!-- 클래스 등록 -->
            <div class="function-card">
                <div class="icon">📝</div>
                <h3>클래스 등록</h3>
                <p>새로운 원데이 클래스를 등록하고 학생들을 모집하세요.</p>
                <a href="${pageContext.request.contextPath}/class/register" class="btn">
                    등록하기
                </a>
            </div>

            <!-- 내 클래스 관리 -->
            <div class="function-card">
                <div class="icon">📚</div>
                <h3>내 클래스 관리</h3>
                <p>등록한 클래스 목록을 확인하고 관리하세요.</p>
                <a href="${pageContext.request.contextPath}/teacher/classes" class="btn">
                    관리하기
                </a>
            </div>

            <!-- 예약 캘린더 -->
            <div class="function-card">
                <div class="icon">📅</div>
                <h3>예약 캘린더</h3>
                <p>수강생들의 예약 현황을 캘린더로 확인하세요.</p>
                <a href="${pageContext.request.contextPath}/teacher/calendar" class="btn">
                    보기
                </a>
            </div>

            <!-- 수강생 관리 -->
            <div class="function-card">
                <div class="icon">👥</div>
                <h3>수강생 관리</h3>
                <p>클래스에 참여한 수강생 정보를 관리하세요.</p>
                <a href="${pageContext.request.contextPath}/teacher/students" class="btn">
                    관리하기
                </a>
            </div>

            <!-- 정산 관리 -->
            <div class="function-card">
                <div class="icon">💰</div>
                <h3>정산 관리</h3>
                <p>클래스 수익과 정산 내역을 확인하세요.</p>
                <a href="${pageContext.request.contextPath}/teacher/settlement" class="btn">
                    확인하기
                </a>
            </div>

            <!-- 설정 -->
            <div class="function-card">
                <div class="icon">⚙️</div>
                <h3>설정</h3>
                <p>강사 프로필과 계좌 정보를 관리하세요.</p>
                <a href="${pageContext.request.contextPath}/teacher/settings" class="btn">
                    설정하기
                </a>
            </div>
        </div>

        <!-- 메인으로 돌아가기 -->
        <div class="back-button">
            <a href="${pageContext.request.contextPath}/main">🏠 메인페이지로 돌아가기</a>
        </div>
    </div>

    <!-- 공통 푸터 포함 -->
    <jsp:include page="/WEB-INF/views/includes/footer.jsp" />
</body>
</html>
