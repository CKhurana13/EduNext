
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add New Student</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-pink: #ffccd5;
            --secondary-pink: #ffb3c1;
            --light-purple: #b388eb;
            --dark-purple: #8a56d6;
            --darker-purple: #5e3a9b;
            --white: #ffffff;
            --light-bg: #f0f4f8;
            --text-dark: #333333;
            --text-light: #f0f0f0;
        }

        body {
            background-color: var(--light-bg);
            background: repeating-linear-gradient(45deg, var(--primary-pink) 0, var(--primary-pink) 10px, var(--secondary-pink) 10px, var(--secondary-pink) 20px),
                        repeating-linear-gradient(-45deg, var(--primary-pink) 0, var(--primary-pink) 10px, var(--secondary-pink) 10px, var(--secondary-pink) 20px);
            background-blend-mode: overlay;
            font-family: 'Poppins', sans-serif;
            position: relative;
            margin: 0;
            padding-bottom: 50px;
        }
        .logo {
            position: absolute;
            top: 20px;
            left: 20px;
            width: 100px;
            height: auto;
            z-index: 1000;
        }
        .form-container {
            background-color: rgba(255, 255, 255, 0.9);
            border-radius: 20px;
            padding: 40px;
            margin-top: 100px;
            margin-bottom: 50px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            max-width: 700px; /* Increased from 800px to 1200px */
            margin-left: auto;
            margin-right: auto;
            text-align: center;
            animation: fadeIn 1s ease-in-out;
        }
        h2 {
            color: var(--darker-purple);
            font-weight: bold;
        }
        .form-box {
            background: rgba(230, 240, 255, 0.9);
            padding: 25px;
            border-radius: 12px;
        }
        label {
            font-weight: bold;
            color: var(--dark-purple);
            display: block;
            margin-top: 15px;
            margin-bottom: 5px;
            font-size: 16px;
        }
        input[type="text"],
        input[type="email"],
        input[type="date"],
        input[type="tel"],
        select {
            width: 100%;
            padding: 10px;
            margin-bottom: 20px;
            border: 2px solid #cce0ff;
            border-radius: 8px;
            font-size: 14px;
            background-color: #f2f7ff;
            box-sizing: border-box;
        }
        input[type="text"]:focus,
        input[type="email"]:focus,
        input[type="date"]:focus,
        input[type="tel"]:focus,
        select:focus {
            outline: none;
            border-color: var(--light-purple);
            background-color: #e6f0ff;
            box-shadow: 0 0 5px 2px #9ab3f5;
        }
        .submit-btn {
            background-color: var(--dark-purple);
            border-color: var(--dark-purple);
            border-radius: 50px;
            padding: 10px 20px;
            font-size: 16px;
            font-weight: 600;
            color: var(--white);
            width: 100%;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }
        .submit-btn:hover {
            background-color: var(--secondary-pink);
        }
        .btn-back {
            background-color: var(--light-purple);
            border-color: var(--light-purple);
            border-radius: 50px;
            padding: 10px 20px;
            font-size: 16px;
            font-weight: 600;
            color: var(--white);
            text-decoration: none;
            display: inline-block;
            margin-top: 10px;
        }
        .btn-back:hover {
            background-color: var(--secondary-pink);
        }
        .error {
            color: red;
            margin-bottom: 10px;
            font-size: 14px;
        }
        .success-msg {
            color: green;
            margin-bottom: 10px;
            font-size: 14px;
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>
<body>
    <img src="images/logo.png" alt="School Logo" class="logo">

    <div class="form-container">
        <h2 class="mb-4">🏫 Add New Student</h2>
        <% if ("error".equals(request.getParameter("status"))) { %>
            <p class="error">Error adding student. Please try again.</p>
            <% String message = request.getParameter("message");
               if (message != null && !message.isEmpty()) { %>
                <p class="error"><%= message %></p>
            <% } %>
        <% } else if ("success".equals(request.getParameter("status"))) { %>
            <p class="success-msg">Student added successfully!</p>
        <% } %>

        <div class="form-box">
            <form action="AddStudentServlet" method="post">
                <label for="s_id">Student ID:</label>
                <input type="text" name="s_id" id="s_id" required>

                <label for="s_name">Student Name:</label>
                <input type="text" name="s_name" id="s_name" required>

                <label for="f_name">Father's Name:</label>
                <input type="text" name="f_name" id="f_name">

                <label for="m_name">Mother's Name:</label>
                <input type="text" name="m_name" id="m_name">

                <label for="s_email">Student Email:</label>
                <input type="email" name="s_email" id="s_email">

                <label for="f_email">Father's Email:</label>
                <input type="email" name="f_email" id="f_email">

                <label for="m_email">Mother's Email:</label>
                <input type="email" name="m_email" id="m_email">

                <label for="address">Address:</label>
                <input type="text" name="address" id="address">

                <label for="dob">Date of Birth:</label>
                <input type="date" name="dob" id="dob">

                <label for="phone">Phone Number:</label>
                <input type="tel" name="phone" id="phone" pattern="[0-9]{10}" placeholder="10 digits">

                <label for="class_name">Class Name:</label>
                <input type="text" name="class_name" id="class_name">

                <label for="doa">Date of Admission:</label>
                <input type="date" name="doa" id="doa">

                <label for="password">Password:</label>
                <input type="text" name="password" id="password">

                <label for="class_code">Class Code:</label>
                <input type="text" name="class_code" id="class_code">

                <button type="submit" class="submit-btn">Add Student</button>
            </form>
            <div class="text-center">
                <a href="adminDashboard.jsp" class="btn btn-back">Back to Admin Dashboard</a>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
