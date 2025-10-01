<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>회원가입 완료</title>
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
            box-shadow: 0 2px 20px rgba(0,0,0,0.1);
            text-align: center;
            max-width: 400px;
        }

        .success-icon {
            width: 80px;
            height: 80px;
            margin: 0 auto 20px;
            background-color: #4CAF50;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 40px;
            color: white;
        }

        h2 {
            color: #333;
            margin-bottom: 15px;
            font-size: 24px;
        }

        p {
            color: #666;
            margin-bottom: 30px;
            line-height: 1.6;
        }

        .button-group {
            display: flex;
            gap: 10px;
            justify-content: center;
        }

        a {
            display: inline-block;
            padding: 12px 30px;
            background-color: #4CAF50;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            transition: background-color 0.3s;
        }

        a:hover {
            background-color: #45a049;
        }

        a.secondary {
            background-color: #757575;
        }

        a.secondary:hover {
            background-color: #616161;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="success-icon">✓</div>
        <h2>회원가입 완료</h2>
        <p>
            회원가입이 성공적으로 완료되었습니다.<br>
            로그인 후 서비스를 이용해주세요.
        </p>
        <div class="button-group">
            <a href="${pageContext.request.contextPath}/login">로그인</a>
            <a href="${pageContext.request.contextPath}/" class="secondary">메인으로</a>
        </div>
    </div>
</body>
</html>

