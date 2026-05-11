<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Add New Student</title>
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
}

.form-container {
    max-width: 800px;
    margin: 50px auto;
    background-color: rgba(255, 255, 255, 0.85);
    padding: 30px;
    border-radius: 10px;
    box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);
    backdrop-filter: blur(4px);
    animation: fadeIn 1s ease-in-out;
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
select,
input[type="file"] {
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
select:focus,
input[type="file"]:focus {
    outline: none;
    border-color: var(--primary-blue);
    background-color: #e6f0ff;
}

.submit-btn {
    background-color: var(--primary-blue);
    color: white;
    border: none;
    padding: 12px;
    margin-top: 10px;
    width: 100%;
    border-radius: 8px;
    font-size: 16px;
    font-weight: bold;
    cursor: pointer;
    transition: background-color 0.3s ease;
}

.submit-btn:hover {
    background-color: var(--dark-purple);
}

@keyframes fadeIn {
    from { opacity: 0; transform: translateY(20px); }
    to { opacity: 1; transform: translateY(0); }
}

.error {
    color: red;
    margin-bottom: 10px;
}

.success-msg {
    color: green;
    margin-bottom: 10px;
}
    </style>
</head>
<body>
    <img src="images/logo.png" alt="Logo" class="header-logo">

<div class="form-container">
    <h2>Add New Student</h2>
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
        <form action="AddStudentServlet" method="post" enctype="multipart/form-data">
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

            <label for="photo">Photo:</label>
            <input type="file" name="photo" id="photo" accept="image/*">

            <label for="password">Password:</label>
            <input type="text" name="password" id="password">

            <button type="submit" class="submit-btn">Add Student</button>
        </form>
    </div>
</div>
</body>
</html>