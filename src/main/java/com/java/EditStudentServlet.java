
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
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

@WebServlet("/EditStudentServlet")
public class EditStudentServlet extends HttpServlet {
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
        String photo = request.getParameter("photo");
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

            // Fetch current student data
            String selectSql = "SELECT s_id, s_name, f_name, m_name, s_email, f_email, m_email, address, dob, phone, class_name, doa, photo, password, class_code FROM student WHERE s_id = ?";
            PreparedStatement selectStmt = conn.prepareStatement(selectSql);
            selectStmt.setString(1, s_id);
            ResultSet rs = selectStmt.executeQuery();

            if (!rs.next()) {
                rs.close();
                selectStmt.close();
                conn.close();
                throw new IllegalArgumentException("Student ID not found.");
            }

            // Get current values
            String currentSId = rs.getString("s_id");
            String currentSName = rs.getString("s_name") != null ? rs.getString("s_name") : "";
            String currentFName = rs.getString("f_name") != null ? rs.getString("f_name") : "";
            String currentMName = rs.getString("m_name") != null ? rs.getString("m_name") : "";
            String currentSEmail = rs.getString("s_email") != null ? rs.getString("s_email") : "";
            String currentFEmail = rs.getString("f_email") != null ? rs.getString("f_email") : "";
            String currentMEmail = rs.getString("m_email") != null ? rs.getString("m_email") : "";
            String currentAddress = rs.getString("address") != null ? rs.getString("address") : "";
            String currentDob = rs.getString("dob") != null ? rs.getString("dob") : "";
            String currentPhone = rs.getString("phone") != null ? rs.getString("phone") : "";
            String currentClassName = rs.getString("class_name") != null ? rs.getString("class_name") : "";
            String currentDoa = rs.getString("doa") != null ? rs.getString("doa") : "";
            String currentPhoto = rs.getString("photo") != null ? rs.getString("photo") : "";
            String currentPassword = rs.getString("password") != null ? rs.getString("password") : "";
            String currentClassCode = rs.getString("class_code") != null ? rs.getString("class_code") : "";

            rs.close();
            selectStmt.close();

            // Build dynamic UPDATE query for changed fields
            List<String> setClauses = new ArrayList<>();
            List<Object> parameters = new ArrayList<>();

            // Compare and add changed fields
            if (!s_id.equals(currentSId)) {
                setClauses.add("s_id = ?");
                parameters.add(s_id);
            }
            if (!s_name.equals(currentSName)) {
                setClauses.add("s_name = ?");
                parameters.add(s_name);
            }
            if (!Objects.equals(f_name, currentFName)) {
                setClauses.add("f_name = ?");
                parameters.add(f_name != null && !f_name.isEmpty() ? f_name : null);
            }
            if (!Objects.equals(m_name, currentMName)) {
                setClauses.add("m_name = ?");
                parameters.add(m_name != null && !m_name.isEmpty() ? m_name : null);
            }
            if (!Objects.equals(s_email, currentSEmail)) {
                setClauses.add("s_email = ?");
                parameters.add(s_email != null && !s_email.isEmpty() ? s_email : null);
            }
            if (!Objects.equals(f_email, currentFEmail)) {
                setClauses.add("f_email = ?");
                parameters.add(f_email != null && !f_email.isEmpty() ? f_email : null);
            }
            if (!Objects.equals(m_email, currentMEmail)) {
                setClauses.add("m_email = ?");
                parameters.add(m_email != null && !m_email.isEmpty() ? m_email : null);
            }
            if (!Objects.equals(address, currentAddress)) {
                setClauses.add("address = ?");
                parameters.add(address != null && !address.isEmpty() ? address : null);
            }
            if (!Objects.equals(dob, currentDob)) {
                setClauses.add("dob = ?");
                parameters.add(dob != null && !dob.isEmpty() ? dob : null);
            }
            if (!Objects.equals(phone, currentPhone)) {
                setClauses.add("phone = ?");
                parameters.add(phone != null && !phone.isEmpty() ? phone : null);
            }
            if (!Objects.equals(class_name, currentClassName)) {
                setClauses.add("class_name = ?");
                parameters.add(class_name != null && !class_name.isEmpty() ? class_name : null);
            }
            if (!Objects.equals(doa, currentDoa)) {
                setClauses.add("doa = ?");
                parameters.add(doa != null && !doa.isEmpty() ? doa : null);
            }
            if (!Objects.equals(photo, currentPhoto)) {
                setClauses.add("photo = ?");
                parameters.add(photo != null && !photo.isEmpty() ? photo : null);
            }
            if (!Objects.equals(password, currentPassword)) {
                setClauses.add("password = ?");
                parameters.add(password != null && !password.isEmpty() ? password : null);
            }
            if (!Objects.equals(class_code, currentClassCode)) {
                setClauses.add("class_code = ?");
                parameters.add(class_code != null && !class_code.isEmpty() ? class_code : null);
            }

            if (setClauses.isEmpty()) {
                conn.close();
                response.sendRedirect("adminEditStudent.jsp?s_id=" + java.net.URLEncoder.encode(s_id, "UTF-8") + "&status=success&message=" + java.net.URLEncoder.encode("No changes made.", "UTF-8"));
                return;
            }

            // Add WHERE clause parameter
            parameters.add(currentSId);

            // Construct SQL query
            String sql = "UPDATE student SET " + String.join(", ", setClauses) + " WHERE s_id = ?";
            PreparedStatement pstmt = conn.prepareStatement(sql);

            // Set parameters
            for (int i = 0; i < parameters.size(); i++) {
                pstmt.setObject(i + 1, parameters.get(i));
            }

            int rowsAffected = pstmt.executeUpdate();
            pstmt.close();
            conn.close();

            if (rowsAffected > 0) {
                // Redirect with success message
                response.sendRedirect("adminEditStudent.jsp?s_id=" + java.net.URLEncoder.encode(s_id, "UTF-8") + "&status=success");
            } else {
                // Redirect with error if no rows were updated
                response.sendRedirect("adminEditStudent.jsp?s_id=" + java.net.URLEncoder.encode(s_id, "UTF-8") + "&status=error&message=" + java.net.URLEncoder.encode("Student ID not found.", "UTF-8"));
            }

        } catch (IllegalArgumentException e) {
            response.sendRedirect("adminEditStudent.jsp?s_id=" + java.net.URLEncoder.encode(s_id, "UTF-8") + "&status=error&message=" + java.net.URLEncoder.encode(e.getMessage(), "UTF-8"));
        } catch (SQLException e) {
            e.printStackTrace();
            String message = e.getMessage().contains("Duplicate entry") ? "Student ID already exists." : "Database error: " + e.getMessage();
            response.sendRedirect("adminEditStudent.jsp?s_id=" + java.net.URLEncoder.encode(s_id, "UTF-8") + "&status=error&message=" + java.net.URLEncoder.encode(message, "UTF-8"));
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("adminEditStudent.jsp?s_id=" + java.net.URLEncoder.encode(s_id, "UTF-8") + "&status=error&message=" + java.net.URLEncoder.encode("Unexpected error: " + e.getMessage(), "UTF-8"));
        }
    }
}