<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <title>결제 실패</title>
    <meta http-equiv="x-ua-compatible" content="ie=edge"/>
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/css/style.css"/>
</head>
<body>
<section>
    <div class="box_section" style="width: 600px">
        <h1>결제 실패</h1>
        <%-- 컨트롤러가 넘겨준 실패 메시지와 코드를 화면에 출력합니다. --%>
        <p>실패 사유: ${message}</p>
        <span>에러코드: ${code}</span>
        <br>
        <button class="button" onclick="location.href='${pageContext.request.contextPath}/'" style="margin-top: 30px;">
            메인 화면으로 돌아가기
        </button>
    </div>
</section>
</body>
</html>