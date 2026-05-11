<%@ page import="java.util.*, java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
String t_id = (String) session.getAttribute("t_id");
String teacherName = (String) session.getAttribute("username");

if (t_id == null) {
    response.sendRedirect("loginTeacher.jsp");
    return;
}

// Initialize schedule map and period map
Map<String, List<Map<String, String>>> scheduleMap = new HashMap<>();
Map<Integer, String> periodTimes = new HashMap<>();
Connection conn = null;
PreparedStatement ps = null;
ResultSet rs = null;

try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/teacher_web", "root", "vips");

    // Fetch period times
    String periodSql = "SELECT period_no, start_time, end_time FROM period_slots WHERE is_break = 0";
    ps = conn.prepareStatement(periodSql);
    rs = ps.executeQuery();
    while (rs.next()) {
        int periodNo = rs.getInt("period_no");
        String startTime = rs.getString("start_time");
        String endTime = rs.getString("end_time");
        periodTimes.put(periodNo, startTime + " - " + endTime);
    }

    // Query schedule for the teacher
    String sql = "SELECT s.sc_id, s.className, s.day, s.sub_id, s.t_id, s.period_no, sub.sub_name " +
                 "FROM schedule s " +
                 "LEFT JOIN subjects sub ON s.sub_id = sub.sub_id " +
                 "WHERE s.t_id = ?";
    ps = conn.prepareStatement(sql);
    ps.setString(1, t_id);
    rs = ps.executeQuery();

    // Map days to schedules
    while (rs.next()) {
        String day = rs.getString("day").substring(0, 1).toUpperCase() + rs.getString("day").substring(1).toLowerCase();
        Map<String, String> schedule = new HashMap<>();
        schedule.put("class_name", rs.getString("className"));
        schedule.put("subject_name", rs.getString("sub_name"));
        int periodNo = rs.getInt("period_no");
        schedule.put("time", periodTimes.getOrDefault(periodNo, "N/A"));

        scheduleMap.computeIfAbsent(day, k -> new ArrayList<>()).add(schedule);
    }

} catch (Exception e) {
    out.println("<script>console.error('Error fetching schedule: " + e.getMessage() + "');</script>");
    e.printStackTrace();
} finally {
    if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
    if (ps != null) try { ps.close(); } catch (SQLException ignored) {}
    if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
}
%>

<!DOCTYPE html>
<html>
<head>
<title>Weekly Schedule</title>
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

.header {
    background: linear-gradient(to right, var(--primary-blue), var(--secondary-blue));
    color: var(--white);
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 10px 20px;
    position: relative;
    z-index: 1;
    backdrop-filter: blur(4px);
    background-color: rgba(255, 255, 255, 0.8);
}

.header-logo {
    height: 35px;
    max-width: 100px;
    border-radius: 5px;
    object-fit: contain;
    margin-right: 15px;
    transition: transform 0.3s ease;
}

.header-logo:hover {
    transform: scale(1.1);
}

.header-left {
    display: flex;
    align-items: center;
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
    background-color: rgba(255, 255, 255, 0.9);
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
    max-width: 900px;
    margin: 50px auto;
    padding: 30px;
    background: rgba(255, 255, 255, 0.92);
    border-radius: 12px;
    box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);
    backdrop-filter: blur(6px);
}

h2 {
    text-align: center;
    color: #004d99;
    margin-bottom: 30px;
}

.day-tabs {
    display: flex;
    justify-content: center;
    flex-wrap: wrap;
    gap: 12px;
    margin-bottom: 25px;
}

.day-tabs button {
    padding: 10px 22px;
    background-color: #004d99;
    color: white;
    border: none;
    border-radius: 10px;
    font-weight: bold;
    font-size: 15px;
    transition: background-color 0.3s ease;
    cursor: pointer;
}

.day-tabs button:hover {
    background-color: #003366;
}

.day-content {
    margin-top: 20px;
}

.schedule-card {
    background-color: #f2f7ff;
    border-left: 5px solid #004d99;
    padding: 15px;
    margin-bottom: 15px;
    border-radius: 10px;
    box-shadow: 0px 1px 6px rgba(0, 0, 0, 0.1);
}

.top-row {
    display: flex;
    justify-content: space-between;
    margin-bottom: 8px;
    font-weight: bold;
}

.class-name {
    font-size: 16px;
    color: #333;
}

.time-slot {
    font-size: 14px;
    color: #555;
}

.subject-name {
    font-size: 15px;
    color: #555;
}
</style>
</head>
<body>

<div class="header bg-white bg-opacity-80 backdrop-blur-md shadow-md">
    <div class="header-left">
        <img src="images/logo.png" alt="Logo" class="header-logo">
    </div>
    <div class="profile-dropdown">
        <div class="flex items-center space-x-3">
            <div class="profile-circle">
                <span><%= (teacherName != null && !teacherName.isEmpty()) ? teacherName.substring(0, 1).toUpperCase() : "T" %></span>
            </div>
            <div class="profile-name"><%= (teacherName != null && !teacherName.isEmpty()) ? teacherName : t_id %></div>
        </div>
        <div class="dropdown-content">
            <a href="teacherProfile.jsp">View Profile</a> <a href="teacherLogout.jsp">Logout</a>
        </div>
    </div>
</div>

<div class="container">
    <h2>My Weekly Schedule</h2>

    <div class="day-tabs">
        <button onclick="showDay('Monday')">Monday</button>
        <button onclick="showDay('Tuesday')">Tuesday</button>
        <button onclick="showDay('Wednesday')">Wednesday</button>
        <button onclick="showDay('Thursday')">Thursday</button>
        <button onclick="showDay('Friday')">Friday</button>
    </div>

    <%
    String[] days = {"Monday", "Tuesday", "Wednesday", "Thursday", "Friday"};
    for (String day : days) {
    %>
    <div class="day-content" id="<%=day%>" style="display: none;">
        <%
        List<Map<String, String>> schedules = scheduleMap.getOrDefault(day, new ArrayList<>());
        if (!schedules.isEmpty()) {
            for (Map<String, String> s : schedules) {
        %>
        <div class="schedule-card">
            <div class="top-row">
                <div class="class-name"><%=s.get("class_name")%></div>
                <div class="time-slot"><%=s.get("time")%></div>
            </div>
            <div class="subject-name"><%=s.get("subject_name")%></div>
        </div>
        <%
            }
        } else {
        %>
        <p style="color: #888;">
            No schedule for <%=day%>.
        </p>
        <%
        }
        %>
    </div>
    <%
    }
    %>

</div>

<script>
    function showDay(dayId) {
        const days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"];
        days.forEach(d => {
            document.getElementById(d).style.display = "none";
        });
        document.getElementById(dayId).style.display = "block";
    }

    // Show Monday on load
    window.onload = function () {
        showDay("Monday");
    };
</script>

</body>
</html>