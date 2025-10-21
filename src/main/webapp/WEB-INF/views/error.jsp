<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>오류 - 원데이 클래스</title>
    
    <style>
        .error-container {
            max-width: 600px;
            margin: 100px auto;
            padding: 0 20px;
            text-align: center;
        }
        
        .error-icon {
            font-size: 120px;
            margin-bottom: 32px;
            animation: shake 0.5s;
        }
        
        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            25% { transform: translateX(-10px); }
            75% { transform: translateX(10px); }
        }
        
        .error-title {
            font-size: 32px;
            font-weight: 700;
            color: var(--text-primary);
            margin-bottom: 16px;
        }
        
        .error-message {
            font-size: 18px;
            color: var(--text-secondary);
            margin-bottom: 40px;
            line-height: 1.6;
        }
        
        .error-actions {
            display: flex;
            gap: 16px;
            justify-content: center;
            flex-wrap: wrap;
        }
        
        .error-actions a {
            display: inline-block;
            padding: 14px 32px;
            border-radius: 8px;
            font-weight: 600;
            text-decoration: none;
            transition: var(--transition);
        }
        
        .btn-primary {
            background: var(--primary-color);
            color: var(--text-white);
        }
        
        .btn-primary:hover {
            background: var(--primary-dark);
            transform: translateY(-2px);
        }
        
        .btn-secondary {
            background: var(--bg-gray);
            color: var(--text-primary);
        }
        
        .btn-secondary:hover {
            background: var(--primary-light);
        }
        
        /* 반응형 */
        @media screen and (max-width: 768px) {
            .error-container {
                margin: 60px auto;
            }
            
            .error-icon {
                font-size: 80px;
            }
            
            .error-title {
                font-size: 24px;
            }
            
            .error-message {
                font-size: 16px;
            }
            
            .error-actions {
                flex-direction: column;
            }
            
            .error-actions a {
                width: 100%;
            }
        }
    </style>
</head>
<body>
    <!-- 공통 헤더 포함 -->
    <jsp:include page="/WEB-INF/views/includes/header.jsp" />

    <div class="error-container">
        <div class="error-icon">⚠️</div>
        <h1 class="error-title">오류가 발생했습니다</h1>
        <p class="error-message">
            ${not empty errorMessage ? errorMessage : '알 수 없는 오류가 발생했습니다.'}
        </p>
        
        <div class="error-actions">
            <a href="${pageContext.request.contextPath}/main" class="btn-primary">
                🏠 메인페이지로
            </a>
            <a href="javascript:history.back()" class="btn-secondary">
                ← 이전 페이지로
            </a>
        </div>
    </div>

    <!-- 공통 푸터 포함 -->
    <jsp:include page="/WEB-INF/views/includes/footer.jsp" />
</body>
</html>
