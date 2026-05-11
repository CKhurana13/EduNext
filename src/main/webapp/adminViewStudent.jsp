```jsp
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View Students by Class</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        :root {
            --primary-pink: #ffccd5;
            --secondary-pink: #ffb3c1;
            --light-purple: #b388eb;
            --dark-purple: #8a56d6;
            --darker-purple: #5e3a9b;
            --white: #ffffff;
            --light-bg: #f0f4f8;
            --text-dark: #333333;
            --text-light: #f0f0f0;
        }

        body {
            background-color: var(--light-bg);
            Ascending
            background: repeating-linear-gradient(45deg, var(--primary-pink) 0, var(--primary-pink) 10px, var(--secondary-pink) 10px, var(--secondary-pink) 20px),
                        repeating-linear-gradient(-45deg, var(--primary-pink) 0, var(--primary-pink) 10px, var(--secondary-pink) 10px, var(--secondary-pink) 20px);
            background-blend-mode: overlay;
            font-family: 'Poppins', sans-serif;
            position: relative;
            margin: 0;
            padding-bottom: 50px;
        }
        .logo {
            position: absolute;
            top: 20px;
            left: 20px;
            width: 100px;
            height: auto;
            z-index: 1000;
        }
        .main-container {
            background-color: rgba(255, 255, 255, 0.9);
            border-radius: 20px;
            padding: 40px;
            margin-top: 100px;
            margin-bottom: 50px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            max-width: 1200px; /* Increased from 900px to 1200px */
            margin-left: auto;
            margin-right: auto;
            text-align: center;
        }
        h1 {
            color: var(--darker-purple);
            font-weight: bold;
        }
        .form-group {
            margin-bottom: 15px;
        }
        label {
            font-weight: bold;
            color: var(--text-dark);
        }
        select {
            width: 100%;
            padding: 10px;
            border-radius: 6px;
            border: 1px solid #ccc;
            background-color: #f8f9ff;
            transition: box-shadow 0.3s ease-in-out;
        }
        select:focus {
            box-shadow: 0 0 5px 2px #9ab3f5;
            border-color: #7a9bf5;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            padding: 10px;
            text-align: left;
            border: 1px solid #ddd;
        }
        th {
            background-color: var(--light-purple);
            color: var(--white);
        }
        .btn-primary {
            background-color: var(--dark-purple);
            border-color: var(--dark-purple);
            border-radius: 50px;
            padding: 10px 20px;
            font-size: 16px;
            font-weight: 600;
        }
        .btn-primary:hover {
            background-color: var(--secondary-pink);
        }
        .btn-back {
            background-color: var(--light-purple);
            border-color: var(--light-purple);
            border-radius: 50px;
            padding: 10px 20px;
            font-size: 16px;
            font-weight: 600;
            color: var(--white);
            text-decoration: none;
        }
        .btn-back:hover {
            background-color: var(--secondary-pink);
        }
    </style>
</head>
<body>
    <img src="images/logo.png" alt="School Logo" class="logo">

    <div class="main-container">
        <h1 class="mb-4">🏫 View Students by Class</h1>

        <%
            Connection conn = null;
            Statement stmt = null;
            ResultSet rs = null;
            List<String> classNames = new ArrayList<>();
            String selectedClass = request.getParameter("class_name");

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/teacher_web", "root", "vips");
                stmt = conn.createStatement();

                // Fetch distinct class names
                rs = stmt.executeQuery("SELECT DISTINCT class_name FROM student WHERE class_name IS NOT NULL");
                while (rs.next()) {
                    classNames.add(rs.getString("class_name"));
                }
                rs.close();
        %>

        <form action="adminViewStudent.jsp" method="get" class="form-group">
            <label for="class_name">Select Class:</label>
            <select id="class_name" name="class_name" onchange="this.form.submit()" required>
                <option value="">-- Select Class --</option>
                <%
                    for (String className : classNames) {
                %>
                <option value="<%= className %>" <%= className.equals(selectedClass) ? "selected" : "" %>><%= className %></option>
                <%
                    }
                %>
            </select>
        </form>

        <%
                if (selectedClass != null && !selectedClass.isEmpty()) {
                    // Fetch students for the selected class
                    PreparedStatement pstmt = conn.prepareStatement("SELECT s_id, s_name, class_name, f_name, m_name, s_email, phone, dob, doa FROM student WHERE class_name = ?");
                    pstmt.setString(1, selectedClass);
                    rs = pstmt.executeQuery();
        %>
        <table>
            <thead>
                <tr>
                    <th>Student ID</th>
                    <th>Name</th>
                    <th>Class</th>
                    <th>Father's Name</th>
                    <th>Mother's Name</th>
                    <th>Email</th>
                    <th>Phone</th>
                    <th>Date of Birth</th>
                    <th>Date of Admission</th>
                </tr>
            </thead>
            <tbody>
                <%
                    boolean hasStudents = false;
                    while (rs.next()) {
                        hasStudents = true;
                        String sId = rs.getString("s_id");
                        String sName = rs.getString("s_name");
                        String className = rs.getString("class_name");
                        String fName = rs.getString("f_name");
                        String mName = rs.getString("m_name");
                        String sEmail = rs.getString("s_email");
                        String phone = rs.getString("phone");
                        String dob = rs.getString("dob");
                        String doa = rs.getString("doa");
                %>
                <tr>
                    <td><%= sId != null ? sId : "-" %></td>
                    <td><%= sName != null ? sName : "-" %></td>
                    <td><%= className != null ? className : "-" %></td>
                    <td><%= fName != null ? fName : "-" %></td>
                    <td><%= mName != null ? mName : "-" %></td>
                    <td><%= sEmail != null ? sEmail : "-" %></td>
                    <td><%= phone != null ? phone : "-" %></td>
                    <td><%= dob != null ? dob : "-" %></td>
                    <td><%= doa != null ? doa : "-" %></td>
                </tr>
                <%
                    }
                    rs.close();
                    pstmt.close();
                    if (!hasStudents) {
                %>
                <tr>
                    <td colspan="9" class="text-center">No students found for class <%= selectedClass %>.</td>
                </tr>
                <%
                    }
                }
        %>
            </tbody>
        </table>

        <div class="text-center mt-4">
            <a href="adminFeeSection.jsp" class="btn btn-back">Back to Admin Dashboard</a>
        </div>

        <%
            } catch (Exception e) {
                e.printStackTrace();
                out.println("<div class='alert alert-danger mt-3'>Error: " + e.getMessage() + "</div>");
            } finally {
                if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
                if (stmt != null) try { stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
                if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
        %>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
```