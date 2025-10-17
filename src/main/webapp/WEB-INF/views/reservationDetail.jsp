<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>예약 상세 정보 - 원데이 클래스</title>
    
    <style>
        .reservation-container {
            max-width: 800px;
            margin: 60px auto;
            padding: 0 20px;
        }
        
        .reservation-card {
            background: var(--bg-white);
            border-radius: var(--border-radius);
            padding: 40px;
            box-shadow: var(--shadow-md);
        }
        
        .reservation-title {
            font-size: 28px;
            font-weight: 700;
            color: var(--text-primary);
            margin-bottom: 32px;
            padding-bottom: 20px;
            border-bottom: 2px solid var(--primary-color);
        }
        
        .detail-list {
            list-style: none;
            padding: 0;
        }
        
        .detail-item {
            display: flex;
            padding: 20px 0;
            border-bottom: 1px solid var(--border-color);
        }
        
        .detail-item:last-child {
            border-bottom: none;
        }
        
        .detail-label {
            font-weight: 700;
            color: var(--text-primary);
            min-width: 120px;
            flex-shrink: 0;
        }
        
        .detail-value {
            color: var(--text-secondary);
            flex: 1;
        }
        
        .no-reservation {
            text-align: center;
            padding: 60px 20px;
        }
        
        .no-reservation .icon {
            font-size: 80px;
            margin-bottom: 20px;
        }
        
        .no-reservation h2 {
            font-size: 24px;
            color: var(--text-primary);
            margin-bottom: 12px;
        }
        
        .no-reservation p {
            font-size: 16px;
            color: var(--text-muted);
        }
        
        .action-buttons {
            display: flex;
            gap: 16px;
            margin-top: 32px;
            justify-content: center;
        }
        
        .action-buttons a {
            display: inline-block;
            padding: 14px 28px;
            border-radius: 8px;
            font-weight: 600;
            text-decoration: none;
            transition: var(--transition);
        }
        
        .btn-back {
            background: var(--bg-gray);
            color: var(--text-primary);
        }
        
        .btn-back:hover {
            background: var(--primary-light);
        }
        
        .btn-home {
            background: var(--primary-color);
            color: var(--text-white);
        }
        
        .btn-home:hover {
            background: var(--primary-dark);
        }
        
        /* 반응형 */
        @media screen and (max-width: 768px) {
            .reservation-container {
                margin: 40px auto;
            }
            
            .reservation-card {
                padding: 24px;
            }
            
            .reservation-title {
                font-size: 22px;
            }
            
            .detail-item {
                flex-direction: column;
                gap: 8px;
            }
            
            .detail-label {
                min-width: auto;
            }
            
            .action-buttons {
                flex-direction: column;
            }
            
            .action-buttons a {
                width: 100%;
                text-align: center;
            }
        }
    </style>
</head>
<body>
    <!-- 공통 헤더 포함 -->
    <jsp:include page="/WEB-INF/views/includes/header.jsp" />

    <div class="reservation-container">
        <div class="reservation-card">
            <c:choose>
                <c:when test="${not empty reservationDetail}">
                    <h1 class="reservation-title">📋 예약 상세 정보</h1>
                    
                    <ul class="detail-list">
                        <li class="detail-item">
                            <span class="detail-label">📚 강의명</span>
                            <span class="detail-value">${reservationDetail.className}</span>
                        </li>
                        <li class="detail-item">
                            <span class="detail-label">📅 수업 시작</span>
                            <span class="detail-value">
                                <fmt:formatDate value="${reservationDetail.startAtAsDate}" 
                                              pattern="yyyy년 MM월 dd일 HH:mm"/>
                            </span>
                        </li>
                        <li class="detail-item">
                            <span class="detail-label">⏰ 수업 종료</span>
                            <span class="detail-value">
                                <fmt:formatDate value="${reservationDetail.endAtAsDate}" 
                                              pattern="yyyy년 MM월 dd일 HH:mm"/>
                            </span>
                        </li>
                        <li class="detail-item">
                            <span class="detail-label">📍 장소</span>
                            <span class="detail-value">${reservationDetail.location}</span>
                        </li>
                    </ul>
                    
                    <div class="action-buttons">
                        <a href="javascript:history.back()" class="btn-back">
                            ← 뒤로가기
                        </a>
                        <a href="${pageContext.request.contextPath}/users/mypage" class="btn-home">
                            📅 내 예약 목록
                        </a>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="no-reservation">
                        <div class="icon">🔍</div>
                        <h2>예약 정보를 찾을 수 없습니다</h2>
                        <p>예약 정보가 없거나 조회할 권한이 없습니다.</p>
                        
                        <div class="action-buttons">
                            <a href="${pageContext.request.contextPath}/main" class="btn-home">
                                🏠 메인으로
                            </a>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <!-- 공통 푸터 포함 -->
    <jsp:include page="/WEB-INF/views/includes/footer.jsp" />
</body>
</html>
