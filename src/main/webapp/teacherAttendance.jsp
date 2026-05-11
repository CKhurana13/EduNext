<%@ page import="java.util.*, java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String t_id = (String) session.getAttribute("t_id");
    if (t_id == null) {
        response.sendRedirect("teacherLogin.jsp");
        return;
    }

    List<String> classes = new ArrayList<>();

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/teacher_web", "root", "vips");

        PreparedStatement ps = conn.prepareStatement("SELECT classes FROM teacher WHERE t_id = ?");
        ps.setString(1, t_id);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            String[] clsArr = rs.getString("classes").split(",");
            for (String cls : clsArr) {
                if (!cls.trim().isEmpty()) {
                    classes.add(cls.trim());
                }
            }
        }

        rs.close();
        ps.close();
        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
    }

    String selectedClass = request.getParameter("class_name");
    List<Map<String, String>> studentList = new ArrayList<>();

    if (selectedClass != null && !selectedClass.trim().isEmpty()) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/teacher_web", "root", "vips");

            PreparedStatement ps = conn.prepareStatement("SELECT s_id, s_name FROM student WHERE class_name = ?");
            ps.setString(1, selectedClass);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Map<String, String> student = new HashMap<>();
                student.put("s_id", rs.getString("s_id"));
                student.put("s_name", rs.getString("s_name"));
                studentList.add(student);
            }

            rs.close();
            ps.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Mark Attendance</title>
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
            background: repeating-linear-gradient(45deg, #e0e7ff 0, #e0e7ff 10px, #d1e0ff 10px,
                #d1e0ff 20px),
                repeating-linear-gradient(-45deg, #e0e7ff 0, #e0e7ff 10px, #d1e0ff 10px,
                #d1e0ff 20px);
            background-blend-mode: overlay;
            min-height: 100vh;
        }

        /* HEADER */
        .header {
            background: linear-gradient(to right, var(--primary-blue), var(--secondary-blue));
            color: var(--white);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px 25px;
            position: relative;
            z-index: 1;
        }

        .header-logo {
            height: 35px;
            max-width: 100px;
            border-radius: 5px;
            object-fit: contain;
            margin-right: 15px;
            transition: transform 0.3s ease;
        }

        .profile-dropdown {
            position: relative;
            display: inline-block;
            cursor: pointer;
        }

        .profile-circle {
            width: 40px;
            height: 40px;
            background-color: var(--primary-blue);
            color: var(--text-light);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 18px;
            margin-right: 5px;
            float: left;
            transition: all 0.3s ease;
        }

        .profile-circle:hover {
            background-color: var(--secondary-blue);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
        }

        .profile-name {
            color: var(--white);
            display: inline-block;
            vertical-align: middle;
            font-weight: 600;
            margin-left: 8px;
        }

        .dropdown-content {
            display: none;
            position: absolute;
            top: 100%;
            right: 0;
            background-color: rgba(255, 255, 255, 0.95);
            min-width: 160px;
            box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1);
            z-index: 999;
            border-radius: 4px;
            backdrop-filter: blur(4px);
        }

        .profile-dropdown:hover .dropdown-content {
            display: block;
        }

        .dropdown-content a {
            display: block;
            padding: 12px 16px;
            text-decoration: none;
            color: var(--text-dark);
            transition: all 0.3s ease;
        }

        .dropdown-content a:hover {
            background-color: var(--light-purple);
            color: var(--text-light);
        }

        .container {
            max-width: 1000px;
            margin: 40px auto;
            background: white;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 6px 18px rgba(0, 0, 0, 0.1);
        }

        h2 {
            text-align: center;
            color: var(--primary-blue);
            margin-bottom: 30px;
        }

        form {
            text-align: center;
            margin-bottom: 30px;
        }

        label {
            font-weight: bold;
            margin-right: 10px;
            color: var(--primary-blue);
        }

        select {
            padding: 8px 12px;
            margin-right: 15px;
            border-radius: 6px;
            border: 1px solid #ccc;
            font-size: 14px;
        }

        button {
            padding: 10px 20px;
            background-color: var(--primary-blue);
            color: white;
            border: none;
            border-radius: 6px;
            font-weight: bold;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        button:hover {
            background-color: var(--dark-purple);
        }

        .table-container {
            overflow-x: auto;
        }

        .styled-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 15px;
            text-align: center;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
        }
.logo {
            position: absolute;
            top: 20px;
            left: 20px;
            width: 100px;
            height: auto;
            z-index: 1000;
        }
        .styled-table th,
        .styled-table td {
            padding: 12px;
            border-bottom: 1px solid #ddd;
        }

        .styled-table thead {
            background-color: var(--primary-blue);
            color: white;
        }

        .styled-table tr:nth-child(even) {
            background-color: #f9f9f9;
        }

        .styled-table tr:hover {
            background: linear-gradient(to right, var(--light-purple), var(--dark-purple));
            color: white;
        }

        .no-data {
            text-align: center;
            font-size: 16px;
            color: #999;
            margin-top: 30px;
        }

        .success-msg {
            color: green;
            font-weight: bold;
            text-align: center;
            margin-bottom: 15px;
        }
    </style>
</head>
<body>
<img src="images/logo.png" alt="School Logo" class="logo">
    <div class="header">
        <div class="header-left">
            <img src="images/logo.jpeg" alt="Logo" class="header-logo">
            <h2>Teacher Dashboard</h2>
        </div>
        <div class="profile-dropdown">
            <div class="profile-circle">
                <% 
                    String t_name = (String) session.getAttribute("t_name");
                    out.print(t_name != null && t_name.length() > 0 ? t_name.charAt(0) : "T");
                %>
            </div>
            <span class="profile-name">
                <%= t_name != null ? t_name : "Teacher" %>
            </span>
            <div class="dropdown-content">
                <a href="LogoutServlet">Logout</a>
            </div>
        </div>
    </div>

    <div class="container">
        <h2>Mark Attendance</h2>

        <!-- Success Message -->
        <% if ("true".equals(request.getParameter("success"))) { %>
            <div class="success-msg">Attendance marked successfully!</div>
        <% } %>

        <!-- Class Selection -->
        <form method="get" action="AttendanceServlet">
            <label for="class_name">Select Class:</label>
            <select id="class_name" name="class_name" required>
                <option value="" disabled <%= (selectedClass == null) ? "selected" : "" %>>-- Select Class --</option>
                <% for (String cls : classes) { %>
                    <option value="<%= cls %>" <%= cls.equals(selectedClass) ? "selected" : "" %>><%= cls %></option>
                <% } %>
            </select>
            <button type="submit">Load Students</button>
        </form>

        <!-- Student Table -->
        <% if (studentList != null && !studentList.isEmpty()) { %>
            <form method="post" action="AttendanceServlet">
                <input type="hidden" name="class_name" value="<%= selectedClass %>"/>
                <div style="text-align: center; margin: 20px 0;">
                    <label for="attendance_date">Select Date:</label>
                    <input type="date" id="attendance_date" name="attendance_date" required style="margin-left: 10px;">
                </div>

                <div class="table-container">
                    <table class="styled-table">
                        <thead>
                            <tr>
                                <th>Student Id</th>
                                <th>Student Name</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                int i = 0;
                                for (Map<String, String> student : studentList) {
                            %>
                            <tr>
                                <td><%= student.get("s_id") %></td>
                                <td><%= student.get("s_name") %></td>
                                <td>
                                    <select name="status_<%= i %>" required>
                                        <option value="P" <%= "P".equals(request.getParameter("status_" + i)) ? "selected" : "" %>>P</option>
                                        <option value="A" <%= "A".equals(request.getParameter("status_" + i)) ? "selected" : "" %>>A</option>
                                        <option value="H" <%= "H".equals(request.getParameter("status_" + i)) ? "selected" : "" %>>H</option>
                                    </select>
                                    <input type="hidden" name="s_id_<%= i %>" value="<%= student.get("s_id") %>">
                                </td>
                            </tr>
                            <%
                                    i++;
                                }
                            %>
                        </tbody>
                    </table>
                </div>

                <div style="text-align: center; margin-top: 20px;">
                    <button type="submit">Submit Attendance</button>
                </div>
                <input type="hidden" name="count" value="<%= studentList.size() %>">
            </form>
        <% } else if (selectedClass != null && !selectedClass.trim().isEmpty()) { %>
            <div class="no-data">No students found for the selected class.</div>
        <% } %>
    </div>
</body>
</html>