<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin - Installment Records</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        /* ... (same styling as before) ... */
    </style>
</head>
<body>
    <div class="container">
        <h2 class="text-center">Admin - All Installment Records</h2>

        <% if (request.getParameter("success") != null) { %>
            <div class="alert alert-success text-center">✅ Record inserted successfully!</div>
        <% } %>

        <div class="table-responsive">
            <table class="table table-bordered table-hover">
                <thead>
                    <tr>
                        <!-- Table Headers -->
                        <th>S_ID</th><th>Class Name</th><th>Total Fee</th><th>Paid Fee</th><th>Late Fee</th><th>Advance Fee</th>
                        <th>Installment 1 Due</th><th>Installment 2 Due</th><th>Installment 3 Due</th>
                        <th>Installment 1 Status</th><th>Installment 2 Status</th><th>Installment 3 Status</th>
                        <th>Installment 1 Date</th><th>Installment 2 Date</th><th>Installment 3 Date</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        try (
                            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/teacher_web", "root", "vips");
                            PreparedStatement stmt = conn.prepareStatement("SELECT * FROM fee");
                            ResultSet rs = stmt.executeQuery()
                        ) {
                            Class.forName("com.mysql.cj.jdbc.Driver");

                            while (rs.next()) {
                    %>
                    <tr>
                        <td><%= rs.getString("s_id") %></td>
                        <td><%= rs.getString("className") %></td>
                        <td><%= rs.getDouble("total_fee") %></td>
                        <td><%= rs.getDouble("paid_fee") %></td>
                        <td><%= rs.getDouble("late_fee") %></td>
                        <td><%= rs.getDouble("advance_fee") %></td>
                        <td><%= rs.getDouble("installment1_due") %></td>
                        <td><%= rs.getDouble("installment2_due") %></td>
                        <td><%= rs.getDouble("installment3_due") %></td>
                        <td><%= rs.getString("installment1_status") %></td>
                        <td><%= rs.getString("installment2_status") %></td>
                        <td><%= rs.getString("installment3_status") %></td>
                        <td><%= rs.getDate("installment1_date") %></td>
                        <td><%= rs.getDate("installment2_date") %></td>
                        <td><%= rs.getDate("installment3_date") %></td>
                    </tr>
                    <%
                            }
                        } catch (Exception e) {
                    %>
                    <tr>
                        <td colspan="15" class="text-danger text-center fw-bold">Error: <%= e.getMessage() %></td>
                    </tr>
                    <%
                        }
                    %>
                </tbody>
            </table>
        </div>

        <div class="text-center btn-back">
            <a href="fee.jsp" class="btn btn-secondary shadow-sm">Back to Entry</a>
        </div>
    </div>
</body>
</html>