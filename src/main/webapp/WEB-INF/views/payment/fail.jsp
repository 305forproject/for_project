<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>결제 실패 - 원데이 클래스</title>
    
    <style>
        .payment-container {
            max-width: 600px;
            margin: 100px auto;
            padding: 0 20px;
        }
        
        .payment-card {
            background: #fff5f5;
            border: 2px solid #feb2b2;
            border-radius: var(--border-radius);
            padding: 60px 40px;
            box-shadow: var(--shadow-lg);
            text-align: center;
        }
        
        .error-icon {
            width: 120px;
            height: 120px;
            margin: 0 auto 32px;
            animation: errorShake 0.6s ease;
        }
        
        @keyframes errorShake {
            0%, 100% { transform: translateX(0); }
            25% { transform: translateX(-10px); }
            75% { transform: translateX(10px); }
        }
        
        .error-title {
            font-size: 32px;
            font-weight: 700;
            color: #c53030;
            margin-bottom: 16px;
        }
        
        .error-message {
            font-size: 16px;
            color: var(--text-secondary);
            margin-bottom: 24px;
            line-height: 1.6;
        }
        
        .error-details {
            background: var(--bg-white);
            border-radius: 8px;
            padding: 24px;
            margin-bottom: 32px;
            text-align: left;
        }
        
        .error-details p {
            margin-bottom: 12px;
            color: var(--text-secondary);
        }
        
        .error-details strong {
            color: var(--text-primary);
            display: inline-block;
            min-width: 100px;
        }
        
        .error-code {
            font-family: 'Courier New', monospace;
            background: #f7fafc;
            padding: 2px 8px;
            border-radius: 4px;
            color: #c53030;
            font-size: 14px;
        }
        
        .action-buttons {
            display: flex;
            gap: 16px;
            justify-content: center;
            flex-wrap: wrap;
        }
        
        .btn {
            padding: 14px 32px;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
            transition: var(--transition);
        }
        
        .btn-primary {
            background: #c53030;
            color: var(--text-white);
        }
        
        .btn-primary:hover {
            background: #9b2c2c;
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
            .payment-container {
                margin: 60px auto;
            }
            
            .payment-card {
                padding: 40px 24px;
            }
            
            .error-title {
                font-size: 24px;
            }
            
            .action-buttons {
                flex-direction: column;
            }
            
            .btn {
                width: 100%;
            }
        }
    </style>
</head>
<body>
    <!-- 공통 헤더 포함 -->
    <jsp:include page="/WEB-INF/views/includes/header.jsp" />

    <div class="payment-container">
        <div class="payment-card">
            <img src="https://static.toss.im/lotties/error-spot-no-loop-space-apng.png" 
                 alt="결제 실패" class="error-icon">
            
            <h1 class="error-title">❌ 결제에 실패했습니다</h1>
            <p class="error-message">
                결제 처리 중 문제가 발생했습니다.<br>
                아래 정보를 확인하신 후 다시 시도해 주세요.
            </p>
            
            <div class="error-details">
                <p>
                    <strong>실패 사유:</strong> 
                    ${not empty message ? message : '알 수 없는 오류'}
                </p>
                <c:if test="${not empty code}">
                    <p>
                        <strong>에러 코드:</strong> 
                        <span class="error-code">${code}</span>
                    </p>
                </c:if>
            </div>
            
            <div class="action-buttons">
                <a href="javascript:history.back()" class="btn btn-primary">
                    🔄 다시 시도
                </a>
                <a href="${pageContext.request.contextPath}/main" class="btn btn-secondary">
                    🏠 메인으로
                </a>
            </div>
            
            <p style="margin-top: 32px; font-size: 14px; color: var(--text-muted);">
                문제가 계속되면 고객센터로 문의해 주세요.<br>
                📞 010-1234-5678
            </p>
        </div>
    </div>

    <!-- 공통 푸터 포함 -->
    <jsp:include page="/WEB-INF/views/includes/footer.jsp" />
</body>
</html>
