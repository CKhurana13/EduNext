<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, java.text.SimpleDateFormat" %>
<%
    // Check session
    session = request.getSession(false);
    if (session == null || session.getAttribute("s_id") == null) {
        response.sendRedirect("studentLogin.jsp");
        return;
    }

    String s_id = session.getAttribute("s_id").toString();

    // DB details
    String dbURL = "jdbc:mysql://localhost:3306/teacher_web";
    String dbUser = "root";
    String dbPass = "vips";

    // Get selected session (default to current year)
    String selectedSession = request.getParameter("sessionYear");
    if (selectedSession == null) selectedSession = "2025-26";

    // Fetch Fee Summary
    double totalFee = 0, paidFee = 0, lateFee = 0, advanceFee = 0;
    List<Map<String, String>> receipts = new ArrayList<>();

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPass);

        // Fetch fee details
        PreparedStatement feeStmt = conn.prepareStatement(
            "SELECT total_fee, paid_fee, late_fee, advance_fee FROM fee WHERE s_id = ?"
        );
        feeStmt.setString(1, s_id);
        ResultSet feeRs = feeStmt.executeQuery();
        if (feeRs.next()) {
            totalFee = feeRs.getDouble("total_fee");
            paidFee = feeRs.getDouble("paid_fee");
            lateFee = feeRs.getDouble("late_fee");
            advanceFee = feeRs.getDouble("advance_fee");
        }
        feeRs.close();
        feeStmt.close();

        // Fetch receipts
        PreparedStatement receiptStmt = conn.prepareStatement(
            "SELECT * FROM fee_receipt WHERE s_id = ? AND session_year = ? ORDER BY receipt_date DESC"
        );
        receiptStmt.setString(1, s_id);
        receiptStmt.setString(2, selectedSession);
        ResultSet rs = receiptStmt.executeQuery();

        SimpleDateFormat sdf = new SimpleDateFormat("d MMMM yyyy");
        while (rs.next()) {
            Map<String, String> map = new HashMap<>();
            map.put("date", sdf.format(rs.getDate("receipt_date")));
            map.put("number", rs.getString("receipt_no"));
            map.put("type", rs.getString("payment_type"));
            map.put("amount", rs.getString("amount"));
            map.put("pdf", rs.getString("pdf_url"));
            receipts.add(map);
        }

        rs.close();
        receiptStmt.close();
        conn.close();
    } catch (Exception e) {
        out.println("<div style='color:red;'>Error: " + e.getMessage() + "</div>");
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Fee Receipt</title>
    <style>
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
            --navy-blue: #1a2a44;
            --light-gray: #d3d3d3;
            --light-blue: #b3c9e6;
        }

        body {
            font-family: 'Arial', sans-serif;
            margin: 0;
            padding: 20px;
            background-color: var(--light-bg);
            background: repeating-linear-gradient(45deg, #e0e7ff 0, #e0e7ff 10px, #d1e0ff 10px, #d1e0ff 20px),
                        repeating-linear-gradient(-45deg, #e0e7ff 0, #e0e7ff 10px, #d1e0ff 10px, #d1e0ff 20px);
            background-blend-mode: overlay;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            position: relative;
        }

        .logo {
            position: absolute;
            top: 20px;
            left: 20px;
            width: 100px;
            height: auto;
        }

        .container {
            background: var(--white);
            padding: 30px;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(107, 140, 255, 0.2);
            text-align: center;
            position: relative;
            width: 100%;
            max-width: 1000px;
            min-height: 450px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            z-index: 1;
        }

        .tab-container {
            display: flex;
            align-items: center;
            width: 100%;
            margin-bottom: 40px;
        }

        .tab-arrow {
            color: #3498db;
            font-size: 15px;
            font-weight: bold;
            cursor: pointer;
            padding: 10px;
        }

        .header {
            background: var(--navy-blue);
            color: var(--white);
            padding: 10px;
            border-radius: 10px 10px 0 0;
            text-align: center;
            font-size: 18px;
            font-weight: bold;
            display: flex;
            justify-content: center;
            align-items: center;
            width: 100%;
            box-sizing: border-box;
        }

        .session {
            background: var(--light-blue);
            padding: 10px;
            border-radius: 0 0 10px 10px;
            margin-top: 0;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .session span.download-text {
            margin-left: 20px;
            text-align: left;
            font-size: 16px;
        }

        .session .session-wrapper {
            display: flex;
            align-items: center;
            margin-right: 20px;
        }

        .session .session-label {
            font-size: 16px;
            margin-right: 10px;
            color: var(--navy-blue);
        }

        .session select {
            background: var(--navy-blue);
            color: var(--white);
            border: none;
            padding: 5px;
            border-radius: 5px;
            cursor: pointer;
        }

        .fee-summary {
            margin: 20px 0;
            padding: 15px;
            background: var(--light-gray);
            border-radius: 10px;
            text-align: left;
        }

        .fee-summary p {
            margin: 5px 0;
            font-size: 16px;
            color: var(--text-dark);
        }

        .receipt {
            margin: 20px 0;
            background: var(--navy-blue);
            color: var(--white);
            padding: 10px;
            border-radius: 10px;
            position: relative;
            text-align: left;
        }

        .receipt .dot {
            width: 30px;
            height: 30px;
            background: var(--light-blue);
            border-radius: 50%;
            position: absolute;
            left: 10px;
            top: 50%;
            transform: translateY(-50%);
        }

        .receipt span {
            margin-left: 50px;
            display: inline-block;
        }

        .receipt button {
            position: absolute;
            right: 10px;
            top: 50%;
            transform: translateY(-50%);
            background: var(--light-blue);
            color: var(--navy-blue);
            padding: 5px 10px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
        }

        .receipt button:hover {
            background: var(--primary-blue);
            color: var(--white);
        }

        .date {
            background: var(--light-gray);
            padding: 5px;
            margin: 10px 0;
            text-align: left;
            padding-left: 20px;
        }

        .no-data {
            margin: 20px 0;
            color: var(--text-dark);
            font-size: 16px;
            text-align: left;
            padding-left: 20px;
        }

        @media (max-width: 600px) {
            .container {
                width: 95%;
                padding: 20px;
            }
            .logo {
                width: 80px;
                top: 10px;
                left: 10px;
            }
            .tab-container {
                flex-direction: row;
                align-items: center;
                margin-bottom: 30px;
            }
            .tab-arrow {
                font-size: 16px;
                padding: 8px;
            }
            .header {
                font-size: 16px;
                padding: 8px;
            }
            .session span.download-text {
                font-size: 14px;
                margin-left: 10px;
            }
            .session .session-label {
                font-size: 14px;
                margin-right: 5px;
            }
            .session select {
                margin-right: 10px;
                padding: 4px;
            }
            .receipt .dot {
                width: 25px;
                height: 25px;
            }
            .receipt span {
                margin-left: 40px;
            }
            .date {
                padding-left: 15px;
            }
            .no-data {
                padding-left: 15px;
            }
        }
    </style>
</head>
<body>
    <img src="images/logo.png" alt="EduNext Logo" class="logo">
    <div class="container">
        <div class="tab-container">
            <span class="tab-arrow" onclick="goToDashboard()">←</span>
            <div class="header">FEE RECEIPT</div>
        </div>

        <div class="session">
            <span class="download-text">DOWNLOAD FEE RECEIPT ANYTIME</span>
            <div class="session-wrapper">
                <span class="session-label">SESSION</span>
                <form method="get" style="display: inline;">
                    <select name="sessionYear" onchange="this.form.submit()">
                        <option <%= "2023-24".equals(selectedSession) ? "selected" : "" %>>2023-24</option>
                        <option <%= "2024-25".equals(selectedSession) ? "selected" : "" %>>2024-25</option>
                        <option <%= "2025-26".equals(selectedSession) ? "selected" : "" %>>2025-26</option>
                    </select>
                </form>
            </div>
        </div>

        <div class="fee-summary">
            <p>Total Fee: ₹<%= String.format("%.2f", totalFee) %></p>
            <p>Paid Fee: ₹<%= String.format("%.2f", paidFee) %></p>
            <p>Late Fee: ₹<%= String.format("%.2f", lateFee) %></p>
            <p>Advance Fee: ₹<%= String.format("%.2f", advanceFee) %></p>
            <p>Remaining Fee: ₹<%= String.format("%.2f", totalFee - paidFee) %></p>
        </div>

        <div id="receiptContainer">
            <%
                if (receipts.size() == 0) {
            %>
                <div class="no-data">No fee receipts available for session <%= selectedSession %>.</div>
            <%
                } else {
                    for (Map<String, String> r : receipts) {
            %>
                <div class="date"><%= r.get("date") %></div>
                <div class="receipt">
                    <div class="dot"></div>
                    <span><%= r.get("number") %><br><%= r.get("type") %><br>₹<%= r.get("amount") %></span>
                    <button onclick="window.location.href='<%= r.get("pdf") %>'">Download</button>
                </div>
            <%
                    }
                }
            %>
        </div>
    </div>

    <script>
        function goToDashboard() {
            window.location.href = 'dashboardStudent.jsp';
        }
    </script>
</body>
</html>