<%@ page import="java.util.*, java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%
    // Debug session attributes
    StringBuilder attrLog = new StringBuilder();
    Enumeration<String> sessionAttributes = session.getAttributeNames();
    while (sessionAttributes.hasMoreElements()) {
        String attr = sessionAttributes.nextElement();
        attrLog.append(attr).append("=").append(session.getAttribute(attr)).append(", ");
    }
    out.println("<script>console.log('Session attributes: " + attrLog.toString() + "');</script>");

    String teacherId = (String) session.getAttribute("t_id");
    String teacherName = (String) session.getAttribute("t_name");

    if (teacherId == null || teacherName == null) {
        out.println("<script>console.error('Missing session attributes: t_id=" + teacherId + ", t_name=" + teacherName + "');</script>");
        response.sendRedirect("teacherLogin.jsp?error=unauthorized");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Student Report</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Lato&display=swap" rel="stylesheet">
    <style>
    @import
	url('https://fonts.googleapis.com/css2?family=Lato&display=swap');

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
	background: linear-gradient(to right, var(--primary-blue),
		var(--secondary-blue));
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

/* MAIN DASHBOARD GRID */
.dashboard-container {
	max-width: 1000px;
	margin: 60px auto;
	background: white;
	padding: 40px;
	border-radius: 15px;
	box-shadow: 0px 8px 25px rgba(0, 0, 0, 0.08);
	text-align: center;
}

.dashboard-header {
	font-size: 26px;
	font-weight: bold;
	color: var(--primary-blue);
	margin-bottom: 35px;
	letter-spacing: 1px;
}

.dashboard-grid {
	display: flex;
	justify-content: center;
	gap: 40px;
	flex-wrap: wrap;
}

.grid-item {
	display: flex;
	flex-direction: column;
	align-items: center;
	background-color: #f6f8ff;
	border-radius: 12px;
	padding: 25px;
	width: 180px;
	text-decoration: none;
	color: var(--text-dark);
	transition: transform 0.3s ease, box-shadow 0.3s ease;
	box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
}

.grid-item:hover {
	background-color: var(--light-purple);
	color: var(--text-light);
	transform: scale(1.05);
}

.grid-item img {
	width: 80px;
	height: 80px;
	object-fit: cover;
	border-radius: 50%; /* Makes it perfectly circular */
	border: 3px solid #6b8cff; /* Optional: blue border */
	background-color: white; /* Fallback if image has transparent area */
	padding: 5px;
	margin-bottom: 10px;
	filter: drop-shadow(0 2px 4px rgba(0, 0, 0, 0.1));
}

.grid-item:hover img {
	transform: scale(1.1);
}

.grid-item span {
	font-size: 16px;
	font-weight: 600;
	color: var(--dark-purple);
}
    </style>
</head>
<body>

<!-- HEADER (Same as Dashboard) -->
<div class="header">
    <div class="header-left">
        <img src="images/logo.png" class="header-logo" />
    </div>
    <div class="profile-dropdown">
        <div class="profile-circle">
            <%= teacherName.substring(0, 1).toUpperCase() %>
        </div>
        <div class="profile-name">
            <%= teacherId %>
        </div>
        <div class="dropdown-content">
            <a href="teacherProfile.jsp">View Profile</a>
            <a href="teacherLogout.jsp">Logout</a>
        </div>
    </div>
</div>

<!-- MAIN CONTENT -->
<div class="dashboard-container">
    <div class="dashboard-header">STUDENT REPORT</div>

    <div class="dashboard-grid">
        <a href="teacherPerformance.jsp" class="grid-item">
            <img src="T/images/performance.jpg" alt="Performance Icon">
            <span>PERFORMANCE</span>
        </a>

        <a href="teacherGrading.jsp" class="grid-item">
            <img src="T/images/grading.jpg" alt="Grading Icon">
            <span>HOMEWORK</span>
        </a>

        <a href="teacherAttendance.jsp" class="grid-item">
            <img src="T/images/attendance.jpg" alt="Attendance Icon">
            <span>ATTENDANCE</span>
        </a>
    </div>
</div>

</body>
</html>
