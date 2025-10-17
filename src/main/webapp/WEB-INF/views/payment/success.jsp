<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>결제 완료 - 원데이 클래스</title>
    
    <style>
        .payment-container {
            max-width: 600px;
            margin: 100px auto;
            padding: 0 20px;
        }
        
        .payment-card {
            background: var(--bg-white);
            border-radius: var(--border-radius);
            padding: 60px 40px;
            box-shadow: var(--shadow-lg);
            text-align: center;
        }
        
        .success-icon {
            width: 120px;
            height: 120px;
            margin: 0 auto 32px;
            animation: successPop 0.6s ease;
        }
        
        @keyframes successPop {
            0% {
                transform: scale(0);
                opacity: 0;
            }
            50% {
                transform: scale(1.1);
            }
            100% {
                transform: scale(1);
                opacity: 1;
            }
        }
        
        .success-title {
            font-size: 32px;
            font-weight: 700;
            color: var(--text-primary);
            margin-bottom: 16px;
        }
        
        .success-message {
            font-size: 16px;
            color: var(--text-secondary);
            margin-bottom: 40px;
            line-height: 1.6;
        }
        
        .payment-details {
            background: var(--bg-light);
            border-radius: 8px;
            padding: 24px;
            margin-bottom: 32px;
            text-align: left;
        }
        
        .detail-row {
            display: flex;
            justify-content: space-between;
            padding: 12px 0;
            border-bottom: 1px solid var(--border-color);
        }
        
        .detail-row:last-child {
            border-bottom: none;
            padding-top: 16px;
            margin-top: 8px;
            border-top: 2px solid var(--primary-color);
        }
        
        .detail-label {
            font-weight: 600;
            color: var(--text-primary);
        }
        
        .detail-value {
            color: var(--text-secondary);
        }
        
        .detail-row:last-child .detail-value {
            font-size: 24px;
            font-weight: 700;
            color: var(--primary-color);
        }
        
        .action-buttons {
            display: flex;
            gap: 16px;
            justify-content: center;
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
            background: var(--primary-color);
            color: var(--text-white);
        }
        
        .btn-primary:hover {
            background: var(--primary-dark);
        }
        
        .btn-secondary {
            background: var(--bg-gray);
            color: var(--text-primary);
        }
        
        .btn-secondary:hover {
            background: var(--primary-light);
        }
        
        .error-card {
            background: #fff5f5;
            border: 2px solid #feb2b2;
        }
        
        .error-icon {
            width: 100px;
            height: 100px;
            margin: 0 auto 24px;
        }
        
        .error-title {
            font-size: 28px;
            font-weight: 700;
            color: #c53030;
            margin-bottom: 16px;
        }
        
        .error-message {
            font-size: 16px;
            color: var(--text-secondary);
            margin-bottom: 32px;
        }
        
        /* 반응형 */
        @media screen and (max-width: 768px) {
            .payment-container {
                margin: 60px auto;
            }
            
            .payment-card {
                padding: 40px 24px;
            }
            
            .success-title,
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
        <!-- 결제 성공 -->
        <c:if test="${isSuccess}">
            <div class="payment-card">
                <img src="https://static.toss.im/illusts/check-blue-spot-ending-frame.png" 
                     alt="성공" class="success-icon">
                
                <h1 class="success-title">🎉 결제가 완료되었습니다</h1>
                <p class="success-message">
                    클래스 예약이 정상적으로 완료되었습니다.<br>
                    예약 정보는 마이페이지에서 확인하실 수 있습니다.
                </p>
                
                <div class="payment-details">
                    <div class="detail-row">
                        <span class="detail-label">주문번호</span>
                        <span class="detail-value">${paymentResult.orderId}</span>
                    </div>
                    <div class="detail-row">
                        <span class="detail-label">결제 방법</span>
                        <span class="detail-value">${paymentResult.method}</span>
                    </div>
                    <div class="detail-row">
                        <span class="detail-label">결제 금액</span>
                        <span class="detail-value">${paymentResult.totalAmount}원</span>
                    </div>
                </div>
                
                <div class="action-buttons">
                    <a href="${pageContext.request.contextPath}/users/mypage" class="btn btn-primary">
                        📅 내 예약 보기
                    </a>
                    <a href="${pageContext.request.contextPath}/main" class="btn btn-secondary">
                        🏠 메인으로
                    </a>
                </div>
            </div>
        </c:if>

        <!-- 결제 실패 -->
        <c:if test="${not isSuccess}">
            <div class="payment-card error-card">
                <img src="https://static.toss.im/lotties/error-spot-no-loop-space-apng.png" 
                     alt="실패" class="error-icon">
                
                <h1 class="error-title">결제 승인 실패</h1>
                <p class="error-message">
                    결제 처리 중 문제가 발생했습니다.<br>
                    ${not empty errorMsg ? errorMsg : '다시 시도해 주시기 바랍니다.'}
                </p>
                
                <div class="action-buttons">
                    <a href="javascript:history.back()" class="btn btn-primary">
                        ← 다시 시도
                    </a>
                    <a href="${pageContext.request.contextPath}/main" class="btn btn-secondary">
                        🏠 메인으로
                    </a>
                </div>
            </div>
        </c:if>
    </div>

    <!-- 공통 푸터 포함 -->
    <jsp:include page="/WEB-INF/views/includes/footer.jsp" />
</body>
</html>
