package com.java;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.*;

@WebServlet("/circular")
public class circular extends HttpServlet {
    private static final String DB_URL = "jdbc:mysql://localhost:3306/teacher_web";
    private static final String DB_USER = "root";
    private static final String DB_PASS = "vips";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        // Get form parameters
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String issueDateStr = request.getParameter("issueDate");

        Connection conn = null;
        PreparedStatement stmt = null;
        String message = null;

        try {
            // Validate required fields
            if (title == null || title.trim().isEmpty() || description == null || description.trim().isEmpty() ||
                issueDateStr == null || issueDateStr.trim().isEmpty()) {
                message = "All fields (Title, Description, Issue Date) are required.";
            } else {
                // Load driver and connect to database
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

                // Prepare and execute SQL (id is auto-increment)
                String sql = "INSERT INTO circulars (title, description, issue_date) VALUES (?, ?, ?)";
                stmt = conn.prepareStatement(sql);
                stmt.setString(1, title.trim());
                stmt.setString(2, description.trim());
                stmt.setDate(3, Date.valueOf(issueDateStr));

                int row = stmt.executeUpdate();
                if (row > 0) {
                    message = "Circular inserted successfully!";
                } else {
                    message = "Failed to insert circular. Try again.";
                }
            }

        } catch (SQLException e) {
            message = "Database error: " + e.getMessage();
        } catch (ClassNotFoundException e) {
            message = "Driver not found: " + e.getMessage();
        } catch (IllegalArgumentException e) {
            message = "Invalid date format. Please use YYYY-MM-DD.";
        } finally {
            try {
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                message = "Error closing resources: " + e.getMessage();
            }
        }

        // Set success message or error and forward back to JSP
        request.setAttribute("success", message);
        request.getRequestDispatcher("adminCircular.jsp").forward(request, response);
    }
}