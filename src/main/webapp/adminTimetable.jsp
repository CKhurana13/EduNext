<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, java.util.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Class Timetable</title>
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
        .container {
            background-color: rgba(255, 255, 255, 0.9);
            border-radius: 20px;
            padding: 40px;
            margin-top: 100px;
            margin-bottom: 50px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            width: 700px;
            margin-left: auto;
            margin-right: auto;
            text-align: center;
            animation: fadeIn 1s ease-in-out;
        }
        h2 {
            color: var(--darker-purple);
            font-weight: bold;
        }
        .table {
            background: rgba(230, 240, 255, 0.9);
            border-radius: 12px;
            overflow: hidden;
        }
        .table th {
            background-color: var(--dark-purple);
            color: var(--white);
            font-weight: 600;
        }
        .table td {
            background-color: var(--white);
            color: var(--text-dark);
        }
        .day-divider {
            background-color: var(--light-purple);
            color: var(--white);
            font-weight: bold;
            text-align: center;
        }
        .btn-add {
            background-color: var(--dark-purple);
            border-color: var(--dark-purple);
            border-radius: 50px;
            padding: 10px 20px;
            font-size: 16px;
            font-weight: 600;
            color: var(--white);
            margin-bottom: 20px;
        }
        .btn-add:hover {
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
        select {
            width: 200px;
            padding: 10px;
            margin-bottom: 20px;
            border: 2px solid #cce0ff;
            border-radius: 8px;
            font-size: 14px;
            background-color: #f2f7ff;
        }
        select:focus {
            outline: none;
            border-color: var(--light-purple);
            background-color: #e6f0ff;
            box-shadow: 0 0 5px 2px #9ab3f5;
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>
<body>
    <img src="images/logo.png" alt="School Logo" class="logo">

    <div class="container">
        <h2 class="mb-4">📅 Manage Class Timetable</h2>
        <form method="get" action="adminTimetable.jsp">
            <label for="class_name" class="d-inline-block mb-2">Select Class:</label>
            <select name="class_name" id="class_name" onchange="this.form.submit()" required>
                <option value="">Select Class</option>
                <%
                    Connection conn = null;
                    PreparedStatement pstmt = null;
                    ResultSet rs = null;
                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/teacher_web", "root", "vips");
                        pstmt = conn.prepareStatement("SELECT DISTINCT class_name FROM timetable ORDER BY class_name");
                        rs = pstmt.executeQuery();
                        String selectedClass = request.getParameter("class_name");
                        while (rs.next()) {
                            String className = rs.getString("class_name");
                            String selected = className.equals(selectedClass) ? "selected" : "";
                %>
                <option value="<%= className %>" <%= selected %>><%= className %></option>
                <% } %>
                <%
                    rs.close();
                    pstmt.close();
                    } catch (Exception e) {
                        out.println("<p class='error'>Error fetching classes: " + e.getMessage() + "</p>");
                    }
                %>
            </select>
        </form>

        <%
            String class_name = request.getParameter("class_name");
            if (class_name != null && !class_name.isEmpty()) {
                try {
                    pstmt = conn.prepareStatement(
                        "SELECT t.timetable_id, t.class_name, t.day, sub.sub_name, tch.t_name, t.period_no, p.start_time, p.end_time " +
                        "FROM timetable t " +
                        "JOIN subjects sub ON t.sub_id = sub.sub_id " +
                        "JOIN teacher tch ON t.t_id = tch.t_id " +
                        "JOIN period_slots p ON t.period_no = p.period_no " +
                        "WHERE t.class_name = ? AND t.day != 'saturday' " +
                        "ORDER BY t.day, t.period_no"
                    );
                    pstmt.setString(1, class_name);
                    rs = pstmt.executeQuery();
                    String currentDay = "";
        %>
        <a href="addTimetable.jsp?class_name=<%= java.net.URLEncoder.encode(class_name, "UTF-8") %>" class="btn btn-add">Add New Timetable Entry</a>
        <table class="table table-bordered table-striped">
            <thead>
                <tr>
                    <th>Timetable ID</th>
                    <th>Class</th>
                    <th>Day</th>
                    <th>Subject</th>
                    <th>Teacher</th>
                    <th>Period</th>
                    <th>Time</th>
                </tr>
            </thead>
            <tbody>
                <% 
                    boolean hasRecords = false;
                    while (rs.next()) {
                        hasRecords = true;
                        String day = rs.getString("day");
                        if (!day.equals(currentDay)) {
                            if (!currentDay.isEmpty()) {
                %>
                <tr><td colspan="7" class="day-divider"></td></tr>
                <% 
                            }
                %>
                <tr><td colspan="7" class="day-divider"><%= day.substring(0, 1).toUpperCase() + day.substring(1) %></td></tr>
                <%
                            currentDay = day;
                        }
                %>
                <tr>
                    <td><%= rs.getInt("timetable_id") %></td>
                    <td><%= rs.getString("class_name") %></td>
                    <td><%= rs.getString("day").substring(0, 1).toUpperCase() + rs.getString("day").substring(1) %></td>
                    <td><%= rs.getString("sub_name") %></td>
                    <td><%= rs.getString("t_name") %></td>
                    <td><%= rs.getInt("period_no") %></td>
                    <td><%= rs.getString("start_time") %> - <%= rs.getString("end_time") %></td>
                </tr>
                <% } %>
                <% if (hasRecords && !currentDay.isEmpty()) { %>
                <tr><td colspan="7" class="day-divider"></td></tr>
                <% } %>
                <% if (!hasRecords) { %>
                <tr>
                    <td colspan="7" class="text-center">No timetable entries found for this class.</td>
                </tr>
                <% } %>
            </tbody>
        </table>
        <%
                    rs.close();
                    pstmt.close();
                } catch (Exception e) {
                    out.println("<p class='error'>Error fetching timetable: " + e.getMessage() + "</p>");
                }
            } else {
        %>
        <p class="text-muted">Please select a class to view its timetable.</p>
        <%
            }
            if (conn != null) conn.close();
        %>
        <div class="text-center">
            <a href="classSection.jsp" class="btn btn-back">Back to Class Section</a>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>