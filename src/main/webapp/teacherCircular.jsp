<%@ page import="java.util.*, java.sql.*, java.text.SimpleDateFormat" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Check session
    String t_id = (String) session.getAttribute("t_id");
    String t_name = (String) session.getAttribute("t_name");

    if (t_id == null || t_name == null) {
        response.sendRedirect("teacherLogin.jsp?error=unauthorized");
        return;
    }

    // Database connection parameters
    String url = "jdbc:mysql://localhost:3306/teacher_web";
    String username = "root";
    String password = "vips";

    Connection conn = null;
    Statement stmt = null;
    ResultSet rs = null;
    boolean hasCirculars = false; // Declare and initialize hasCirculars outside try block

    try {
        // Load MySQL JDBC driver
        Class.forName("com.mysql.cj.jdbc.Driver");

        // Establish connection
        conn = DriverManager.getConnection(url, username, password);
        stmt = conn.createStatement();
        String sql = "SELECT circular_id, title, description, issue_date FROM circulars ORDER BY issue_date DESC";
        rs = stmt.executeQuery(sql);

        // Process result set (data will be rendered later in main-container)
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        // Close resources
        if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (stmt != null) try { stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Notices & Circulars</title>
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
.logo {
            position: absolute;
            top: 20px;
            left: 20px;
            width: 100px;
            height: auto;
            z-index: 1000;
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

/* MAIN CONTAINER */
.main-container {
    max-width: 900px;
    margin: 60px auto;
    background: rgba(255, 255, 255, 0.85);
    backdrop-filter: blur(8px);
    padding: 30px;
    border-radius: 15px;
    box-shadow: 0px 8px 25px rgba(0, 0, 0, 0.1);
}

.main-container h2 {
    text-align: center;
    color: #003366;
    margin-bottom: 25px;
}

/* NOTICES */
.notice-box {
    background-color: #e6f0ff;
    border-left: 6px solid #004d99;
    padding: 20px;
    border-radius: 10px;
    margin-bottom: 20px;
    box-shadow: 0 2px 6px rgba(0, 0, 0, 0.08);
    transition: transform 0.2s ease;
}

.notice-box:hover {
    transform: scale(1.01);
}

.notice-box h3 {
    font-size: 20px;
    color: #333;
    margin-bottom: 8px;
}

.notice-box p {
    font-size: 15px;
    color: #555;
    margin-bottom: 8px;
}

.notice-box small {
    font-size: 13px;
    color: #777;
    display: block;
    text-align: right;
}

.no-data {
    text-align: center;
    color: red;
    font-weight: 500;
    margin-top: 20px;
}
    </style>
    <link href="https://fonts.googleapis.com/css2?family=Lato&display=swap" rel="stylesheet">
</head>
<body>

<!-- Header -->
<div class="header bg-white bg-opacity-80 backdrop-blur-md shadow-md">
    <div class="header-left">
        <img src="images/logo.png" alt="Logo" class="header-logo">
    </div>
    <div class="profile-dropdown">
        <div class="flex items-center space-x-3">
            <div class="profile-circle">
                <span><%= t_name.substring(0, 1).toUpperCase() %></span>
            </div>
            <div class="profile-name"><%= t_id %></div>
        </div>
        <div class="dropdown-content">
            <a href="teacherProfile.jsp">View Profile</a>
            <a href="teacherLogout.jsp">Logout</a>
        </div>
    </div>
</div>

<!-- Main container -->
<div class="main-container">
    <h2>Notices and Circulars</h2>
    <%
        try {
            // Load MySQL JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Establish connection
            conn = DriverManager.getConnection(url, username, password);
            stmt = conn.createStatement();
            String sql = "SELECT circular_id, title, description, issue_date FROM circulars ORDER BY issue_date DESC";
            rs = stmt.executeQuery(sql);

            // Process result set
            while (rs.next()) {
                hasCirculars = true; // Set to true if circulars are found
                SimpleDateFormat sdf = new SimpleDateFormat("dd MMMM yyyy");
                String formattedDate = sdf.format(rs.getDate("issue_date"));
    %>
        <div class="notice-box">
            <h3><%= rs.getString("title") %></h3>
            <p><%= rs.getString("description") %></p>
            <small>📅 Posted on: <%= formattedDate %></small>
        </div>
    <%
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<p class='no-data'>Error fetching circulars: " + e.getMessage() + "</p>");
        } finally {
            // Close resources
            if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (stmt != null) try { stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (!hasCirculars) {
    %>
        <p class="no-data">No circulars or notices available.</p>
    <%
            }
        }
    %>
</div>

</body>
</html>