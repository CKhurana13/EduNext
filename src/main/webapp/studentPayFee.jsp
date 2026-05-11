<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>

<%
    session = request.getSession(false);
    if (session == null || session.getAttribute("s_id") == null) {
        response.sendRedirect("loginStudent.jsp");
        return;
    }

    String s_id = session.getAttribute("s_id").toString();

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    String url = "jdbc:mysql://localhost:3306/teacher_web?useUnicode=yes&characterEncoding=UTF-8";
    String dbUser = "root";
    String dbPassword = "vips";

    String s_name = "", class_name = "";
    double totalFee = 0, paidFee = 0, lateFee = 0, advanceFee = 0;
    double i1_due = 0, i2_due = 0, i3_due = 0;
    String i1_status = "", i2_status = "", i3_status = "";
    Date i1_date = null, i2_date = null, i3_date = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(url, dbUser, dbPassword);

        // Query to fetch student and fee details
        String sql = "SELECT s.s_name, s.class_name, f.* FROM student s LEFT JOIN fee f ON s.s_id = f.s_id WHERE s.s_id = ?";
        ps = conn.prepareStatement(sql);
        ps.setString(1, s_id);
        rs = ps.executeQuery();

        if (rs.next()) {
            s_name = rs.getString("s_name");
            class_name = rs.getString("class_name");
            totalFee = rs.getDouble("total_fee") != 0 ? rs.getDouble("total_fee") : 0;
            paidFee = rs.getDouble("paid_fee") != 0 ? rs.getDouble("paid_fee") : 0;
            lateFee = rs.getDouble("late_fee") != 0 ? rs.getDouble("late_fee") : 0;
            advanceFee = rs.getDouble("advance_fee") != 0 ? rs.getDouble("advance_fee") : 0;
            i1_due = rs.getDouble("installment1_due") != 0 ? rs.getDouble("installment1_due") : 0;
            i2_due = rs.getDouble("installment2_due") != 0 ? rs.getDouble("installment2_due") : 0;
            i3_due = rs.getDouble("installment3_due") != 0 ? rs.getDouble("installment3_due") : 0;
            i1_status = rs.getString("installment1_status");
            i2_status = rs.getString("installment2_status");
            i3_status = rs.getString("installment3_status");
            i1_date = rs.getDate("installment1_date");
            i2_date = rs.getDate("installment2_date");
            i3_date = rs.getDate("installment3_date");
        }

    } catch (Exception e) {
        out.println("<p>Error retrieving fee details: " + e.getMessage() + "</p>");
    } finally {
        try {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            out.println("<p>Error closing resources: " + e.getMessage() + "</p>");
        }
    }

    SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Fee Receipt</title>
    <style>
        :root {
            --blue: #003087;
            --green: #28a745;
            --red: #dc3545;
            --purple: #a678e2;
            --light: #f0f3fc;
            --text: #333;
            --light-bg: #f0f3fc;
        }

        body {
            font-family: 'Segoe UI', sans-serif;
            margin: 0;
            padding: 20px;
            background-color: var(--light-bg);
            background: repeating-linear-gradient(45deg, #e0e7ff 0, #e0e7ff 10px, #d1e0ff 10px, #d1e0ff 20px),
                        repeating-linear-gradient(-45deg, #e0e7ff 0, #e0e7ff 10px, #d1e0ff 10px, #d1e0ff 20px);
            background-blend-mode: overlay;
            display: flex;
            flex-direction: column;
            align-items: center;
            min-height: 100vh;
        }

        .logo-container {
            align-self: flex-start;
            padding: 20px;
        }

        .logo-container img {
            width: 140px;
            height: auto;
        }

        .container {
            background: white;
            padding: 20px;
            border-radius: 20px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
            max-width: 800px;
            width: 100%;
            margin-top: 10px;
            margin-bottom: 30px;
        }

        .header {
            display: flex;
            align-items: center;
            font-size: 20px;
            font-weight: bold;
            color: white;
            background-color: var(--blue);
            padding: 10px 15px;
            border-radius: 10px;
            margin-bottom: 20px;
        }

        .header a {
            font-style: normal;
            margin-right: 10px;
            cursor: pointer;
            color: white;
            text-decoration: none;
            font-size: 18px;
        }

        .fee-bar {
            background-color: #eef1f5;
            padding: 10px;
            border-radius: 8px;
            margin-bottom: 15px;
        }

        .fee-bar table {
            width: 100%;
            border-collapse: collapse;
        }

        .fee-bar th, .fee-bar td {
            padding: 8px;
            text-align: center;
            font-weight: bold;
            font-size: 14px;
        }

        .fee-bar th {
            background-color: #d9e2f3;
            color: #2c3e50;
        }

        .fee-bar td {
            color: #34495e;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
        }
        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ecf0f1;
        }
        th {
            background-color: #edf4fc;
            color: #2c3e50;
            font-weight: 500;
        }
        td {
            color: #34495e;
        }
        .installment-table th {
            background-color: #edf4fc;
        }
        .installment-table td {
            vertical-align: middle;
        }
        .download-btn, .pay-btn {
            background-color: var(--blue);
            color: white;
            border: none;
            padding: 5px 10px;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
        }
        .download-btn:hover, .pay-btn:hover {
            background-color: #002a6e;
        }
    </style>
</head>
<body>
    <div class="logo-container">
        <img src="images/logo.png" alt="School Logo" class="logo">
    </div>

    <div class="container">
        <div class="header">
            <a href="studentFee.jsp">←</a>PAY FEE
        </div>

        <div class="section-title">
            <h2>Student Details</h2>
        </div>
        <table>
            <tr><th>Student ID</th><td><%= s_id %></td></tr>
            <tr><th>Name</th><td><%= s_name %></td></tr>
            <tr><th>Class</th><td><%= class_name %></td></tr>
        </table>

        <div class="section-title">
            <h2>Fee Details</h2>
        </div>
        <div class="fee-bar">
            <table>
                <tr>
                    <th>Total Fee</th>
                    <th>Paid Fee</th>
                    <th>Advance Fee</th>
                    <th>Late Fee</th>
                </tr>
                <tr>
                    <td>₹<%= String.format("%.2f", totalFee) %></td>
                    <td>₹<%= String.format("%.2f", paidFee) %></td>
                    <td>₹<%= String.format("%.2f", advanceFee) %></td>
                    <td>₹<%= String.format("%.2f", lateFee) %></td>
                </tr>
            </table>
        </div>

        <div class="section-title">
            <h2>Installment Details</h2>
        </div>
        <table class="installment-table">
            <tr>
                <th>Installment</th>
                <th>Amount Due</th>
                <th>Status</th>
                <th>Payment Date</th>
                <th>Action</th>
            </tr>
            <tr>
                <td>Installment 1</td>
                <td>₹<%= String.format("%.2f", i1_due) %></td>
                <td><%= i1_status != null ? i1_status : "Unpaid" %></td>
                <td><%= i1_date != null ? sdf.format(i1_date) : "-" %></td>
                <td>
                    <% if ("Paid".equalsIgnoreCase(i1_status)) { %>
                        <a href="#" class="download-btn" onclick="downloadReceipt('Installment1_<%= s_id %>', '<%= i1_due %>', '<%= i1_date != null ? sdf.format(i1_date) : "-" %>')">Download Fee Receipt</a>
                    <% } else if ("Unpaid".equalsIgnoreCase(i1_status)) { %>
                        <a href="studentPayFee.jsp?installment=1&s_id=<%= s_id %>&amount=<%= i1_due %>" class="pay-btn">Pay Fee</a>
                    <% } %>
                </td>
            </tr>
            <tr>
                <td>Installment 2</td>
                <td>₹<%= String.format("%.2f", i2_due) %></td>
                <td><%= i2_status != null ? i2_status : "Unpaid" %></td>
                <td><%= i2_date != null ? sdf.format(i2_date) : "-" %></td>
                <td>
                    <% if ("Paid".equalsIgnoreCase(i2_status)) { %>
                        <a href="#" class="download-btn" onclick="downloadReceipt('Installment2_<%= s_id %>', '<%= i2_due %>', '<%= i2_date != null ? sdf.format(i2_date) : "-" %>')">Download Fee Receipt</a>
                    <% } else if ("Unpaid".equalsIgnoreCase(i2_status)) { %>
                        <a href="studentPayFee.jsp?installment=2&s_id=<%= s_id %>&amount=<%= i2_due %>" class="pay-btn">Pay Fee</a>
                    <% } %>
                </td>
            </tr>
            <tr>
                <td>Installment 3</td>
                <td>₹<%= String.format("%.2f", i3_due) %></td>
                <td><%= i3_status != null ? i3_status : "Unpaid" %></td>
                <td><%= i3_date != null ? sdf.format(i3_date) : "-" %></td>
                <td>
                    <% if ("Paid".equalsIgnoreCase(i3_status)) { %>
                        <a href="#" class="download-btn" onclick="downloadReceipt('Installment3_<%= s_id %>', '<%= i3_due %>', '<%= i3_date != null ? sdf.format(i3_date) : "-" %>')">Download Fee Receipt</a>
                    <% } else if ("Unpaid".equalsIgnoreCase(i3_status)) { %>
                        <a href="studentPayFee.jsp?installment=3&s_id=<%= s_id %>&amount=<%= i3_due %>" class="pay-btn">Pay Fee</a>
                    <% } %>
                </td>
            </tr>
        </table>

        <div class="section-title">
            <h2>Receipt Details</h2>
        </div>
        <table>
            <tr>
                <th>Receipt No</th>
                <th>Session Year</th>
                <th>Receipt Date</th>
                <th>Payment Type</th>
                <th>Amount</th>
                <th>Download</th>
            </tr>
            <%
                try {
                    conn = DriverManager.getConnection(url, dbUser, dbPassword);
                    String receiptSql = "SELECT * FROM fee_receipt WHERE s_id = ?";
                    ps = conn.prepareStatement(receiptSql);
                    ps.setString(1, s_id);
                    rs = ps.executeQuery();

                    while (rs.next()) {
                        String receiptNo = rs.getString("receipt_no");
                        String sessionYear = rs.getString("session_year");
                        Date receiptDate = rs.getDate("receipt_date");
                        String paymentType = rs.getString("payment_type");
                        double amount = rs.getDouble("amount");
                        String pdfUrl = rs.getString("pdf_url");
            %>
            <tr>
                <td><%= receiptNo %></td>
                <td><%= sessionYear %></td>
                <td><%= receiptDate != null ? sdf.format(receiptDate) : "-" %></td>
                <td><%= paymentType %></td>
                <td>₹<%= String.format("%.2f", amount) %></td>
                <td><a href="<%= pdfUrl %>" class="download-btn">Download PDF</a></td>
            </tr>
            <%
                    }
                } catch (Exception e) {
                    out.println("<p>Error retrieving receipt details: " + e.getMessage() + "</p>");
                } finally {
                    try {
                        if (rs != null) rs.close();
                        if (ps != null) ps.close();
                        if (conn != null) conn.close();
                    } catch (SQLException e) {
                        out.println("<p>Error closing resources: " + e.getMessage() + "</p>");
                    }
                }
            %>
        </table>
    </div>

    <script>
        function downloadReceipt(filename, amount, date) {
            const s_id = "<%= s_id %>";
            const name = "<%= s_name %>";
            const installment = filename.split('_')[0];
            const content = `EduNext Fee Receipt
------------------
Student ID: ${s_id}
Student Name: ${name}
Installment: ${installment}
Amount Paid: ₹${amount}
Payment Date: ${date}
Date of Issue: ${new Date().toLocaleDateString()}
            `;

            const blob = new Blob([content], { type: 'text/plain' });
            const url = window.URL.createObjectURL(blob);
            const a = document.createElement('a');
            a.href = url;
            a.download = filename + '.txt';
            a.click();
            window.URL.revokeObjectURL(url);
        }
    </script>
</body>
</html>