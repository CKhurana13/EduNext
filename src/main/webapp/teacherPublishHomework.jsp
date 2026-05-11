<%@ page import="java.sql.*, java.time.LocalDate, java.util.List, java.util.ArrayList, java.util.Enumeration" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Publish Homework</title>
    
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



/* MAIN CONTAINER */
.hw-container {
    max-width: 950px;
    margin: 60px auto;
    padding: 40px;
    background-color: var(--box-white);
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

/* TABS */
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

/* TAB CONTENT */
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

/* PUBLISH BUTTON */
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

/* Fade In Animation */
@keyframes fadeIn {
    from { opacity: 0; transform: translateY(20px); }
    to { opacity: 1; transform: translateY(0); }
}
        .hw-form {
            display: flex;
            flex-direction: column;
            gap: 18px;
            max-width: 600px;
            margin: 0 auto;
            font-size: 16px;
        }

        .hw-form label {
            font-weight: 600;
            color: #4d4d4d;
        }

        .hw-form input[type="text"],
        .hw-form input[type="date"],
        .hw-form select,
        .hw-form textarea {
            padding: 10px 14px;
            border-radius: 8px;
            border: 1px solid #ccc;
            background-color: #f8f9ff;
            font-family: 'Lato', sans-serif;
            width: 100%;
            box-sizing: border-box;
            font-size: 15px;
            transition: border-color 0.3s ease;
        }

        .hw-form input:focus,
        .hw-form textarea:focus,
        .hw-form select:focus {
            outline: none;
            border-color: #6b8cff;
        }

        .hw-form textarea {
            resize: vertical;
        }

        .hw-form .publish-btn {
            align-self: center;
            width: fit-content;
            padding: 12px 24px;
            font-size: 16px;
            background-color: #6b8cff;
            color: white;
            border: none;
            border-radius: 50px;
            cursor: pointer;
            font-weight: bold;
            transition: background-color 0.3s ease;
        }

        .hw-form .publish-btn:hover {
            background-color: #4d6cfa;
        }
    </style>
</head>
<body>
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

    List<String> teacherClasses = new ArrayList<>();
    List<String> teacherSubjects = new ArrayList<>();

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/teacher_web", "root", "vips");

        // Fetch classes and subjects from teacher table
        PreparedStatement ps1 = conn.prepareStatement("SELECT classes, subjects FROM teacher WHERE t_id = ?");
        ps1.setString(1, t_id);
        ResultSet rs1 = ps1.executeQuery();

        if (rs1.next()) {
            String[] classArray = rs1.getString("classes").split(",");
            String[] subjectArray = rs1.getString("subjects").split(",");

            for (String cls : classArray) {
                if (!cls.trim().isEmpty()) {
                    teacherClasses.add(cls.trim());
                }
            }
            for (String sub : subjectArray) {
                if (!sub.trim().isEmpty()) {
                    teacherSubjects.add(sub.trim());
                }
            }
        }

        rs1.close();
        ps1.close();
        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<p>Error retrieving teacher data: " + e.getMessage() + "</p>");
    }

    LocalDate today = LocalDate.now();
%>
<!-- HEADER -->
<div class="header">
    <img src="images/logo.png" class="header-logo" />
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

<!-- FORM CONTAINER -->
<div class="hw-container">
    <h2>Publish Homework</h2>
    <% if (request.getAttribute("success") != null) { %>
        <p style="color: green; text-align: center;"><%= request.getAttribute("success") %></p>
    <% } %>
    <% if (request.getAttribute("error") != null) { %>
        <p style="color: red; text-align: center;"><%= request.getAttribute("error") %></p>
    <% } %>
    <form action="TeacherPublishHomeworkServlet" method="post" class="hw-form">
        <div>
            <label>Class:</label>
            <select name="class_name" required>
                <% for (String cls : teacherClasses) { %>
                    <option value="<%= cls %>"><%= cls %></option>
                <% } %>
            </select>
        </div>
        <div>
            <label>Subject:</label>
            <select name="subject" required>
                <% for (String sub : teacherSubjects) { %>
                    <option value="<%= sub %>"><%= sub %></option>
                <% } %>
            </select>
        </div>
        <div>
            <label>Chapter:</label>
            <input type="text" name="chapter" required>
        </div>
        <div>
            <label>Description:</label>
            <textarea name="description" rows="4" required></textarea>
        </div>
        <div>
            <label>Due Date:</label>
            <input type="date" name="due_date" required>
        </div>
        <input type="hidden" name="issue_date" value="<%= today %>">
        <input type="hidden" name="t_id" value="<%= t_id %>">
        <button type="submit" class="publish-btn">Submit Homework</button>
    </form>
</div>
</body>
</html>