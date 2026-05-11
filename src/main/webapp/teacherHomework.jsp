<%@ page import="java.util.*, java.time.*, java.sql.*"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%
String t_id = (String) session.getAttribute("t_id");
String teacherName = (String) session.getAttribute("username");

// Debugging session attributes
if (t_id == null) {
    StringBuilder attrLog = new StringBuilder();
    Enumeration<String> sessionAttributes = session.getAttributeNames();
    while (sessionAttributes.hasMoreElements()) {
        String attr = sessionAttributes.nextElement();
        attrLog.append(attr).append("=").append(session.getAttribute(attr)).append(", ");
    }
    out.println("<script>console.error('Session attributes missing: t_id=" + session.getAttribute("t_id") + ", username=" + session.getAttribute("username") + "');" +
                "console.log('All session attributes: " + attrLog.toString() + "');</script>");
    response.sendRedirect("teacherLogin.jsp");
    return;
}

// Database connection parameters
String url = "jdbc:mysql://localhost:3306/teacher_web";
String dbUser = "root";
String dbPassword = "vips";

List<Map<String, String>> todayHomework = new ArrayList<>();
List<Map<String, String>> weeklyHomework = new ArrayList<>();

try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection conn = DriverManager.getConnection(url, dbUser, dbPassword);
    
    LocalDate today = LocalDate.now();
    LocalDate weekStart = today.with(java.time.DayOfWeek.MONDAY);
    LocalDate weekEnd = today.with(java.time.DayOfWeek.SUNDAY);
    
    // Today's homework
    String sqlToday = "SELECT h.hw_id, h.className, h.sub_id, s.sub_name, h.chapter, h.description, h.due_date, h.assigned_date, h.t_id " +
                     "FROM homework h JOIN subjects s ON h.sub_id = s.sub_id " +
                     "WHERE h.t_id = ? AND h.assigned_date = ?";
    PreparedStatement psToday = conn.prepareStatement(sqlToday);
    psToday.setString(1, t_id);
    psToday.setDate(2, java.sql.Date.valueOf(today));
    ResultSet rsToday = psToday.executeQuery();
    
    while (rsToday.next()) {
        Map<String, String> hw = new HashMap<>();
        hw.put("hw_id", rsToday.getString("hw_id"));
        hw.put("class", rsToday.getString("className"));
        hw.put("subject", rsToday.getString("sub_name"));
        hw.put("chapter", rsToday.getString("chapter") != null ? rsToday.getString("chapter") : "N/A");
        hw.put("description", rsToday.getString("description") != null ? rsToday.getString("description") : "No description");
        hw.put("due_date", rsToday.getString("due_date") != null ? rsToday.getString("due_date") : "N/A");
        hw.put("assigned_date", rsToday.getString("assigned_date") != null ? rsToday.getString("assigned_date") : "N/A");
        hw.put("t_id", rsToday.getString("t_id") != null ? rsToday.getString("t_id") : "N/A");
        todayHomework.add(hw);
    }
    rsToday.close();
    psToday.close();
    
    // Weekly homework
    String sqlWeek = "SELECT h.hw_id, h.className, h.sub_id, s.sub_name, h.chapter, h.description, h.due_date, h.assigned_date, h.t_id " +
                    "FROM homework h JOIN subjects s ON h.sub_id = s.sub_id " +
                    "WHERE h.t_id = ? AND h.assigned_date BETWEEN ? AND ? ORDER BY h.assigned_date";
    PreparedStatement psWeek = conn.prepareStatement(sqlWeek);
    psWeek.setString(1, t_id);
    psWeek.setDate(2, java.sql.Date.valueOf(weekStart));
    psWeek.setDate(3, java.sql.Date.valueOf(weekEnd));
    ResultSet rsWeek = psWeek.executeQuery();
    
    while (rsWeek.next()) {
        Map<String, String> hw = new HashMap<>();
        hw.put("hw_id", rsWeek.getString("hw_id"));
        hw.put("class", rsWeek.getString("className"));
        hw.put("subject", rsWeek.getString("sub_name"));
        hw.put("chapter", rsWeek.getString("chapter") != null ? rsWeek.getString("chapter") : "N/A");
        hw.put("description", rsWeek.getString("description") != null ? rsWeek.getString("description") : "No description");
        hw.put("due_date", rsWeek.getString("due_date") != null ? rsWeek.getString("due_date") : "N/A");
        hw.put("assigned_date", rsWeek.getString("assigned_date") != null ? rsWeek.getString("assigned_date") : "N/A");
        hw.put("t_id", rsWeek.getString("t_id") != null ? rsWeek.getString("t_id") : "N/A");
        weeklyHomework.add(hw);
    }
    rsWeek.close();
    psWeek.close();
    
    conn.close();
} catch (Exception e) {
    e.printStackTrace();
    out.println("<p>Error retrieving homework data: " + e.getMessage() + "</p>");
}
%>
<!DOCTYPE html>
<html>
<head>
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

.hw-container {
    max-width: 950px;
    margin: 60px auto;
    padding: 40px;
    background-color: var(--white);
    border-radius: 12px;
    box-shadow: 0 0 15px rgba(0,0,0,0.1);
    backdrop-filter: blur(4px);
    animation: fadeIn 0.7s ease-in;
}

.hw-container h2 {
    text-align: center;
    color: var(--secondary-blue);
    margin-bottom: 30px;
    font-size: 28px;
}

.tabs {
    display: flex;
    justify-content: center;
    gap: 20px;
    margin-bottom: 20px;
    flex-wrap: wrap;
}

.tab {
    padding: 10px 20px;
    border: none;
    background: #dbeafe;
    border-radius: 8px 8px 0 0;
    font-weight: 600;
    cursor: pointer;
    color: var(--text-dark);
    transition: all 0.3s ease;
}

.tab:hover {
    background-color: #bfdbfe;
}

.tab.active {
    background-color: white;
    border-bottom: 2px solid var(--secondary-blue);
    font-weight: bold;
}

.tab-content {
    background-color: white;
    padding: 25px;
    border-radius: 0 0 8px 8px;
    box-shadow: 0 2px 5px rgba(0,0,0,0.05);
    min-height: 200px;
    text-align: left;
    color: var(--text-dark);
}

.tab-content ul {
    list-style: none;
    padding: 0;
    max-width: 750px;
    margin: 0 auto;
}

.tab-content li {
    margin-bottom: 15px;
    padding: 10px 15px;
    background-color: #f0f4ff;
    border-left: 4px solid var(--primary-blue);
    border-radius: 6px;
}

.publish-btn {
    position: fixed;
    bottom: 30px;
    right: 30px;
    background: var(--primary-blue);
    color: white;
    border: none;
    padding: 14px 24px;
    font-size: 16px;
    font-weight: bold;
    border-radius: 50px;
    cursor: pointer;
    box-shadow: 0 4px 8px rgba(0,0,0,0.2);
    transition: background-color 0.3s ease;
}

.publish-btn:hover {
    background-color: var(--secondary-blue);
}

@keyframes fadeIn {
    from { opacity: 0; transform: translateY(20px); }
    to { opacity: 1; transform: translateY(0); }
}
</style>
<title>Teacher Homework</title>
<script>
    function showTab(tabName) {
        document.getElementById('todayTab').classList.remove('active');
        document.getElementById('weekTab').classList.remove('active');
        document.getElementById('todayContent').style.display = 'none';
        document.getElementById('weekContent').style.display = 'none';

        document.getElementById(tabName + 'Tab').classList.add('active');
        document.getElementById(tabName + 'Content').style.display = 'block';
    }

    window.onload = function() {
        showTab('today');
    };
</script>
</head>
<body>
    <div class="header bg-white bg-opacity-80 backdrop-blur-md shadow-md">
        <div class="header-left">
            <img src="images/logo.png" alt="Logo" class="header-logo">
        </div>
        <div class="profile-dropdown">
            <div class="flex items-center space-x-3">
                <div class="profile-circle">
                    <span><%= teacherName != null && !teacherName.isEmpty() ? teacherName.substring(0, 1).toUpperCase() : "T" %></span>
                </div>
                <div class="profile-name"><%= teacherName != null && !teacherName.isEmpty() ? teacherName : t_id %></div>
            </div>
            <div class="dropdown-content">
                <a href="teacherProfile.jsp">View Profile</a>
                <a href="teacherLogout.jsp">Logout</a>
            </div>
        </div>
    </div>

    <div class="hw-container">
        <h2>Teacher Homework</h2>

        <div class="tabs">
            <div id="todayTab" class="tab" onclick="showTab('today')">Today's Homework</div>
            <div id="weekTab" class="tab" onclick="showTab('week')">Weekly Homework</div>
        </div>

        <div id="todayContent" class="tab-content">
            <% if (todayHomework.isEmpty()) { %>
                <p>No homework assigned today.</p>
            <% } else { %>
                <ul>
                    <% for (Map<String, String> hw : todayHomework) { %>
                        <li>
                            <strong>Class <%=hw.get("class")%> - <%=hw.get("subject")%> (ID: <%=hw.get("hw_id")%>):</strong><br>
                            <%=hw.get("chapter")%><br>
                            Description: <%=hw.get("description")%><br>
                            Due Date: <%=hw.get("due_date")%><br>
                            Assigned Date: <%=hw.get("assigned_date")%><br>
                            Teacher ID: <%=hw.get("t_id")%>
                        </li>
                    <% } %>
                </ul>
            <% } %>
        </div>

        <div id="weekContent" class="tab-content" style="display: none;">
            <% if (weeklyHomework.isEmpty()) { %>
                <p>No homework assigned this week.</p>
            <% } else { %>
                <ul>
                    <% for (Map<String, String> hw : weeklyHomework) { %>
                        <li>
                            <strong>Class <%=hw.get("class")%> - <%=hw.get("subject")%> (ID: <%=hw.get("hw_id")%>):</strong><br>
                            <%=hw.get("chapter")%><br>
                            Description: <%=hw.get("description")%><br>
                            Due Date: <%=hw.get("due_date")%><br>
                            Assigned Date: <%=hw.get("assigned_date")%><br>
                            Teacher ID: <%=hw.get("t_id")%>
                        </li>
                    <% } %>
                </ul>
            <% } %>
        </div>
    </div>

    <button class="publish-btn" onclick="window.location.href='teacherPublishHomework.jsp'">Publish Homework</button>
</body>
</html>