<%@ page import="java.sql.*, java.text.SimpleDateFormat" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    session = request.getSession(false); 
    if (session == null || session.getAttribute("s_id") == null) {
        response.sendRedirect("studentLogin.jsp");
        return;
    }
    
    String s_id = session.getAttribute("s_id").toString();
    int totalFee = 0, paidFee = 0, dueFee = 0, lateFee = 0, advanceFee = 0;
    double installment1Due = 0, installment2Due = 0, installment3Due = 0;

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/teacher_web", "root", "vips");
        
        // Fetch fee details
        ps = conn.prepareStatement("SELECT * FROM fee WHERE s_id = ?");
        ps.setString(1, s_id);
        rs = ps.executeQuery();
        
        if (rs.next()) {
            totalFee = rs.getInt("total_fee");
            paidFee = rs.getInt("paid_fee");
            lateFee = rs.getInt("late_fee");
            advanceFee = rs.getInt("advance_fee");
            installment1Due = rs.getDouble("installment1_due");
            installment2Due = rs.getDouble("installment2_due");
            installment3Due = rs.getDouble("installment3_due");
            // Calculate dueFee as total_fee - paid_fee + late_fee (adjust for unpaid installments if needed)
            dueFee = totalFee - paidFee + lateFee;
        } else {
            out.println("<p class='no-data'>No fee data found for student ID: " + s_id + "</p>");
        }

        // Validate paid_fee with fee_receipt
        ps.close();
        ps = conn.prepareStatement("SELECT SUM(amount) as total_paid FROM fee_receipt WHERE s_id = ? AND session_year = '2025-26'");
        ps.setString(1, s_id);
        rs = ps.executeQuery();
        if (rs.next()) {
            int totalPaidFromReceipts = rs.getInt("total_paid");
            if (totalPaidFromReceipts > 0) {
                paidFee = totalPaidFromReceipts; // Override paid_fee with actual receipts if higher
                dueFee = totalFee - paidFee + lateFee;
            }
        }

    } catch(Exception e) {
        out.println("<p class='no-data'>Error loading fee data: " + e.getMessage() + "</p>");
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (ps != null) try { ps.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Fee Dashboard - EDUNEXT</title>
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
        }

        body {
            font-family: Arial, sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            padding: 20px;
            background-color: var(--light-bg);
            background: repeating-linear-gradient(45deg, #e0e7ff 0, #e0e7ff 10px, #d1e0ff 10px, #d1e0ff 20px),
                        repeating-linear-gradient(-45deg, #e0e7ff 0, #e0e7ff 10px, #d1e0ff 10px, #d1e0ff 20px);
            background-blend-mode: overlay;
            position: relative;
        }
        .header {
            position: absolute;
            top: 20px;
            left: 20px;
        }
        .header img {
            width: 100px;
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
        }
        .tab-container {
            display: flex;
            align-items: center;
            width: 100%;
            margin-bottom: 40px;
        }
        .tab-arrow {
            color: #3498db;
            font-size: 18px;
            font-weight: bold;
            cursor: pointer;
            padding: 10px;
        }
        .tab {
            background-color: #3498db;
            color: var(--white);
            padding: 10px;
            border-radius: 10px 10px 0 0;
            font-size: 18px;
            font-weight: bold;
            display: flex;
            justify-content: center;
            align-items: center;
            cursor: pointer;
            width: 100%;
            box-sizing: border-box;
        }
        .tab:hover {
            background-color: #3498db;
        }
        .grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 15px;
            position: relative;
            min-height: 220px;
            width: 100%;
            max-width: 600px;
            margin-left: auto;
            margin-right: auto;
        }
        .grid div {
            background-color: #2c3e50;
            color: white;
            padding: 20px;
            border-radius: 5px;
            font-size: 20px;
            height: 80px;
            display: flex;
            justify-content: center;
            align-items: center;
        }
        .paid-fee {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            background-color: transparent;
            display: flex;
            justify-content: center;
            align-items: center;
            z-index: 1;
        }
        .paid-fee .circle {
            width: 90px;
            height: 90px;
            background: #3498db;
            border-radius: 50%;
            display: flex;
            justify-content: center;
            align-items: center;
            position: relative;
            color: white;
            font-size: 16px;
            transition: transform 0.3s ease;
        }
        .paid-fee .circle:hover {
            transform: scale(1.1);
        }
        .paid-fee .circle::before {
            content: '';
            position: absolute;
            width: 128px;
            height: 128px;
            background: rgba(255, 255, 255, 0.2);
            border-radius: 50%;
            z-index: -1;
        }
        .buttons {
            display: flex;
            justify-content: space-around;
            margin-top: 20px;
            width: 70%;
            margin-left: auto;
            margin-right: auto;
        }
        .buttons button {
            background-color: #3498db;
            color: white;
            border: none;
            padding: 12px 30px;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            role: button;
        }
        .buttons button:hover {
            background-color: #2980b9;
        }
        /* Responsiveness */
        @media (max-width: 600px) {
            .container {
                width: 95%;
                padding: 20px;
            }
            .tab-container {
                flex-direction: row;
                align-items: center;
                margin-bottom: 30px;
            }
            .tab {
                font-size: 16px;
                padding: 8px;
            }
            .tab-arrow {
                font-size: 16px;
                padding: 8px;
            }
            .grid {
                grid-template-columns: 1fr;
                gap: 10px;
                min-height: 380px;
                width: 90%;
            }
            .grid div {
                height: 70px;
                font-size: 18px;
            }
            .paid-fee .circle {
                width: 96px;
                height: 96px;
                font-size: 14.4px;
            }
            .header img {
                width: 80px;
                top: 10px;
                left: 10px;
            }
            .buttons {
                flex-direction: column;
                gap: 12px;
                width: 90%;
            }
            .buttons button {
                padding: 10px 24px;
                font-size: 14px;
            }
        }
    </style>
</head>
<body>
    <div class="header">
        <img src="images/logo.png" alt="EDUNEXT Educational Platform Logo">
    </div>
    <div class="container">
        <div class="tab-container">
            <span class="tab-arrow" onclick="goToDashboard()">←</span>
            <div class="tab">FEE</div>
        </div>
        <div class="grid">
            <div>TOTAL FEE<br>₹<%= totalFee %></div>
            <div>FEE DUE<br>₹<%= dueFee %></div>
            <div>LATE FEE<br>₹<%= lateFee %></div>
            <div>ADVANCE FEE<br>₹<%= advanceFee %></div>
            <div class="paid-fee">
                <div class="circle">PAID FEE<br>₹<%= paidFee %></div>
            </div>
        </div>
        <div class="buttons">
            <button role="button" aria-label="View Fee Receipt" onclick="viewReceipt()">Fee Receipt</button>
            <button role="button" aria-label="Pay Outstanding Fee" onclick="payFee()">Pay Fee</button>
        </div>
    </div>
    <script>
        function viewReceipt() {
            window.location.href = 'studentFeeReceipt.jsp';
        }
        function payFee() {
            window.location.href = 'studentPayFee.jsp';
        }
        function goToDashboard() {
            window.location.href = 'dashboardStudent.jsp';
        }
    </script>
</body>
</html>