<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DASHBOARD</title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap');

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
            font-family:'Poppins',sans-serif;
            margin:0;
            padding:18px;
            background-color:var(--light-bg);
            background-image:linear-gradient(135deg,transparent 49%,rgba(107,140,255,.1)50%,transparent 51%),linear-gradient(45deg,transparent 49%,rgba(179,136,235,.1)50%,transparent 51%);
            background-size:54px 54px;
            display:flex;
            justify-content:center;
            align-items:flex-start;
            min-height:100vh;
            position:relative;
            overflow-x:hidden;
        }

        body::before {
            content:"";
            position:absolute;
            top:-180px;
            right:-180px;
            width:360px;
            height:360px;
            border-radius:50%;
            background:radial-gradient(circle,var(--light-purple)0%,rgba(179,136,235,0)70%);
            opacity:.2;
            z-index:-1;
        }

        body::after {
            content:"";
            position:absolute;
            bottom:-90px;
            left:-90px;
            width:270px;
            height:270px;
            border-radius:50%;
            background:radial-gradient(circle,var(--primary-blue)0%,rgba(107,140,255,0)70%);
            opacity:.1;
            z-index:-1;
        }

        .logo {
            position:absolute;
            top:18px;
            left:18px;
            width:135px;
            height:auto;
            z-index:1;
        }

        .container {
            text-align:center;
            max-width:810px;
            width:100%;
            position:relative;
            background-color:var(--white);
            border-radius:18px;
            box-shadow:0 9px 27px rgba(107,140,255,.2);
            padding:24.3px 27px;
            animation:slideUp .54s ease-out;
        }

        .container::before {
            content:"";
            position:absolute;
            top:0;
            left:0;
            width:100%;
            height:9px;
            background:linear-gradient(to right,var(--primary-blue),var(--light-purple));
        }

        .header {
            display:flex;
            align-items:center;
            justify-content:flex-start;
            margin-top:81px;
            margin-bottom:54px;
        }

        .avatar {
            border-radius:50%;
            margin-right:9px;
            cursor:pointer;
        }

        .welcome-text h2 {
            margin:0;
            font-size:36px;
            font-weight:bold;
            text-align:left;
            color:var(--darker-purple);
        }

        .welcome-text h3 {
            margin:4.5px;
            font-size:27px;
            font-weight:bold;
            text-align:left;
            color:var(--darker-purple);
        }

        .welcome-text p {
            margin:0;
            font-size:12.6px;
            text-align:left;
            color:var(--darker-purple);
            opacity:.8;
        }

        .modal {
            display:none;
            position:fixed;
            top:0;
            left:0;
            width:100%;
            height:100%;
            background-color:rgba(0,0,0,.5);
            z-index:1000;
            justify-content:center;
            align-items:center;
        }

        .modal-content {
            background-color:var(--white);
            width:405px;
            height:405px;
            border-radius:0;
            padding:18px;
            box-shadow:0 9px 27px rgba(107,140,255,.2);
            position:relative;
            animation:fadeIn .27s ease-out;
            border:1px solid var(--darker-purple);
        }

        .modal-content::before {
            content:"";
            position:absolute;
            top:0;
            left:0;
            width:100%;
            height:4.5px;
            background:linear-gradient(to right,var(--primary-blue),var(--light-purple));
        }

        .close-btn {
            position:absolute;
            top:9px;
            right:9px;
            font-size:18px;
            color:var(--darker-purple);
            cursor:pointer;
            background:none;
            border:none;
        }

        .modal-content h3 {
            color:var(--darker-purple);
            font-size:21.6px;
            margin-bottom:18px;
            text-align:center;
        }

        .modal-content p {
            margin:9px 0;
            font-size:12.6px;
            color:var(--text-dark);
            display:flex;
            justify-content:space-between;
        }

        .modal-content p span.label {
            font-weight:500;
            color:var(--darker-purple);
        }

        .grid {
            display:grid;
            grid-template-columns:repeat(4,1fr);
            gap:18px;
            margin-bottom:18px;
            margin-top:36px;
        }

        .bottom-row {
            grid-column:1 / 5;
            display:grid;
            grid-template-columns:1fr 1fr 1fr 1fr;
            gap:18px;
            justify-content:center;
        }

        .button-container {
            display:flex;
            flex-direction:column;
            align-items:center;
            border-radius:13.5px;
            padding:9px;
            border:1px solid rgba(107,140,255,.2);
            box-shadow:0 4.5px 13.5px rgba(107,140,255,.1);
            transition:all .27s ease;
        }

        .button-container:hover {
            transform:translateY(-4.5px);
            box-shadow:0 7.2px 22.5px rgba(107,140,255,.2);
        }

        .button {
            width:108px;
            height:108px;
            background:linear-gradient(to right,var(--primary-blue),var(--light-purple));
            border-radius:50%;
            display:flex;
            align-items:center;
            justify-content:center;
            color:#fff;
            font-size:0;
            transition:transform .18s,box-shadow .27s;
            overflow:hidden;
        }

        .button img {
            width:54%;
            height:54%;
            object-fit:contain;
        }

        .button:hover {
            transform:scale(1.09);
            box-shadow:0 5.4px 18px rgba(107,140,255,.6);
        }

        .button-label {
            margin-top:9px;
            color:var(--dark-purple);
            font-size:12.6px;
            font-weight:bold;
        }

        .character {
            position:absolute;
            right:18px;
            bottom:50px;
            width:270px;
            height:auto;
        }

        @keyframes slideUp {
            from {opacity:0;transform:translateY(27px)}
            to {opacity:1;transform:translateY(0)}
        }

        @keyframes fadeIn {
            from {opacity:0}
            to {opacity:1}
        }
    </style>
</head>

<body>
    <div class="container">
        <img src="S/images/logo.png" alt="EduNext Logo" class="logo">
        <%
            String s_id = (String) session.getAttribute("s_id");
            String class_name = (String) session.getAttribute("class_name");

            if (s_id == null || class_name == null) {
                response.sendRedirect("studentLogin.jsp"); // Force login if session missing
                return;
            }
            String s_name = "";
            String email = "";
            String phone = "";
            String stuImage = "images/default.png"; // default fallback image

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/teacher_web", "root", "vips");

                // Fetch from student table
                PreparedStatement pst = conn.prepareStatement("SELECT s_name, s_email, phone, photo FROM student WHERE s_id = ?");
                pst.setString(1, s_id);
                ResultSet rs = pst.executeQuery();

                if (rs.next()) {
                    s_name = rs.getString("s_name") != null ? rs.getString("s_name") : "";
                    email = rs.getString("s_email") != null ? rs.getString("s_email") : "";
                    phone = rs.getString("phone") != null ? rs.getString("phone") : "";
                    stuImage = rs.getString("photo") != null ? rs.getString("photo") : "images/default.png";
                }

                conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        %>
        <div class="header">
            <span class="avatar">
                <img src="<%= stuImage %>" alt="Student Image" class="student" width="108px" height="108px" style="border-radius:50%" onclick="openModal()" onkeypress="if(event.key==='Enter')openModal()" tabindex="0">
            </span>
            <div class="welcome-text">
                <h2>WELCOME BACK</h2>
                <h3><%= s_name.toUpperCase() %></h3>
                <p><%= class_name %></p>
            </div>
        </div>
        <div class="grid">
            <div class="button-container">
                <a href="studentHomework.jsp" class="button"><img src="S/images/homework3.png" alt="Homework" style="width:54%;height:54%;object-fit:contain"></a>
                <span class="button-label">HOMEWORK</span>
            </div>
            <div class="button-container">
                <a href="studentFee.jsp" class="button"><img src="S/images/fee.png" alt="Fee" style="width:54%;height:54%;object-fit:contain"></a>
                <span class="button-label">FEE</span>
            </div>
            <div class="button-container">
                <a href="studentAttendance.jsp" class="button"><img src="S/images/attendance2.png" alt="Attendance" style="width:54%;height:54%;object-fit:contain"></a>
                <span class="button-label">ATTENDANCE</span>
            </div>
            <div class="button-container">
                <a href="studentPerformance.jsp" class="button"><img src="S/images/assignment.png" alt="Performance" style="width:54%;height:54%;object-fit:contain"></a>
                <span class="button-label">PERFORMANCE</span>
            </div>
            <div class="bottom-row">
                <div class="button-container">
                    <a href="studentSyllabus.jsp" class="button"><img src="S/images/syllabus.png" alt="Syllabus" style="width:54%;height:54%;object-fit:contain"></a>
                    <span class="button-label">SYLLABUS</span>
                </div>
                <div class="button-container">
                    <a href="studentTimetable.jsp" class="button"><img src="S/images/timetable.png" alt="Timetable" style="width:54%;height:54%;object-fit:contain"></a>
                    <span class="button-label">TIMETABLE</span>
                </div>
                <div class="button-container">
                    <a href="studentCircular.jsp" class="button"><img src="S/images/circular.png" alt="Circular" style="width:54%;height:54%;object-fit:contain"></a>
                    <span class="button-label">CIRCULAR</span>
                </div>
                <div class="button-container">
                    <a href="studentLogin.jsp" class="button"><img src="S/images/logout.png" alt="Log Out" style="width:54%;height:54%;object-fit:contain"></a>
                    <span class="button-label">LOG OUT</span>
                </div>
            </div>
        </div>
    </div>
    <img src="S/images/boy.png" alt="Character" class="character">

    <div class="modal" id="studentModal">
        <div class="modal-content">
            <button class="close-btn" onclick="closeModal()">×</button>
            <h3>Student Details</h3>
            <img src="<%= stuImage %>" alt="Student Image" style="width: 80px; height: 80px; border-radius: 50%; margin-bottom: 15px;">
            <p><span class="label">Name:</span> <%= s_name %></p>
            <p><span class="label">Mobile Number:</span> <%= phone %></p>
            <p><span class="label">Class:</span> <%= class_name %></p>
            <p><span class="label">Enrollment No:</span> <%= s_id %></p>
            <p><span class="label">Email:</span> <%= email %></p>
        </div>
    </div>

    <script>
        function openModal() {
            document.getElementById('studentModal').style.display = 'flex';
        }
        function closeModal() {
            document.getElementById('studentModal').style.display = 'none';
        }
    </script>
</body>
</html>