<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Insert Circular</title>
    <link href="https://fonts.googleapis.com/css2?family=Lato&display=swap" rel="stylesheet">
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
            margin: 0;
            font-family: 'Lato', sans-serif;
            background-color: var(--light-bg);
            background: repeating-linear-gradient(45deg, #e0e7ff 0, #e0e7ff 10px, #d1e0ff 10px, #d1e0ff 20px),
                        repeating-linear-gradient(-45deg, #e0e7ff 0, #e0e7ff 10px, #d1e0ff 10px, #d1e0ff 20px);
            background-blend-mode: overlay;
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .circular-container {
            max-width: 600px;
            margin: 60px auto;
            padding: 40px;
            background-color: var(--white);
            border-radius: 12px;
            box-shadow: 0 0 15px rgba(0,0,0,0.1);
            backdrop-filter: blur(4px);
            animation: fadeIn 0.7s ease-in;
        }

        .circular-container h2 {
            text-align: center;
            color: var(--secondary-blue);
            margin-bottom: 30px;
            font-size: 28px;
        }

        .circular-form {
            display: flex;
            flex-direction: column;
            gap: 18px;
            max-width: 600px;
            margin: 0 auto;
            font-size: 16px;
        }

        .circular-form label {
            font-weight: 600;
            color: #4d4d4d;
        }

        .circular-form input[type="text"],
        .circular-form input[type="date"],
        .circular-form textarea {
            padding: 10px 14px;
            border-radius: 8px;
            border: 1px solid #ccc;
            background-color: #f8f9ff;
            font-family: 'Lato', sans-serif;
            width: 100%;
            box-sizing: border-box;
            font-size: 15px;
            transition: border-color 0.3s ease;
        }

        .circular-form input:focus,
        .circular-form textarea:focus {
            outline: none;
            border-color: #6b8cff;
        }

        .circular-form textarea {
            resize: vertical;
        }
        .logo {
            position: absolute;
            top: 20px;
            left: 20px;
            width: 100px;
            height: auto;
            z-index: 1000;
        }
        .circular-form .publish-btn {
            align-self: center;
            width: fit-content;
            padding: 12px 24px;
            font-size: 16px;
            background-color: #6b8cff;
            color: white;
            border: none;
            border-radius: 50px;
            cursor: pointer;
            font-weight: bold;
            transition: background-color 0.3s ease;
        }

        .circular-form .publish-btn:hover {
            background-color: #4d6cfa;
        }

        .success-message {
            margin-top: 20px;
            padding: 15px;
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
            border-radius: 8px;
            text-align: center;
            font-weight: bold;
            font-size: 15px;
        }

        .error-message {
            margin-top: 20px;
            padding: 15px;
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
            border-radius: 8px;
            text-align: center;
            font-weight: bold;
            font-size: 15px;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>
<body>
<img src="images/logo.png" alt="School Logo" class="logo" width="120px" height=auto>
    <div class="circular-container">
        <h2>Insert Circular</h2>
        <% if (request.getAttribute("success") != null) { %>
            <% if (((String) request.getAttribute("success")).startsWith("Circular inserted") || ((String) request.getAttribute("success")).startsWith("Success")) { %>
                <div class="success-message"><%= request.getAttribute("success") %></div>
            <% } else { %>
                <div class="error-message"><%= request.getAttribute("success") %></div>
            <% } %>
        <% } %>
        <form action="circular" method="post" class="circular-form">
            <div>
                <label for="title">Title:</label>
                <input type="text" id="title" name="title" required>
            </div>
            <div>
                <label for="description">Description:</label>
                <textarea id="description" name="description" rows="4" required></textarea>
            </div>
            <div>
                <label for="issueDate">Issue Date:</label>
                <input type="date" id="issueDate" name="issueDate" required>
            </div>
            <button type="submit" class="publish-btn">Submit</button>
        </form>
    </div>
</body>
</html>