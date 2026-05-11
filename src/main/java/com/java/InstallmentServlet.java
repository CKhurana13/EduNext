package com.java;

import java.io.IOException;
import java.sql.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/InstallmentServlet")
public class InstallmentServlet extends HttpServlet {
    private static final String DB_URL = "jdbc:mysql://localhost:3306/teacher_web";
    private static final String DB_USER = "root";
    private static final String DB_PASS = "vips";

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html");

        try {
            String s_id = request.getParameter("s_id");
            String className = request.getParameter("className");
            double total_fee = Double.parseDouble(request.getParameter("total_fee"));
            double paid_fee = Double.parseDouble(request.getParameter("paid_fee"));
            double late_fee = Double.parseDouble(request.getParameter("late_fee"));
            double advance_fee = Double.parseDouble(request.getParameter("advance_fee"));
            double installment1_due = Double.parseDouble(request.getParameter("installment1_due"));
            double installment2_due = Double.parseDouble(request.getParameter("installment2_due"));
            double installment3_due = Double.parseDouble(request.getParameter("installment3_due"));
            String installment1_status = request.getParameter("installment1_status");
            String installment2_status = request.getParameter("installment2_status");
            String installment3_status = request.getParameter("installment3_status");
            String installment1_date = request.getParameter("installment1_date");
            String installment2_date = request.getParameter("installment2_date");
            String installment3_date = request.getParameter("installment3_date");

            Class.forName("com.mysql.cj.jdbc.Driver");

            try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
                 PreparedStatement pstmt = conn.prepareStatement(
                        "INSERT INTO fee (s_id, className, total_fee, paid_fee, late_fee, advance_fee, " +
                        "installment1_due, installment2_due, installment3_due, installment1_status, " +
                        "installment2_status, installment3_status, installment1_date, installment2_date, installment3_date) " +
                        "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)")) {

                pstmt.setString(1, s_id);
                pstmt.setString(2, className);
                pstmt.setDouble(3, total_fee);
                pstmt.setDouble(4, paid_fee);
                pstmt.setDouble(5, late_fee);
                pstmt.setDouble(6, advance_fee);
                pstmt.setDouble(7, installment1_due);
                pstmt.setDouble(8, installment2_due);
                pstmt.setDouble(9, installment3_due);
                pstmt.setString(10, installment1_status);
                pstmt.setString(11, installment2_status);
                pstmt.setString(12, installment3_status);
                pstmt.setDate(13, java.sql.Date.valueOf(installment1_date));
                pstmt.setDate(14, java.sql.Date.valueOf(installment2_date));
                pstmt.setDate(15, java.sql.Date.valueOf(installment3_date));

                pstmt.executeUpdate();
            }

            response.sendRedirect("admin.jsp?success=1");

        } catch (Exception e) {
            request.setAttribute("error", "Error: " + e.getMessage());
            request.getRequestDispatcher("index.jsp").forward(request, response);
        }
    }
}