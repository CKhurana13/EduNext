
package com.java;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet("/AddTeacherServlet")
public class AddTeacherServlet extends HttpServlet {
    private static final String DB_URL = "jdbc:mysql://localhost:3306/teacher_web";
    private static final String DB_USER = "root";
    private static final String DB_PASS = "vips";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("text/html");

        // Retrieve form parameters
        String t_id = request.getParameter("t_id");
        String t_name = request.getParameter("t_name");
        String address = request.getParameter("address");
        String phone = request.getParameter("phone");
        String t_email = request.getParameter("t_email");
        String subjects = request.getParameter("subjects");
        String classes = request.getParameter("classes");
        String qualifications = request.getParameter("qualifications");
        String password = request.getParameter("password");
        String doj = request.getParameter("doj");
        String dob = request.getParameter("dob");

        try {
            // Validate required fields
            if (t_id == null || t_id.trim().isEmpty()) {
                throw new IllegalArgumentException("Teacher ID is required.");
            }
            if (t_name == null || t_name.trim().isEmpty()) {
                throw new IllegalArgumentException("Teacher Name is required.");
            }
            if (phone != null && !phone.isEmpty() && !phone.matches("[0-9]{10}")) {
                throw new IllegalArgumentException("Phone number must be 10 digits.");
            }
            if (t_email != null && !t_email.isEmpty() && !t_email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
                throw new IllegalArgumentException("Invalid email format.");
            }

            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            // Prepare SQL statement
            String sql = "INSERT INTO teacher (t_id, t_name, address, phone, t_email, subjects, classes, qualifications, password, doj, dob) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, t_id);
            pstmt.setString(2, t_name);
            pstmt.setString(3, address != null && !address.isEmpty() ? address : null);
            pstmt.setString(4, phone != null && !phone.isEmpty() ? phone : null);
            pstmt.setString(5, t_email != null && !t_email.isEmpty() ? t_email : null);
            pstmt.setString(6, subjects != null && !subjects.isEmpty() ? subjects : null);
            pstmt.setString(7, classes != null && !classes.isEmpty() ? classes : null);
            pstmt.setString(8, qualifications != null && !qualifications.isEmpty() ? qualifications : null);
            pstmt.setString(9, password != null && !password.isEmpty() ? password : null);
            pstmt.setString(10, doj != null && !doj.isEmpty() ? doj : null);
            pstmt.setString(11, dob != null && !dob.isEmpty() ? dob : null);

            pstmt.executeUpdate();

            // Clean up
            pstmt.close();
            conn.close();

            // Redirect with success message
            response.sendRedirect("adminAddTeacher.jsp?status=success");

        } catch (IllegalArgumentException e) {
            response.sendRedirect("adminAddTeacher.jsp?status=error&message=" + java.net.URLEncoder.encode(e.getMessage(), "UTF-8"));
        } catch (SQLException e) {
            e.printStackTrace();
            String message = e.getMessage().contains("Duplicate entry") ? "Teacher ID or email already exists." : "Database error: " + e.getMessage();
            response.sendRedirect("adminAddTeacher.jsp?status=error&message=" + java.net.URLEncoder.encode(message, "UTF-8"));
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("adminAddTeacher.jsp?status=error&message=" + java.net.URLEncoder.encode("Unexpected error: " + e.getMessage(), "UTF-8"));
        }
    }
}
