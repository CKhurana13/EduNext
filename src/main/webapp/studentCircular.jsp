<%@ page import="java.sql.*, java.util.*, java.text.SimpleDateFormat, java.util.Date" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
String s_id = (String) session.getAttribute("s_id");
String s_name = (String) session.getAttribute("s_name");

if (s_id == null || s_name == null) {
    response.sendRedirect("studentLogin.jsp?error=unauthorized");
    return;
}
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Circulars</title>
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
    font-family: 'Poppins', sans-serif;
    margin: 0;
    padding: 20px;
    background-color: var(--light-bg);
    display: flex;
    justify-content: center;
    align-items: flex-start;
    min-height: 100vh;
    position: relative;
    background: repeating-linear-gradient(45deg, #e0e7ff 0, #e0e7ff 10px, #d1e0ff 10px, #d1e0ff 20px),
                repeating-linear-gradient(-45deg, #e0e7ff 0, #e0e7ff 10px, #d1e0ff 10px, #d1e0ff 20px);
    background-blend-mode: overlay;
}

.logo {
    width: 120px;
    height: auto;
    position: absolute;
    top: 20px;
    left: 20px;
}

.container {
    max-width: 900px;
    width: 100%;
    background-color: var(--white);
    border-radius: 20px;
    box-shadow: 0 10px 30px rgba(107, 140, 255, 0.2);
    padding: 30px;
    margin-top: 60px;
    position: relative;
    z-index: 1;
}

.header {
    display: flex;
    align-items: center;
    margin-bottom: 20px;
}

.back-arrow {
    font-size: 28px;
    font-weight: 500;
    cursor: pointer;
    margin-right: 10px;
    color: var(--dark-purple);
    line-height: 1;
}

.header-title {
    background-color: var(--secondary-blue);
    color: var(--white);
    padding: 10px 20px;
    border-radius: 10px;
    font-size: 24px;
    font-weight: bold;
    flex-grow: 1;
    text-align: center;
    margin: 0 10px;
}

.tabs {
    display: flex;
    margin-bottom: 20px;
    background-color: #d1e0ff;
    border-radius: 10px;
    overflow: hidden;
}

.tab {
    flex: 1;
    padding: 10px;
    text-align: center;
    cursor: pointer;
    transition: background-color 0.3s;
}

.tab.active {
    background-color: var(--primary-blue);
    color: var(--white);
}

.circulars {
    display: block;
}

.circular {
    display: flex;
    justify-content: space-between;
    align-items: flex-start;
    background-color: var(--secondary-blue);
    color: var(--white);
    padding: 15px;
    margin-bottom: 10px;
    border-radius: 10px;
}

.circular .details {
    display: flex;
    align-items: flex-start;
    flex-wrap: wrap;
    width: 100%;
}

.circular .details img {
    width: 40px;
    height: 40px;
    margin-right: 10px;
}

.circular .details .content {
    flex: 1;
    min-width: 0;
    display: flex;
    flex-direction: column;
    gap: 5px;
}

.circular-title-container {
    background-color: var(--primary-blue);
    color: var(--white);
    border-radius: 8px;
    padding: 8px 15px;
    width: 100%;
    box-sizing: border-box;
    font-weight: bold;
}

.circular-title-container strong {
    margin-right: 10px;
}

.circular .description {
    padding-left: 20px;
    flex-basis: 70%;
    margin-bottom: 5px;
}

.circular .issue-date {
    padding-left: 20px;
    font-weight: bold;
    flex-basis: 30%;
}

.teacher-avatar {
    position: fixed;
    bottom: 10px;
    right: 10px;
    width: 250px;
    height: auto;
    z-index: 999;
}

@media (max-width: 600px) {
    .circular .description,
    .circular .issue-date {
        flex-basis: 100%;
        padding-left: 10px;
    }
}
</style>
</head>
<body>
    <img src="S/images/logo.png" alt="EduNext Logo" class="logo">

    <div class="container">
        <div class="header">
            <span class="back-arrow" onclick="window.location.href='teacherDashboard.jsp'">←</span>
            <div class="header-title">CIRCULARS</div>
        </div>

        <div class="tabs">
            <div class="tab active" onclick="showTab('circulars')">IMPORTANT NOTIFICATIONS</div>
        </div>

        <div class="circulars">
            <%
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/teacher_web", "root", "vips");
                Statement st = con.createStatement();
                ResultSet rs = st.executeQuery("SELECT title, description, issue_date FROM circulars ORDER BY issue_date DESC");

                boolean hasCirculars = false;
                while (rs.next()) {
                    hasCirculars = true;
                    SimpleDateFormat sdf = new SimpleDateFormat("dd MMMM yyyy");
                    String formattedDate = sdf.format(rs.getDate("issue_date"));
            %>
            <div class="circular">
                <div class="details">
                    <img src="S/images/circular.png" alt="Circular Icon">
                    <div class="content">
                        <div class="circular-title-container"><strong>Title:</strong> <%= rs.getString("title") %></div>
                        <div class="description"><%= rs.getString("description") %></div>
                        <div class="issue-date">Issued: <%= formattedDate %></div>
                    </div>
                </div>
            </div>
            <%
                }
                if (!hasCirculars) {
                    out.println("<p style='color: var(--dark-purple); text-align: center;'>No circulars available.</p>");
                }
                rs.close();
                st.close();
                con.close();
            } catch (Exception e) {
                out.println("<p class='error-message'>⚠️ Error fetching circulars: " + e.getMessage() + "</p>");
            }
            %>
        </div>
    </div>
    <img src="S/images/teacher_avatar.png" alt="Teacher Avatar" class="teacher-avatar">
    <script>
        function showTab(tab) {
            document.querySelectorAll('.tab').forEach(t => t.classList.remove('active'));
            document.querySelectorAll('.circulars').forEach(t => t.classList.remove('active'));
            document.querySelector(`.${tab}`).classList.add('active');
            document.querySelector(`[onclick="showTab('${tab}')"]`).classList.add('active');
        }
    </script>
</body>
</html>