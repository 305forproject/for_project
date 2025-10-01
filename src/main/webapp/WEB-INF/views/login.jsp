<%--
  로그인 폼 페이지

  사용자가 로그인 ID와 비밀번호를 입력할 수 있는 폼을 제공합니다.
  로그인 실패 시 오류 메시지를 표시합니다.

  사용되는 파라미터:
  - loginId: 사용자가 입력한 로그인 ID
  - password: 사용자가 입력한 비밀번호

  사용되는 속성:
  - error: 로그인 실패 시 표시할 오류 메시지
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>로그인</title>
</head>
<body>
<h2>로그인</h2>
<% if (request.getAttribute("error") != null) { %>
<p style="color: red;">${error}</p>
<% } %>

<form method="post" action="login">
    <div>
        <label>아이디:</label>
        <input type="text" name="loginId" required>
    </div>
    <div>
        <label>비밀번호:</label>
        <input type="password" name="password" required>
    </div>
    <button type="submit">로그인</button>
</form>
</body>
</html>
