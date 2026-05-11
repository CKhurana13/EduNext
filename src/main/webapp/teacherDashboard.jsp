<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%
String t_id = (String) session.getAttribute("t_id");
String t_name = (String) session.getAttribute("t_name");

if (t_id == null || t_name == null) {
	response.sendRedirect("teacherLogin.jsp");
	return;
}
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Teacher Dashboard</title>

<link
	href="https://fonts.googleapis.com/css2?family=Lato:wght@400;600;700&display=swap"
	rel="stylesheet">
<link
	href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css"
	rel="stylesheet">
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

.header {
	background: linear-gradient(to right, var(--primary-blue),
		var(--secondary-blue));
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

/* Center box for dashboard */
.dashboard-container {
	max-width: 1200px; /* wider container */
	margin: 60px auto;
	padding: 40px;
	background-color: rgba(255, 255, 255, 0.8);
	border-radius: 10px;
	box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);
	backdrop-filter: blur(4px);
	animation: fadeIn 1s ease-in-out;
}

@
keyframes fadeIn {from { opacity:0;
	transform: translateY(20px);
}

to {
	opacity: 1;
	transform: translateY(0);
}
}

/* Welcome message */
.welcome-message {
	font-size: 24px;
	margin-bottom: 20px;
	color: var(--dark-purple);
	font-weight: 700;
	text-align: center;
	text-shadow: 0 1px 2px rgba(0, 0, 0, 0.1);
}

/* Grid for dashboard items */
.dashboard-grid {
	display: grid;
	grid-template-columns: repeat(3, 1fr); /* Fixed 3 items per row */
	gap: 40px;
	text-align: center;
}

.grid-item {
	height: 200px; /* taller cards */
	font-size: 16px;
	background-color: rgba(230, 240, 255, 0.9);
	padding: 20px;
	border-radius: 12px;
	text-decoration: none;
	color: var(--text-dark);
	font-weight: 600;
	transition: all 0.3s ease;
	display: flex;
	flex-direction: column;
	align-items: center;
	justify-content: center;
	box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
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

@media (max-width: 768px) {
	.dashboard-grid {
		grid-template-columns: repeat(2, 1fr);
	}
	.dashboard-container {
		margin: 20px;
		padding: 20px;
	}
}

@media (max-width: 480px) {
	.dashboard-container {
		margin: 30px;
		padding: 25px;
	}
	.dashboard-grid {
		grid-template-columns: 1fr;
	}
	.header-logo {
		height: 30px;
		max-width: 80px;
	}
}
</style>
</head>
<body class="min-h-screen">
	<!-- Header -->
	<div class="header bg-white bg-opacity-80 backdrop-blur-md shadow-md">
		<div class="header-left">
			<img src="T/images/logo.jpeg" alt="Logo" class="header-logo">
		</div>
		<div class="profile-dropdown">
			<div class="flex items-center space-x-3">
				<div class="profile-circle">
					<span><%=t_name.substring(0, 1).toUpperCase()%></span>
				</div>
				<div class="profile-name"><%=t_id%></div>
			</div>
			<div class="dropdown-content">
				<a href="teacherProfile.jsp">View Profile</a> <a href="teacherLogout.jsp">Logout</a>
			</div>
		</div>
	</div>

	<!-- Center Box -->
	<div class="dashboard-container">
		<div class="welcome-message">
			Welcome,
			<%=t_name%>!
		</div>
		<div class="dashboard-grid">
			<a href="teacherHomework.jsp" class="grid-item"> <img
				src="T/images/homework.jpg" alt="Homework"> <span>HOMEWORK</span>
			</a> <a href="teacherSyllabus.jsp" class="grid-item"> <img
				src="T/images/syllabus.jpg" alt="Syllabus"> <span>SYLLABUS</span>
			</a> <a href="teacherSchedule.jsp" class="grid-item"> <img
				src="T/images/schedule.jpg" alt="Schedule"> <span>SCHEDULE</span>
			</a> <a href="teacherCircular.jsp" class="grid-item"> <img
				src="T/images/circular.jpg" alt="Circulars"> <span>CIRCULARS</span>
			</a> <a href="teacherStudentReport.jsp" class="grid-item"> <img
				src="T/images/report.jpg" alt="Student Report"> <span>STUDENT REPORT</span>
			</a> <a href="teacherProfile.jsp" class="grid-item"> <img
				src="T/images/profile.jpg" alt="Profile"> <span>MY PROFILE</span>
			</a>
		</div>
	</div>
</body>
</html>