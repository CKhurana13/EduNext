<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head><title>Your Classes</title></head>
<body>
<h2>Your Classes</h2>
<ul>
    <%
        List<String> classes = (List<String>) request.getAttribute("classes");
        if (classes != null && !classes.isEmpty()) {
            for (String cls : classes) {
    %>
        <li><a href="student-report?action=students&class=<%=cls%>"><%=cls%></a></li>
    <%
            }
        } else {
    %>
        <li>No classes assigned to you.</li>
    <%
        }
    %>
</ul>
</body>
</html>
