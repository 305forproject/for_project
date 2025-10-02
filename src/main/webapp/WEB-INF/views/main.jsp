<%--
  메인 페이지

  로그인 성공 후 사용자에게 환영 메시지를 표시합니다.
  사용자의 이름을 세션 정보를 통해 가져와 개인화된 인사말을 보여줍니다.

  사용되는 속성:
  - user: 현재 로그인한 사용자 객체 (User 모델)
  - user.name: 사용자의 이름 (환영 메시지에 사용)
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>메인 페이지</title>
    <style>
        .cookie-info {
            border: 1px solid #007bff;
            padding: 10px;
            margin: 10px;
            background: #e7f3ff;
        }

        .logout-btn {
            background: #dc3545;
            color: white;
            padding: 5px 10px;
            border: none;
            cursor: pointer;
        }
    </style>
</head>
<body>
<h1>메인 페이지</h1>

<%
    // 쿠키에서 필요한 정보만 읽기
    String cookieUserId = null;
    String cookieIsTeacher = null;
    String cookieIsStudent = null;

    Cookie[] cookies = request.getCookies();
    if (cookies != null) {
        for (Cookie cookie : cookies) {
            switch (cookie.getName()) {
                case "userId":
                    cookieUserId = cookie.getValue();
                    break;
                case "isTeacher":
                    cookieIsTeacher = cookie.getValue();
                    break;
                case "isStudent":
                    cookieIsStudent = cookie.getValue();
                    break;
            }
        }
    }
%>

<% if (cookieUserId != null) { %>
<!-- 쿠키에서 읽은 사용자 정보 -->
<div class="cookie-info">
    <h3>🍪 쿠키 정보 (브라우저에서 확인 가능)</h3>
    <p><strong>사용자 ID:</strong> <%= cookieUserId %>
    </p>
    <p><strong>교사 권한:</strong> <%= "true".equals(cookieIsTeacher) ? "있음" : "없음" %>
    </p>
    <p><strong>학생 권한:</strong> <%= "true".equals(cookieIsStudent) ? "있음" : "없음" %>
    </p>
</div>

<!-- 역할별 메뉴 -->
<div>
    <h3>메뉴</h3>
    <% if ("true".equals(cookieIsTeacher)) { %>
    <a href="teacher/courses.jsp">교사 메뉴</a><br>
    <% } %>
    <% if ("true".equals(cookieIsStudent)) { %>
    <a href="student/courses.jsp">학생 메뉴</a><br>
    <% } %>
    <a href="teacher-page">
        <button type="button">선생님 전용페이지</button>
    </a><br>
</div>

<!-- 로그아웃 버튼 -->
<div style="margin-top: 20px;">
    <form method="post" action="logout" style="display: inline;">
        <button type="submit" class="logout-btn">로그아웃</button>
    </form>
</div>

<% } else { %>
<!-- 로그인되지 않은 경우 -->
<p>로그인이 필요합니다.</p>
<a href="login">로그인 페이지로 이동</a>
<% } %>
</body>
</html>
