<%@ page import="java.util.*, java.sql.*, java.time.LocalDate, java.util.Enumeration" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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

    List<String> classList = (List<String>) request.getAttribute("classes");
    List<String> subjectList = (List<String>) request.getAttribute("subjects");
    List<Map<String, String>> examList = (List<Map<String, String>>) request.getAttribute("exam_types");

    if (classList == null) classList = new ArrayList<>();
    if (subjectList == null) subjectList = new ArrayList<>();
    if (examList == null) examList = new ArrayList<>();

    String selectedClass = request.getParameter("className");

    // Debug dropdown data
    out.println("<script>console.log('Classes list: ' + JSON.stringify(" + classList + "));</script>");
    out.println("<script>console.log('Subjects list: ' + JSON.stringify(" + subjectList + "));</script>");
    out.println("<script>console.log('Exams list: ' + JSON.stringify(" + examList + "));</script>");
%>

<!DOCTYPE html>
<html>
<head>
    <title>Upload Syllabus</title>
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

        .profile-container {
            max-width: 1000px;
            margin: 50px auto;
            background-color: rgba(255, 255, 255, 0.85);
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);
            backdrop-filter: blur(4px);
            animation: fadeIn 1s ease-in-out;
        }

        .container-box {
            background: rgba(230, 240, 255, 0.9);
            padding: 25px;
            border-radius: 12px;
            margin-top: 20px;
        }

        label {
            font-weight: bold;
            color: var(--dark-purple);
            display: block;
            margin-top: 15px;
            margin-bottom: 5px;
            font-size: 16px;
        }

        select,
        input[type="file"] {
            width: 100%;
            padding: 10px;
            margin-bottom: 20px;
            border: 2px solid #cce0ff;
            border-radius: 8px;
            font-size: 14px;
            background-color: #f2f7ff;
            box-sizing: border-box;
        }

        select:focus,
        input[type="file"]:focus {
            outline: none;
            border-color: var(--primary-blue);
            background-color: #e6f0ff;
        }

        .upload-btn {
            background-color: var(--primary-blue);
            color: white;
            border: none;
            padding: 12px;
            margin-top: 10px;
            width: 100%;
            border-radius: 8px;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        .upload-btn:hover {
            background-color: var(--dark-purple);
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
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
                <span><%= teacherName.substring(0, 1).toUpperCase() %></span>
            </div>
            <div class="profile-name"><%= teacherId %></div>
        </div>
        <div class="dropdown-content">
            <a href="teacherProfile.jsp">View Profile</a>
            <a href="teacherLogout.jsp">Logout</a>
        </div>
    </div>
</div>

<!-- Main Container -->
<div class="profile-container">
    <h2 class="syllabus-heading">Upload Syllabus PDF</h2>

    <% if ("success".equals(request.getParameter("upload"))) { %>
        <p class="success-msg">Syllabus uploaded successfully!</p>
    <% } %>

    <div class="container-box">
        <form action="TeacherSyllabusServlet" method="post" enctype="multipart/form-data">
            <label for="class_name">Select Class:</label>
            <select id="class_name" name="className" onchange="this.form.submit()" required>
                <option value="" disabled <%= (selectedClass == null) ? "selected" : "" %>>-- Select Class --</option>
                <% for (String cls : classList) { %>
                    <option value="<%= cls %>" <%= cls.equals(selectedClass) ? "selected" : "" %>><%= cls %></option>
                <% } %>
            </select>

            <label for="subject_name">Select Subject:</label>
            <select name="sub_name" id="subject_name" required>
                <option value="" disabled <%= (subjectList.isEmpty() || selectedClass == null) ? "selected" : "" %>>-- Select Subject --</option>
                <% if (!subjectList.isEmpty()) { %>
                    <% for (String sub : subjectList) { %>
                        <option value="<%= sub %>"><%= sub %></option>
                    <% } %>
                <% } else if (selectedClass != null) { %>
                    <option disabled>No subjects available</option>
                <% } %>
            </select>

            <label for="exam_code">Select Exam Type:</label>
            <select name="examCode" id="exam_code" required>
                <option value="" disabled <%= (examList.isEmpty()) ? "selected" : "" %>>-- Select Exam Type --</option>
                <% for (Map<String, String> exam : examList) { %>
                    <option value="<%= exam.get("examCode") %>"><%= exam.get("examName") %></option>
                <% } %>
            </select>

            <label for="syllabus_file">Upload Syllabus PDF:</label>
            <input type="file" name="syllabus_file" id="syllabus_file" accept="application/pdf" required>

            <button type="submit" class="upload-btn">Upload</button>
        </form>
    </div>
</div>
</body>
</html>