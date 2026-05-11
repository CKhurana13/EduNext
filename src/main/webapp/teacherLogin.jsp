<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Teacher Login</title>
    <link href="https://fonts.googleapis.com/css2?family=Lato:wght@400;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
    <style>
        @charset "UTF-8";

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
            font-family: 'Lato', sans-serif;
            background-color: var(--light-bg);
            background: repeating-linear-gradient(45deg, #e0e7ff 0, #e0e7ff 10px, #d1e0ff 10px, #d1e0ff 20px),
                        repeating-linear-gradient(-45deg, #e0e7ff 0, #e0e7ff 10px, #d1e0ff 10px, #d1e0ff 20px);
            background-blend-mode: overlay;
            margin: 0;
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .login-container {
            max-width: 900px;
            margin: 20px;
            background-color: rgba(255, 255, 255, 0.8);
            border-radius: 10px;
            box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);
            backdrop-filter: blur(4px);
            display: flex;
            flex-direction: row;
            overflow: hidden;
            animation: fadeIn 1s ease-in-out;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .left-panel {
            background: linear-gradient(to bottom, var(--primary-blue), var(--dark-purple));
            padding: 40px;
            flex: 1;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            text-align: center;
            color: var(--text-light);
        }

        .left-panel img {
            width: 70%;
            max-width: 220px;
            border-radius: 12px;
            box-shadow: 0 0 25px rgba(0, 0, 0, 0.2);
            margin-bottom: 20px;
        }

        .right-panel {
            flex: 1;
            padding: 20px;
        }

        .right-panel h2 {
            color: var(--primary-blue);
            margin-bottom: 20px;
            text-align: center;
        }

        form label {
            display: block;
            margin: 10px 0 5px;
            font-weight: bold;
            color: var(--text-dark);
        }

        form input {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 8px;
            margin-bottom: 15px;
            font-size: 14px;
            outline: none;
            transition: border 0.3s ease;
        }

        form input:focus {
            border: 1px solid var(--primary-blue);
            box-shadow: 0 0 6px rgba(107, 140, 255, 0.3);
        }

        button {
            width: 100%;
            background-color: var(--primary-blue);
            color: white;
            padding: 12px;
            border: none;
            border-radius: 12px;
            font-weight: bold;
            font-size: 15px;
            cursor: pointer;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            transition: background-color 0.3s ease;
        }

        button:hover {
            background-color: var(--dark-purple);
        }

        .error-message {
            color: red;
            text-align: center;
            margin-bottom: 10px;
            font-size: 13px;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <div class="left-panel bg-blue-50 p-8 flex flex-col justify-center items-center text-center md:w-1/2">
            <img src="T/images/login.jpg" alt="Teacher Illustration" class="w-2/3 max-w-xs mb-6">
            <h2 class="text-2xl font-bold text-black-800 mb-4">Welcome to the Teacher Portal</h2>
            <p class="text-black-600">Manage classes, upload homework, track performance & communicate easily.</p>
        </div>
        <div class="right-panel p-8 md:w-1/2">
            <form action="TeacherLoginServlet" method="post" class="login-form space-y-6">
                <h2 class="text-2xl font-bold text-gray-800 text-center">Teacher Login</h2>

                <%
                    String error = request.getParameter("error");
                    if ("invalid".equals(error)) {
                %>
                    <p class="error-message">❌ Invalid ID or Password</p>
                <%
                    } else if ("server".equals(error)) {
                %>
                    <p class="error-message">⚠ Internal Server Error. Try again later.</p>
                <%
                    }
                %>

                <div>
                    <label for="teacherId" class="block text-sm font-medium text-gray-700">Teacher ID</label>
                    <input type="text" id="teacherId" name="t_id" class="mt-1 p-3 w-full border rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500" required />
                </div>
                <div>
                    <label for="password" class="block text-sm font-medium text-gray-700">Password</label>
                    <input type="password" id="password" name="password" class="mt-1 p-3 w-full border rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500" required />
                </div>
                <button type="submit" class="w-full bg-blue-600 text-white p-3 rounded-md hover:bg-blue-700 transition duration-200 font-semibold">Login</button>
            </form>
        </div>
    </div>
</body>
</html>