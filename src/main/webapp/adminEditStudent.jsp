```jsp
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, java.util.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Student</title>
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
            max-width: 700px;
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
        <h2 class="mb-4">🏫 Edit Student</h2>
        <%
            String s_id = request.getParameter("s_id");
            String s_name = "";
            String f_name = "";
            String m_name = "";
            String s_email = "";
            String f_email = "";
            String m_email = "";
            String address = "";
            String dob = "";
            String phone = "";
            String class_name = "";
            String doa = "";
            String photo = "";
            String password = "";
            String class_code = "";
            boolean studentFound = false;

            if (s_id != null && !s_id.isEmpty()) {
                Connection conn = null;
                PreparedStatement pstmt = null;
                ResultSet rs = null;
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/teacher_web", "root", "vips");
                    pstmt = conn.prepareStatement("SELECT s_name, f_name, m_name, s_email, f_email, m_email, address, dob, phone, class_name, doa, photo, password, class_code FROM student WHERE s_id = ?");
                    pstmt.setString(1, s_id);
                    rs = pstmt.executeQuery();
                    if (rs.next()) {
                        studentFound = true;
                        s_name = rs.getString("s_name") != null ? rs.getString("s_name") : "";
                        f_name = rs.getString("f_name") != null ? rs.getString("f_name") : "";
                        m_name = rs.getString("m_name") != null ? rs.getString("m_name") : "";
                        s_email = rs.getString("s_email") != null ? rs.getString("s_email") : "";
                        f_email = rs.getString("f_email") != null ? rs.getString("f_email") : "";
                        m_email = rs.getString("m_email") != null ? rs.getString("m_email") : "";
                        address = rs.getString("address") != null ? rs.getString("address") : "";
                        dob = rs.getString("dob") != null ? rs.getString("dob") : "";
                        phone = rs.getString("phone") != null ? rs.getString("phone") : "";
                        class_name = rs.getString("class_name") != null ? rs.getString("class_name") : "";
                        doa = rs.getString("doa") != null ? rs.getString("doa") : "";
                        photo = rs.getString("photo") != null ? rs.getString("photo") : "";
                        password = rs.getString("password") != null ? rs.getString("password") : "";
                        class_code = rs.getString("class_code") != null ? rs.getString("class_code") : "";
                    }
                    rs.close();
                    pstmt.close();
                    conn.close();
                } catch (Exception e) {
                    e.printStackTrace();
                    out.println("<p class='error'>Error fetching student details: " + e.getMessage() + "</p>");
                }
            }
        %>

        <% if ("error".equals(request.getParameter("status"))) { %>
            <p class="error">Error updating student. Please try again.</p>
            <% String message = request.getParameter("message");
               if (message != null && !message.isEmpty()) { %>
                <p class="error"><%= message %></p>
            <% } %>
        <% } else if ("success".equals(request.getParameter("status"))) { %>
            <p class="success-msg">Student updated successfully!</p>
        <% } %>

        <div class="form-box">
            <form action="adminEditStudent.jsp" method="get">
                <label for="s_id">Student ID:</label>
                <input type="text" name="s_id" id="s_id" value="<%= s_id != null ? s_id : "" %>" required>
                <button type="submit" class="submit-btn">Search Student</button>
            </form>

            <% if (s_id != null && !s_id.isEmpty() && !studentFound) { %>
                <p class="error">Student with ID <%= s_id %> not found.</p>
            <% } %>

            <% if (studentFound) { %>
                <form action="EditStudentServlet" method="post" class="mt-4">
                    <label for="s_id_edit">Student ID:</label>
                    <input type="text" name="s_id" id="s_id_edit" value="<%= s_id %>" required>

                    <label for="s_name">Student Name:</label>
                    <input type="text" name="s_name" id="s_name" value="<%= s_name %>" required>

                    <label for="f_name">Father's Name:</label>
                    <input type="text" name="f_name" id="f_name" value="<%= f_name %>">

                    <label for="m_name">Mother's Name:</label>
                    <input type="text" name="m_name" id="m_name" value="<%= m_name %>">

                    <label for="s_email">Student Email:</label>
                    <input type="email" name="s_email" id="s_email" value="<%= s_email %>">

                    <label for="f_email">Father's Email:</label>
                    <input type="email" name="f_email" id="f_email" value="<%= f_email %>">

                    <label for="m_email">Mother's Email:</label>
                    <input type="email" name="m_email" id="m_email" value="<%= m_email %>">

                    <label for="address">Address:</label>
                    <input type="text" name="address" id="address" value="<%= address %>">

                    <label for="dob">Date of Birth:</label>
                    <input type="date" name="dob" id="dob" value="<%= dob %>">

                    <label for="phone">Phone Number:</label>
                    <input type="tel" name="phone" id="phone" value="<%= phone %>" pattern="[0-9]{10}" placeholder="10 digits">

                    <label for="class_name">Class Name:</label>
                    <input type="text" name="class_name" id="class_name" value="<%= class_name %>">

                    <label for="doa">Date of Admission:</label>
                    <input type="date" name="doa" id="doa" value="<%= doa %>">

                    <label for="password">Password:</label>
                    <input type="text" name="password" id="password" value="<%= password %>">

                    <label for="class_code">Class Code:</label>
                    <input type="text" name="class_code" id="class_code" value="<%= class_code %>">

                    <label for="photo">Photo URL:</label>
                    <input type="text" name="photo" id="photo" value="<%= photo %>" placeholder="e.g., https://example.com/photo.jpg">

                    <button type="submit" class="submit-btn">Update Student</button>
                </form>
            <% } %>
            <div class="text-center">
                <% if (studentFound) { %>
                    <a href="adminDashboard.jsp" class="btn btn-back">Back to Admin Dashboard</a>
                <% } else { %>
                    <a href="adminViewStudent.jsp" class="btn btn-back">Back to View Students</a>
                <% } %>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
```