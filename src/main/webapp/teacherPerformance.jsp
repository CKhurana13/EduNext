<%@ page import="java.util.*, java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String t_id = (String) session.getAttribute("t_id");
    if (t_id == null) {
        response.sendRedirect("teacherLogin.jsp");
        return;
    }

    String selectedClass = request.getParameter("class_name");
    String selectedSubject = request.getParameter("subject");

    List<String> classList = new ArrayList<>();
    List<Map<String, String>> subjectList = new ArrayList<>();
    List<Map<String, String>> studentList = new ArrayList<>();

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/teacher_web", "root", "vips");

        // Get classes assigned to the teacher
        PreparedStatement ps = conn.prepareStatement("SELECT classes FROM teacher WHERE t_id = ?");
        ps.setString(1, t_id);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            String[] clsArr = rs.getString("classes").split(",");
            for (String cls : clsArr) {
                if (!cls.trim().isEmpty()) classList.add(cls.trim());
            }
        }
        rs.close();
        ps.close();

        // Get subjects for selected class and teacher
        if (selectedClass != null) {
            PreparedStatement ps2 = conn.prepareStatement(
                "SELECT sub_id, sub_name FROM subjects WHERE classes = ? AND t_id = ?"
            );
            ps2.setString(1, selectedClass);
            ps2.setString(2, t_id);
            ResultSet rs2 = ps2.executeQuery();

            while (rs2.next()) {
                Map<String, String> subject = new HashMap<>();
                subject.put("id", rs2.getString("sub_id"));
                subject.put("name", rs2.getString("sub_name"));
                subjectList.add(subject);
            }
            rs2.close();
            ps2.close();
        }

        // Get students from selected class
        if (selectedClass != null && selectedSubject != null) {
            PreparedStatement ps3 = conn.prepareStatement("SELECT s_id, s_name FROM student WHERE class_name = ?");
            ps3.setString(1, selectedClass);
            ResultSet rs3 = ps3.executeQuery();

            while (rs3.next()) {
                Map<String, String> student = new HashMap<>();
                student.put("s_id", rs3.getString("s_id"));
                student.put("s_name", rs3.getString("s_name"));
                studentList.add(student);
            }
            rs3.close();
            ps3.close();
        }

        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
    }

    boolean showForm = (studentList == null || studentList.isEmpty());
%>

<!DOCTYPE html>
<html>
<head>
    <title>Performance</title>
    
    <script>history.replaceState(null, null, location.href);</script>
</head>
<body>

<div class="header">
    <img src="images/logo.png" class="header-logo" />
    <div class="header-logout">
        <a href="LogoutServlet">Logout</a>
    </div>
</div>

<div class="container">
    <h2>Performance</h2>

    <% if (showForm) { %>
        <form method="get" action="Performance.jsp">
            <label><b>Select Class:</b></label>
            <select name="class_name" required onchange="this.form.submit()">
                <option disabled selected>-- Select Class --</option>
                <% for (String cls : classList) { %>
                    <option value="<%= cls %>" <%= (cls.equals(selectedClass) ? "selected" : "") %>><%= cls %></option>
                <% } %>
            </select>

            <% if (selectedClass != null && !subjectList.isEmpty()) { %>
                <label><b>Select Subject:</b></label>
                <select name="subject" required>
                    <option disabled selected>-- Select Subject --</option>
                    <% for (Map<String, String> sub : subjectList) { %>
                        <option value="<%= sub.get("id") %>" <%= (sub.get("id").equals(selectedSubject) ? "selected" : "") %>>
                            <%= sub.get("name") %>
                        </option>
                    <% } %>
                </select>
                <button type="submit">View Students</button>
            <% } %>
        </form>
    <% } else { %>
        <p><b>Class Selected:</b> <%= selectedClass %></p>
        <p><b>Subject Selected:</b> 
        <%
            for (Map<String, String> sub : subjectList) {
                if (sub.get("id").equals(selectedSubject)) out.print(sub.get("name"));
            }
        %></p>
    <% } %>

    <% if (!studentList.isEmpty()) { %>
        <div class="table-container">
            <table class="styled-table">
                <thead>
                <tr>
                    <th>Student ID</th>
                    <th>Name</th>
                    <th>Actions</th>
                </tr>
                </thead>
                <tbody>
                <% for (Map<String, String> student : studentList) { %>
                    <tr>
                        <td><%= student.get("s_id") %></td>
                        <td><%= student.get("s_name") %></td>
                        <td>
                            <form method="get" action="Teacher_ViewMarksServlet" style="display:inline;">
                                <input type="hidden" name="s_id" value="<%= student.get("s_id") %>">
                                <input type="hidden" name="class_name" value="<%= selectedClass %>">
                                <input type="hidden" name="subject" value="<%= selectedSubject %>">
                                <button type="submit">View</button>
                            </form>
                            <form method="get" action="Teacher_EditMarksPageServlet" style="display:inline;">
                                <input type="hidden" name="s_id" value="<%= student.get("s_id") %>">
                                <input type="hidden" name="class_name" value="<%= selectedClass %>">
                                <input type="hidden" name="subject" value="<%= selectedSubject %>">
                                <button type="submit">Update</button>
                            </form>
                        </td>
                    </tr>
                <% } %>
                </tbody>
            </table>
        </div>
    <% } else if (selectedClass != null && selectedSubject != null) { %>
        <div class="no-data">No students found for the selected class and subject.</div>
    <% } %>
</div>

<% if ("1".equals(request.getParameter("success"))) { %>
    <div id="toast"
         style="position: fixed; bottom: 30px; right: 30px; background-color: #4CAF50; color: white; padding: 16px 24px; border-radius: 8px; box-shadow: 0 4px 6px rgba(0,0,0,0.2); font-size: 16px; z-index: 9999;">
        ✅ Marks Updated Successfully!
    </div>
    <script>
        setTimeout(() => {
            const toast = document.getElementById('toast');
            if (toast) toast.remove();
        }, 3000);
    </script>
<% } %>

</body>
</html>