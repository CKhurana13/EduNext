<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%
String t_id = (String) session.getAttribute("t_id");
String t_name = (String) session.getAttribute("t_name");

if (t_id == null || t_name == null) {
    response.sendRedirect("teacherLogin.jsp?error=unauthorized");
    return;
}

String address = null;
String phone = null;
String email = null;
String subjects = null;
String classes = null;
String qualifications = null;
String photo = "t1.png"; // Default photo
String doj = null;
String dob = null;

try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/teacher_web", "root", "vips");
    PreparedStatement ps = conn.prepareStatement("SELECT address, phone, t_email, subjects, classes, qualifications, photo, doj, dob FROM teacher WHERE t_id = ?");
    ps.setString(1, t_id);
    ResultSet rs = ps.executeQuery();

    if (rs.next()) {
        address = rs.getString("address");
        phone = rs.getString("phone");
        email = rs.getString("t_email");
        subjects = rs.getString("subjects");
        classes = rs.getString("classes");
        qualifications = rs.getString("qualifications");
        photo = rs.getString("photo") != null && !rs.getString("photo").trim().isEmpty() ? rs.getString("photo") : "t1.png";
        doj = rs.getString("doj") != null ? rs.getString("doj") : "N/A";
        dob = rs.getString("dob") != null ? rs.getString("dob") : "N/A";
    } else {
        out.println("<p class='error-message'>⚠️ No teacher found with ID: " + t_id + "</p>");
    }

    rs.close();
    ps.close();
    conn.close();
} catch (Exception e) {
    e.printStackTrace();
    out.println("<p class='error-message'>⚠️ Error fetching profile data: " + e.getMessage() + "</p>");
}
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Teacher Profile</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
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

    .profile-container {
        max-width: 900px;
        margin: 50px auto;
        padding: 30px;
        background-color: rgba(255, 255, 255, 0.8);
        box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);
        border-radius: 12px;
        backdrop-filter: blur(4px);
        animation: fadeIn 1s ease-in-out;
    }

    @keyframes fadeIn {
        from {
            opacity: 0;
            transform: translateY(20px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }

    .profile-container h2 {
        text-align: center;
        color: var(--dark-purple);
        margin-bottom: 30px;
        font-size: 28px;
        font-weight: 700;
        text-shadow: 0 1px 2px rgba(0, 0, 0, 0.1);
    }

    .container-box {
        background: rgba(230, 240, 255, 0.9);
        border-radius: 12px;
        padding: 25px;
        margin-bottom: 30px;
        display: flex;
        gap: 30px;
        align-items: flex-start;
        flex-wrap: wrap;
    }

    .container-box h3 {
        width: 100%;
        margin-bottom: 20px;
        color: var(--dark-purple);
        font-size: 22px;
        font-weight: 700;
    }

    .profile-photo {
        width: 120px;
        height: 120px;
        object-fit: cover;
        border-radius: 50%;
        margin-bottom: 20px;
        flex-shrink: 0;
        filter: drop-shadow(0 2px 4px rgba(0, 0, 0, 0.1));
        transition: transform 0.3s ease;
    }

    .profile-photo:hover {
        transform: scale(1.05);
    }

    .profile-details-content {
        flex: 1;
        display: flex;
        flex-direction: column;
        gap: 12px;
        min-width: 250px;
    }

    .detail-item {
        display: flex;
        justify-content: space-between;
        gap: 20px;
        border-bottom: 1px solid rgba(0, 0, 0, 0.1);
        padding-bottom: 6px;
        font-size: 17px;
        font-weight: 600;
        color: var(--text-dark);
    }

    .detail-item:hover {
        background-color: rgba(255, 255, 255, 0.4);
        border-radius: 6px;
    }

    .detail-item .label {
        flex: 0 0 150px;
        color: var(--text-dark);
    }

    .detail-item .value {
        flex: 1;
        text-align: left;
        color: var(--text-dark);
    }

    .error-message {
        text-align: center;
        color: #dc2626;
        background-color: rgba(220, 38, 38, 0.1);
        padding: 10px;
        border-radius: 8px;
        margin-bottom: 20px;
        font-weight: 600;
    }

    @media (max-width: 768px) {
        .profile-container {
            margin: 20px;
            padding: 20px;
        }
        .container-box {
            flex-direction: column;
            align-items: center;
        }
        .container-box .detail-item {
            width: 100%;
        }
        .profile-photo {
            margin: 0 auto 20px;
        }
    }

    @media (max-width: 640px) {
        .header-logo {
            height: 40px;
        }
        .container-box .detail-item {
            flex-direction: column;
            gap: 5px;
            text-align: center;
        }
        .profile-container h2 {
            font-size: 24px;
        }
        .container-box h3 {
            font-size: 18px;
        }
        .container-box .detail-item {
            font-size: 16px;
        }
    }
    </style>
</head>
<body class="min-h-screen">
    <!-- Header (Standardized with Dashboard) -->
    <div class="header bg-white bg-opacity-80 backdrop-blur-md shadow-md">
        <div class="header-left">
            <img src="S/images/logo.png" alt="Logo" class="header-logo">
        </div>
        <div class="profile-dropdown">
            <div class="flex items-center space-x-3">
                <div class="profile-circle">
                    <span><%=t_name.substring(0, 1).toUpperCase()%></span>
                </div>
                <div class="profile-name"><%=t_id%></div>
            </div>
            <div class="dropdown-content">
                <a href="teacherLogout.jsp">Logout</a>
            </div>
        </div>
    </div>

    <!-- Profile Container -->
    <div class="profile-container">
        <h2>Teacher Profile</h2>
        <% if (address == null) { %>
            <p class="error-message">⚠️ No profile data found for ID: <%=t_id%></p>
        <% } %>
        <div class="personal-details container-box">
            <h3>Personal Details</h3>
            <img src="S/images/<%=photo%>" alt="Profile Photo" class="profile-photo">
            <div class="profile-details-content">
                <div class="detail-item">
                    <span class="label">Name:</span>
                    <span class="value"><%=t_name != null ? t_name : "N/A"%></span>
                </div>
                <div class="detail-item">
                    <span class="label">Date of Birth:</span>
                    <span class="value"><%=dob != null ? dob : "N/A"%></span>
                </div>
                <div class="detail-item">
                    <span class="label">Phone:</span>
                    <span class="value"><%=phone != null ? phone : "N/A"%></span>
                </div>
                <div class="detail-item">
                    <span class="label">Address:</span>
                    <span class="value"><%=address != null ? address : "N/A"%></span>
                </div>
                <div class="detail-item">
                    <span class="label">Email:</span>
                    <span class="value"><%=email != null ? email : "N/A"%></span>
                </div>
            </div>
        </div>
        <div class="educational-details container-box">
            <h3>Educational Details</h3>
            <div class="profile-details-content">
                <div class="detail-item">
                    <span class="label">Teacher ID:</span>
                    <span class="value"><%=t_id != null ? t_id : "N/A"%></span>
                </div>
                <div class="detail-item">
                    <span class="label">Qualification:</span>
                    <span class="value"><%=qualifications != null ? qualifications : "N/A"%></span>
                </div>
                <div class="detail-item">
                    <span class="label">Subjects:</span>
                    <span class="value"><%=subjects != null ? subjects : "N/A"%></span>
                </div>
                <div class="detail-item">
                    <span class="label">Current Classes:</span>
                    <span class="value"><%=classes != null ? classes : "N/A"%></span>
                </div>
                <div class="detail-item">
                    <span class="label">Date of Joining:</span>
                    <span class="value"><%=doj != null ? doj : "N/A"%></span>
                </div>
            </div>
        </div>
    </div>
</body>
</html>