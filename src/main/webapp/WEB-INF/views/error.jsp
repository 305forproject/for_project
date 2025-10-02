<%--
  에러 페이지

  시스템 오류나 권한 생성 실패 등의 에러가 발생했을 때 표시되는 페이지입니다.
  에러 메시지를 사용자에게 표시하고 메인페이지로 돌아갈 수 있는 링크를 제공합니다.

  사용되는 속성:
  - errorMessage: 표시할 에러 메시지
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>오류</title>
</head>
<body>
<h1>오류가 발생했습니다</h1>
<p>${errorMessage}</p>

<div>
    <a href="/">
        <button type="button">메인페이지로 돌아가기</button>
    </a>
</div>
</body>
</html>
