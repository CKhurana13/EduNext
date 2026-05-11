<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin - Installment Records</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(120deg, #f8f9fa, #e0e7ff);
            font-family: 'Segoe UI', sans-serif;
        }
        .container {
            margin-top: 50px;
            background-color: white;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.1);
        }
        h2 {
            margin-bottom: 30px;
            color: #0d6efd;
            font-weight: 600;
        }
        .table-responsive {
            max-height: 600px;
            overflow-y: auto;
            border-radius: 10px;
        }
         .logo {
            position: absolute;
            top: 20px;
            left: 20px;
            width: 100px;
            height: auto;
            z-index: 1000;
        }
        table {
            border: 1px solid #dee2e6;
        }
        th {
            background-color: #0d6efd;
            color: white;
            position: sticky;
            top: 0;
            z-index: 1;
        }
        td, th {
            text-align: center;
            vertical-align: middle;
        }
        tr:hover {
            background-color: #f1f5ff;
        }
        .btn-back {
            margin-top: 30px;
        }
        .btn-back a {
            padding: 10px 25px;
            font-size: 16px;
            border-radius: 25px;
        }
    </style>
</head>
<body>
<img src="images/logo.png" alt="School Logo" class="logo">
    <div class="container">
        <h2 class="text-center">Admin - All Installment Records</h2>
        <div class="table-responsive">
            <table class="table table-bordered table-hover">
                <thead>
                    <tr>
                        <th>S_ID</th>
                        <th>Class Name</th>
                        <th>Total Fee</th>
                        <th>Paid Fee</th>
                        <th>Late Fee</th>
                        <th>Advance Fee</th>
                        <th>Installment 1 Due</th>
                        <th>Installment 2 Due</th>
                        <th>Installment 3 Due</th>
                        <th>Installment 1 Status</th>
                        <th>Installment 2 Status</th>
                        <th>Installment 3 Status</th>
                        <th>Installment 1 Date</th>
                        <th>Installment 2 Date</th>
                        <th>Installment 3 Date</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        Connection conn = null;
                        Statement stmt = null;
                        ResultSet rs = null;
                        try {
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/teacher_web", "root", "vips");
                            stmt = conn.createStatement();
                            rs = stmt.executeQuery("SELECT * FROM fee");
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
                        } finally {
                            if (rs != null) rs.close();
                            if (stmt != null) stmt.close();
                            if (conn != null) conn.close();
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
admin.jsp