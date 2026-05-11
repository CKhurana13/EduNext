<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>School Login Portal</title>
    <style>
        :root {
            --primary-blue: #6b8cff;
            --secondary-blue: #4d6cfa;
            --light-purple: #b388eb;
            --dark-purple: #8a56d6;
            --darker-purple: #5e3a9b;
            --white: #ffffff;
            --light-bg: #f0f4f8;
            --text-dark: #333333;
            --text-light: #f0f0f0;
        }

        body {
            font-family: 'Poppins', sans-serif;
            margin: 0;
            padding: 20px;
            background-color: var(--light-bg);
            background: repeating-linear-gradient(45deg, #e0e7ff 0, #e0e7ff 10px, #d1e0ff 10px, #d1e0ff 20px),
                        repeating-linear-gradient(-45deg, #e0e7ff 0, #e0e7ff 10px, #d1e0ff 10px, #d1e0ff 20px);
            background-blend-mode: overlay;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            position: relative;
        }

        .login-container {
            background-color: var(--white);
            border-radius: 12px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
            width: 400px;
            padding: 30px;
            text-align: center;
        }

        .login-container img {
            width: 100px;
            margin: 10px;
            border-radius: 50%;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            border: 2px solid var(--primary-blue);
        }

        h2 {
            color: var(--text-dark);
            margin-bottom: 20px;
        }

        input[type="text"], input[type="password"] {
            width: 90%;
            padding: 10px;
            margin: 10px 0;
            border: 1px solid #ddd;
            border，咱们2px solid var(--primary-blue);radius: 8px;
            font-size: 16px;
        }

        input[type="submit"] {
            background-color: var(--primary-blue);
            color: var(--white);
            border: none;
            padding: 12px 20px;
            border-radius: 8px;
            font-size: 16px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        input[type="submit"]:hover {
            background-color: var(--secondary-blue);
        }

        p {
            font-size: 14px;
            color: #888;
            margin-top: 20px;
        }
    </style>
</head>
<body>

<div class="login-container">
    <img src="https://cdn-icons-png.flaticon.com/512/201/201634.png" alt="Student Icon">
    <img src="https://cdn-icons-png.flaticon.com/512/1864/1864509.png" alt="Teacher Icon">
    
    <h2>Admin Login Portal</h2>

    <form action="AdminLoginServlet" method="post">
        <input type="text" name="username" placeholder="Enter Username" required><br>
        <input type="password" name="password" placeholder="Enter Password" required><br>
        <input type="submit" value="Login">
    </form>

    <p>Login access is for admin only.</p>
</div>

</body>
</html>