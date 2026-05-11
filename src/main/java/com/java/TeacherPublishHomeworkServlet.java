package com.java;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/TeacherPublishHomeworkServlet")
public class TeacherPublishHomeworkServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get session and teacher ID
        HttpSession session = request.getSession(false);
        String t_id = (session != null) ? (String) session.getAttribute("t_id") : null;

        // Check if user is authenticated
        if (t_id == null) {
            response.sendRedirect("loginTeacher.jsp?error=unauthorized");
            return;
        }

        // Get form parameters
        String className = request.getParameter("class_name");
        String subject = request.getParameter("subject");
        String chapter = request.getParameter("chapter");
        String description = request.getParameter("description");
        String dueDate = request.getParameter("due_date");
        String issueDate = request.getParameter("issue_date");

        // Debug: Log parameters
        System.out.println("Received parameters: className=" + className + ", subject=" + subject + 
                           ", chapter=" + chapter + ", description=" + description + 
                           ", dueDate=" + dueDate + ", issueDate=" + issueDate);

        Connection conn = null;
        PreparedStatement psSubject = null;
        PreparedStatement psInsert = null;
        ResultSet rsSubject = null;

        try {
            // Load MySQL JDBC Driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/teacher_web", "root", "vips");

            // Fetch sub_id from subjects table
            psSubject = conn.prepareStatement("SELECT sub_id FROM subjects WHERE sub_name = ?");
            psSubject.setString(1, subject);
            rsSubject = psSubject.executeQuery();

            if (!rsSubject.next()) {
                request.setAttribute("error", "Invalid subject: " + subject);
                request.getRequestDispatcher("teacherPublishHomework.jsp").forward(request, response);
                return;
            }
            int subId = rsSubject.getInt("sub_id");

            // Insert homework into database
            psInsert = conn.prepareStatement(
                "INSERT INTO homework (className, sub_id, chapter, description, due_date, assigned_date, t_id) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?)"
            );
            psInsert.setString(1, className);
            psInsert.setInt(2, subId);
            psInsert.setString(3, chapter);
            psInsert.setString(4, description);
            psInsert.setString(5, dueDate);
            psInsert.setString(6, issueDate);
            psInsert.setString(7, t_id);

            int rowsAffected = psInsert.executeUpdate();
            if (rowsAffected > 0) {
                request.setAttribute("success", "Homework published successfully!");
            } else {
                request.setAttribute("error", "Failed to publish homework.");
            }

            // Forward back to JSP with success/error message
            request.getRequestDispatcher("teacherPublishHomework.jsp").forward(request, response);

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error publishing homework: " + e.getMessage());
            request.getRequestDispatcher("teacherPublishHomework.jsp").forward(request, response);
        } finally {
            // Close resources
            try {
                if (rsSubject != null) rsSubject.close();
                if (psSubject != null) psSubject.close();
                if (psInsert != null) psInsert.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}