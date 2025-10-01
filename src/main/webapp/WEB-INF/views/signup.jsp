<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>회원가입</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Malgun Gothic', sans-serif;
            background-color: #f5f5f5;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
        }

        .container {
            background: white;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 2px 20px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 400px;
        }

        h2 {
            text-align: center;
            color: #333;
            margin-bottom: 30px;
            font-size: 24px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        label {
            display: block;
            margin-bottom: 8px;
            color: #555;
            font-weight: 500;
            font-size: 14px;
        }

        input[type="text"],
        input[type="password"] {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
            transition: border-color 0.3s;
        }

        input[type="text"]:focus,
        input[type="password"]:focus {
            outline: none;
            border-color: #4CAF50;
        }

        .error-message {
            background-color: #ffebee;
            color: #c62828;
            padding: 12px;
            border-radius: 5px;
            margin-bottom: 20px;
            font-size: 14px;
            display: flex;
            align-items: center;
        }

        .error-message::before {
            content: "⚠";
            margin-right: 8px;
            font-size: 18px;
        }

        .submit-btn {
            width: 100%;
            padding: 14px;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            font-weight: 500;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        .submit-btn:hover {
            background-color: #45a049;
        }

        .submit-btn:active {
            background-color: #3d8b40;
        }
    </style>
</head>
<body>
<div class="container">
    <h2>회원가입</h2>

    <% if (request.getAttribute("error") != null) { %>
    <div class="error-message">
        <%= request.getAttribute("error") %>
    </div>
    <% } %>

    <form action="${pageContext.request.contextPath}/signup" method="post" onsubmit="return validateForm()">
        <div class="form-group">
            <label for="name">이름</label>
            <input type="text"
                   id="name"
                   name="name"
                   value="${name != null ? name : ''}"
                   placeholder="이름을 입력하세요"
                   required>
        </div>

        <div class="form-group">
            <label for="loginId">아이디</label>
            <input type="text"
                   id="loginId"
                   name="loginId"
                   value="${loginId != null ? loginId : ''}"
                   placeholder="아이디를 입력하세요"
                   required>
        </div>

        <div class="form-group">
            <label for="password">비밀번호</label>
            <input type="password"
                   id="password"
                   name="password"
                   placeholder="비밀번호를 입력하세요"
                   required>
        </div>

        <div class="form-group">
            <label for="passwordConfirm">비밀번호 확인</label>
            <input type="password"
                   id="passwordConfirm"
                   name="passwordConfirm"
                   placeholder="비밀번호를 다시 입력하세요"
                   required>
        </div>

        <button type="submit" class="submit-btn">회원가입</button>
    </form>
</div>

<script>
    function validateForm() {
        const password = document.getElementById('password').value;
        const passwordConfirm = document.getElementById('passwordConfirm').value;

        if (password !== passwordConfirm) {
            alert('비밀번호가 일치하지 않습니다.');
            return false;
        }

        return true;
    }
</script>
</body>
</html>
