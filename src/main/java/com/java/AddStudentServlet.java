
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

@WebServlet("/AddStudentServlet")
public class AddStudentServlet extends HttpServlet {
    private static final String DB_URL = "jdbc:mysql://localhost:3306/teacher_web";
    private static final String DB_USER = "root";
    private static final String DB_PASS = "vips";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("text/html");

        // Retrieve form parameters
        String s_id = request.getParameter("s_id");
        String s_name = request.getParameter("s_name");
        String f_name = request.getParameter("f_name");
        String m_name = request.getParameter("m_name");
        String s_email = request.getParameter("s_email");
        String f_email = request.getParameter("f_email");
        String m_email = request.getParameter("m_email");
        String address = request.getParameter("address");
        String dob = request.getParameter("dob");
        String phone = request.getParameter("phone");
        String class_name = request.getParameter("class_name");
        String doa = request.getParameter("doa");
        String password = request.getParameter("password");
        String class_code = request.getParameter("class_code");

        try {
            // Validate required fields
            if (s_id == null || s_id.trim().isEmpty()) {
                throw new IllegalArgumentException("Student ID is required.");
            }
            if (s_name == null || s_name.trim().isEmpty()) {
                throw new IllegalArgumentException("Student Name is required.");
            }
            if (phone != null && !phone.isEmpty() && !phone.matches("[0-9]{10}")) {
                throw new IllegalArgumentException("Phone number must be 10 digits.");
            }
            if (s_email != null && !s_email.isEmpty() && !s_email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
                throw new IllegalArgumentException("Invalid student email format.");
            }
            if (f_email != null && !f_email.isEmpty() && !f_email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
                throw new IllegalArgumentException("Invalid father's email format.");
            }
            if (m_email != null && !m_email.isEmpty() && !m_email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
                throw new IllegalArgumentException("Invalid mother's email format.");
            }

            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            // Prepare SQL statement
            String sql = "INSERT INTO student (s_id, s_name, f_name, m_name, s_email, f_email, m_email, address, dob, phone, class_name, doa, password, class_code) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, s_id);
            pstmt.setString(2, s_name);
            pstmt.setString(3, f_name != null && !f_name.isEmpty() ? f_name : null);
            pstmt.setString(4, m_name != null && !m_name.isEmpty() ? m_name : null);
            pstmt.setString(5, s_email != null && !s_email.isEmpty() ? s_email : null);
            pstmt.setString(6, f_email != null && !f_email.isEmpty() ? f_email : null);
            pstmt.setString(7, m_email != null && !m_email.isEmpty() ? m_email : null);
            pstmt.setString(8, address != null && !address.isEmpty() ? address : null);
            pstmt.setString(9, dob != null && !dob.isEmpty() ? dob : null);
            pstmt.setString(10, phone != null && !phone.isEmpty() ? phone : null);
            pstmt.setString(11, class_name != null && !class_name.isEmpty() ? class_name : null);
            pstmt.setString(12, doa != null && !doa.isEmpty() ? doa : null);
            pstmt.setString(13, password != null && !password.isEmpty() ? password : null);
            pstmt.setString(14, class_code != null && !class_code.isEmpty() ? class_code : null);

            pstmt.executeUpdate();

            // Clean up
            pstmt.close();
            conn.close();

            // Redirect with success message
            response.sendRedirect("adminAddStudent.jsp?status=success");

        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
            response.sendRedirect("adminAddStudent.jsp?status=error&message=" + java.net.URLEncoder.encode(e.getMessage(), "UTF-8"));
        } catch (SQLException e) {
            e.printStackTrace();
            String message = e.getMessage().contains("Duplicate entry") ? "Student ID or email already exists." : "Database error: " + e.getMessage();
            response.sendRedirect("adminAddStudent.jsp?status=error&message=" + java.net.URLEncoder.encode(message, "UTF-8"));
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("adminAddStudent.jsp?status=error&message=" + java.net.URLEncoder.encode("Unexpected error: " + e.getMessage(), "UTF-8"));
        }
    }
}