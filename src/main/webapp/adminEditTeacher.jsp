```jsp
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, java.util.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Teacher</title>
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
        <h2 class="mb-4">🏫 Edit Teacher</h2>
        <%
            String t_id = request.getParameter("t_id");
            String t_name = "";
            String address = "";
            String phone = "";
            String t_email = "";
            String subjects = "";
            String classes = "";
            String qualifications = "";
            String password = "";
            String doj = "";
            String dob = "";
            boolean teacherFound = false;

            if (t_id != null && !t_id.isEmpty()) {
                Connection conn = null;
                PreparedStatement pstmt = null;
                ResultSet rs = null;
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/teacher_web", "root", "vips");
                    pstmt = conn.prepareStatement("SELECT t_name, address, phone, t_email, subjects, classes, qualifications, password, doj, dob FROM teacher WHERE t_id = ?");
                    pstmt.setString(1, t_id);
                    rs = pstmt.executeQuery();
                    if (rs.next()) {
                        teacherFound = true;
                        t_name = rs.getString("t_name") != null ? rs.getString("t_name") : "";
                        address = rs.getString("address") != null ? rs.getString("address") : "";
                        phone = rs.getString("phone") != null ? rs.getString("phone") : "";
                        t_email = rs.getString("t_email") != null ? rs.getString("t_email") : "";
                        subjects = rs.getString("subjects") != null ? rs.getString("subjects") : "";
                        classes = rs.getString("classes") != null ? rs.getString("classes") : "";
                        qualifications = rs.getString("qualifications") != null ? rs.getString("qualifications") : "";
                        password = rs.getString("password") != null ? rs.getString("password") : "";
                        doj = rs.getString("doj") != null ? rs.getString("doj") : "";
                        dob = rs.getString("dob") != null ? rs.getString("dob") : "";
                    }
                    rs.close();
                    pstmt.close();
                    conn.close();
                } catch (Exception e) {
                    e.printStackTrace();
                    out.println("<p class='error'>Error fetching teacher details: " + e.getMessage() + "</p>");
                }
            }
        %>

        <% if ("error".equals(request.getParameter("status"))) { %>
            <p class="error">Error updating teacher. Please try again.</p>
            <% String message = request.getParameter("message");
               if (message != null && !message.isEmpty()) { %>
                <p class="error"><%= message %></p>
            <% } %>
        <% } else if ("success".equals(request.getParameter("status"))) { %>
            <p class="success-msg">Teacher updated successfully!</p>
        <% } %>

        <div class="form-box">
            <form action="adminEditTeacher.jsp" method="get">
                <label for="t_id">Teacher ID:</label>
                <input type="text" name="t_id" id="t_id" value="<%= t_id != null ? t_id : "" %>" required>
                <button type="submit" class="submit-btn">Search Teacher</button>
            </form>

            <% if (t_id != null && !t_id.isEmpty() && !teacherFound) { %>
                <p class="error">Teacher with ID <%= t_id %> not found.</p>
            <% } %>

            <% if (teacherFound) { %>
                <form action="EditTeacherServlet" method="post" class="mt-4">
                    <label for="t_id_edit">Teacher ID:</label>
                    <input type="text" name="t_id" id="t_id_edit" value="<%= t_id %>" required>

                    <label for="t_name">Teacher Name:</label>
                    <input type="text" name="t_name" id="t_name" value="<%= t_name %>" required>

                    <label for="address">Address:</label>
                    <input type="text" name="address" id="address" value="<%= address %>">

                    <label for="phone">Phone Number:</label>
                    <input type="tel" name="phone" id="phone" value="<%= phone %>" pattern="[0-9]{10}" placeholder="10 digits">

                    <label for="t_email">Email:</label>
                    <input type="email" name="t_email" id="t_email" value="<%= t_email %>">

                    <label for="subjects">Subjects:</label>
                    <input type="text" name="subjects" id="subjects" value="<%= subjects %>" placeholder="e.g., Mathematics,Physics">

                    <label for="classes">Classes:</label>
                    <input type="text" name="classes" id="classes" value="<%= classes %>" placeholder="e.g., 12A,12B">

                    <label for="qualifications">Qualifications:</label>
                    <input type="text" name="qualifications" id="qualifications" value="<%= qualifications %>" placeholder="e.g., M.Sc. Mathematics">

                    <label for="password">Password:</label>
                    <input type="text" name="password" id="password" value="<%= password %>">

                    <label for="doj">Date of Joining:</label>
                    <input type="date" name="doj" id="doj" value="<%= doj %>">

                    <label for="dob">Date of Birth:</label>
                    <input type="date" name="dob" id="dob" value="<%= dob %>">

                    <button type="submit" class="submit-btn">Update Teacher</button>
                </form>
            <% } %>
            <div class="text-center">
                <% if (teacherFound) { %>
                    <a href="adminDashboard.jsp" class="btn btn-back">Back to Admin Dashboard</a>
                <% } else { %>
                    <a href="adminViewTeacher.jsp" class="btn btn-back">Back to View Teachers</a>
                <% } %>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
```