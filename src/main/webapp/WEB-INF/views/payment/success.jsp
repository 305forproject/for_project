<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <title>결제 성공</title>
    <meta http-equiv="x-ua-compatible" content="ie=edge"/>
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/css/style.css"/>
</head>
<body>
<section>
    <%-- 컨트롤러가 반환 값 true일 때 --%>
    <c:if test="${isSuccess}">
        <div class="box_section" style="width: 600px">
            <img width="100px" src="https://static.toss.im/illusts/check-blue-spot-ending-frame.png"/>
            <h2>결제를 완료했어요</h2>
                <%--
                    컨트롤러가 반환 객체에서 json 받아와 출력
                --%>
            <div class="p-grid typography--p" style="margin-top: 50px">
                <div class="p-grid-col text--left"><b>결제금액</b></div>
                <div class="p-grid-col text--right">${paymentResult.totalAmount} 원</div>
            </div>
            <div class="p-grid typography--p" style="margin-top: 10px">
                <div class="p-grid-col text--left"><b>주문번호</b></div>
                <div class="p-grid-col text--right">${paymentResult.orderId}</div>
            </div>
            <br>
            <button class="button" onclick="location.href='${pageContext.request.contextPath}/'"
                    style="margin-top: 30px;">메인 화면으로 돌아가기
            </button>
        </div>
    </c:if>

    <%-- isSuccess가 false --%>
    <c:if test="${not isSuccess}">
        <div class="box_section" style="width: 600px">
            <img width="100px" src="https://static.toss.im/lotties/error-spot-no-loop-space-apng.png"/>
            <h2>결제 승인에 실패했어요</h2>
            <p>오류 메시지: ${errorMsg}</p>
            <br>
            <button class="button" onclick="location.href='${pageContext.request.contextPath}/'"
                    style="margin-top: 30px;">메인 화면으로 돌아가기
            </button>
        </div>
    </c:if>
</section>
</body>
</html>