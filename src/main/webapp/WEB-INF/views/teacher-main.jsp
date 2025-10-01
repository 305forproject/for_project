<%--
  선생님 전용페이지

  선생님 권한을 가진 사용자에게 표시되는 전용 페이지입니다.
  선생님 전용 기능들을 제공합니다.

  사용되는 속성:
  - userId: 현재 로그인한 사용자의 ID
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>선생님 전용페이지</title>
</head>
<body>
<h1>선생님 전용페이지</h1>
<p>환영합니다, 선생님! (사용자 ID: ${userId})</p>

<div>
    <h2>선생님 기능</h2>
    <p>선생님 전용 기능들이 여기에 표시됩니다.</p>
</div>

<div>
    <a href="/">
        <button type="button">메인페이지로 돌아가기</button>
    </a>
</div>
</body>
</html>
