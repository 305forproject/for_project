<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>강의 상세 정보 - 원데이 클래스</title>
    
    <style>
        .class-detail-container {
            max-width: 800px;
            margin: 60px auto;
            padding: 0 20px;
        }
        
        .detail-card {
            background: var(--bg-white);
            border-radius: var(--border-radius);
            padding: 40px;
            box-shadow: var(--shadow-md);
        }
        
        .detail-title {
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
            min-width: 140px;
            flex-shrink: 0;
        }
        
        .detail-value {
            color: var(--text-secondary);
            flex: 1;
        }
        
        .action-buttons {
            display: flex;
            gap: 16px;
            margin-top: 32px;
            justify-content: center;
            flex-wrap: wrap;
        }
        
        .action-buttons a,
        .action-buttons button {
            display: inline-block;
            padding: 14px 28px;
            border-radius: 8px;
            font-weight: 600;
            text-decoration: none;
            transition: var(--transition);
            border: none;
            cursor: pointer;
            font-size: 16px;
        }
        
        .btn-edit {
            background: var(--primary-color);
            color: var(--text-white);
        }
        
        .btn-edit:hover {
            background: var(--primary-dark);
        }
        
        .btn-delete {
            background: #dc3545;
            color: var(--text-white);
        }
        
        .btn-delete:hover {
            background: #c82333;
        }
        
        .btn-back {
            background: var(--bg-gray);
            color: var(--text-primary);
        }
        
        .btn-back:hover {
            background: var(--primary-light);
        }
        
        /* 반응형 */
        @media screen and (max-width: 768px) {
            .class-detail-container {
                margin: 40px auto;
            }
            
            .detail-card {
                padding: 24px;
            }
            
            .detail-title {
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
            
            .action-buttons a,
            .action-buttons button {
                width: 100%;
                text-align: center;
            }
        }
    </style>
</head>
<body>
    <!-- 공통 헤더 포함 -->
    <jsp:include page="/WEB-INF/views/includes/header.jsp" />

    <div class="class-detail-container">
        <div class="detail-card">
            <h1 class="detail-title">📚 강의 상세 정보</h1>
            
            <c:choose>
                <c:when test="${not empty classDetail}">
                    <ul class="detail-list">
                        <li class="detail-item">
                            <span class="detail-label">강의명</span>
                            <span class="detail-value">${classDetail.className}</span>
                        </li>
                        <li class="detail-item">
                            <span class="detail-label">설명</span>
                            <span class="detail-value">${classDetail.description}</span>
                        </li>
                        <li class="detail-item">
                            <span class="detail-label">카테고리</span>
                            <span class="detail-value">${classDetail.categoryName}</span>
                        </li>
                        <li class="detail-item">
                            <span class="detail-label">수업 시작</span>
                            <span class="detail-value">
                                <fmt:formatDate value="${classDetail.startAtAsDate}" 
                                              pattern="yyyy년 MM월 dd일 HH:mm"/>
                            </span>
                        </li>
                        <li class="detail-item">
                            <span class="detail-label">수업 종료</span>
                            <span class="detail-value">
                                <fmt:formatDate value="${classDetail.endAtAsDate}" 
                                              pattern="yyyy년 MM월 dd일 HH:mm"/>
                            </span>
                        </li>
                        <li class="detail-item">
                            <span class="detail-label">최대 학생 수</span>
                            <span class="detail-value">${classDetail.maxStudents}명</span>
                        </li>
                        <li class="detail-item">
                            <span class="detail-label">현재 예약</span>
                            <span class="detail-value">${classDetail.currentReservationCount}명</span>
                        </li>
                        <li class="detail-item">
                            <span class="detail-label">수업료</span>
                            <span class="detail-value">
                                <fmt:formatNumber value="${classDetail.price}" pattern="#,###"/>원
                            </span>
                        </li>
                        <li class="detail-item">
                            <span class="detail-label">장소</span>
                            <span class="detail-value">${classDetail.location}</span>
                        </li>
                    </ul>
                    
                    <div class="action-buttons">
                        <a href="${pageContext.request.contextPath}/teachers/classes/${classDetail.classId}/edit" 
                           class="btn-edit">
                            ✏️ 수정하기
                        </a>
                        <button type="button" onclick="deleteClass(${classDetail.classId})" 
                                class="btn-delete">
                            🗑️ 삭제하기
                        </button>
                        <a href="${pageContext.request.contextPath}/teacher/calendar" 
                           class="btn-back">
                            ← 목록으로
                        </a>
                    </div>
                </c:when>
                <c:otherwise>
                    <p style="text-align: center; padding: 40px; color: var(--text-muted);">
                        강의 정보를 찾을 수 없습니다.
                    </p>
                    <div class="action-buttons">
                        <a href="${pageContext.request.contextPath}/teacher/calendar" 
                           class="btn-back">
                            ← 목록으로
                        </a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <!-- 공통 푸터 포함 -->
    <jsp:include page="/WEB-INF/views/includes/footer.jsp" />

    <script>
        function deleteClass(classId) {
            if (confirm('정말로 이 강의를 삭제하시겠습니까?')) {
                // 삭제 처리
                fetch('${pageContext.request.contextPath}/teachers/classes/' + classId, {
                    method: 'DELETE'
                })
                .then(response => {
                    if (response.ok) {
                        alert('강의가 삭제되었습니다.');
                        window.location.href = '${pageContext.request.contextPath}/teacher/calendar';
                    } else {
                        alert('삭제에 실패했습니다.');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('삭제 중 오류가 발생했습니다.');
                });
            }
        }
    </script>
</body>
</html>
