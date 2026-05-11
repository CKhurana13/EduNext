
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

@WebServlet("/EditTeacherServlet")
public class EditTeacherServlet extends HttpServlet {
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

            // Fetch current teacher data
            String selectSql = "SELECT t_id, t_name, address, phone, t_email, subjects, classes, qualifications, password, doj, dob FROM teacher WHERE t_id = ?";
            PreparedStatement selectStmt = conn.prepareStatement(selectSql);
            selectStmt.setString(1, t_id);
            ResultSet rs = selectStmt.executeQuery();

            if (!rs.next()) {
                rs.close();
                selectStmt.close();
                conn.close();
                throw new IllegalArgumentException("Teacher ID not found.");
            }

            // Get current values
            String currentTId = rs.getString("t_id");
            String currentTName = rs.getString("t_name") != null ? rs.getString("t_name") : "";
            String currentAddress = rs.getString("address") != null ? rs.getString("address") : "";
            String currentPhone = rs.getString("phone") != null ? rs.getString("phone") : "";
            String currentTEmail = rs.getString("t_email") != null ? rs.getString("t_email") : "";
            String currentSubjects = rs.getString("subjects") != null ? rs.getString("subjects") : "";
            String currentClasses = rs.getString("classes") != null ? rs.getString("classes") : "";
            String currentQualifications = rs.getString("qualifications") != null ? rs.getString("qualifications") : "";
            String currentPassword = rs.getString("password") != null ? rs.getString("password") : "";
            String currentDoj = rs.getString("doj") != null ? rs.getString("doj") : "";
            String currentDob = rs.getString("dob") != null ? rs.getString("dob") : "";

            rs.close();
            selectStmt.close();

            // Build dynamic UPDATE query for changed fields
            List<String> setClauses = new ArrayList<>();
            List<Object> parameters = new ArrayList<>();

            // Compare and add changed fields
            if (!t_id.equals(currentTId)) {
                setClauses.add("t_id = ?");
                parameters.add(t_id);
            }
            if (!t_name.equals(currentTName)) {
                setClauses.add("t_name = ?");
                parameters.add(t_name);
            }
            if (!Objects.equals(address, currentAddress)) {
                setClauses.add("address = ?");
                parameters.add(address != null && !address.isEmpty() ? address : null);
            }
            if (!Objects.equals(phone, currentPhone)) {
                setClauses.add("phone = ?");
                parameters.add(phone != null && !phone.isEmpty() ? phone : null);
            }
            if (!Objects.equals(t_email, currentTEmail)) {
                setClauses.add("t_email = ?");
                parameters.add(t_email != null && !t_email.isEmpty() ? t_email : null);
            }
            if (!Objects.equals(subjects, currentSubjects)) {
                setClauses.add("subjects = ?");
                parameters.add(subjects != null && !subjects.isEmpty() ? subjects : null);
            }
            if (!Objects.equals(classes, currentClasses)) {
                setClauses.add("classes = ?");
                parameters.add(classes != null && !classes.isEmpty() ? classes : null);
            }
            if (!Objects.equals(qualifications, currentQualifications)) {
                setClauses.add("qualifications = ?");
                parameters.add(qualifications != null && !qualifications.isEmpty() ? qualifications : null);
            }
            if (!Objects.equals(password, currentPassword)) {
                setClauses.add("password = ?");
                parameters.add(password != null && !password.isEmpty() ? password : null);
            }
            if (!Objects.equals(doj, currentDoj)) {
                setClauses.add("doj = ?");
                parameters.add(doj != null && !doj.isEmpty() ? doj : null);
            }
            if (!Objects.equals(dob, currentDob)) {
                setClauses.add("dob = ?");
                parameters.add(dob != null && !dob.isEmpty() ? dob : null);
            }

            if (setClauses.isEmpty()) {
                conn.close();
                response.sendRedirect("adminEditTeacher.jsp?t_id=" + java.net.URLEncoder.encode(t_id, "UTF-8") + "&status=success&message=" + java.net.URLEncoder.encode("No changes made.", "UTF-8"));
                return;
            }

            // Add WHERE clause parameter
            parameters.add(currentTId);

            // Construct SQL query
            String sql = "UPDATE teacher SET " + String.join(", ", setClauses) + " WHERE t_id = ?";
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
                response.sendRedirect("adminEditTeacher.jsp?t_id=" + java.net.URLEncoder.encode(t_id, "UTF-8") + "&status=success");
            } else {
                // Redirect with error if no rows were updated
                response.sendRedirect("adminEditTeacher.jsp?t_id=" + java.net.URLEncoder.encode(t_id, "UTF-8") + "&status=error&message=" + java.net.URLEncoder.encode("Teacher ID not found.", "UTF-8"));
            }

        } catch (IllegalArgumentException e) {
            response.sendRedirect("adminEditTeacher.jsp?t_id=" + java.net.URLEncoder.encode(t_id, "UTF-8") + "&status=error&message=" + java.net.URLEncoder.encode(e.getMessage(), "UTF-8"));
        } catch (SQLException e) {
            e.printStackTrace();
            String message = e.getMessage().contains("Duplicate entry") ? "Teacher ID or email already exists." : "Database error: " + e.getMessage();
            response.sendRedirect("adminEditTeacher.jsp?t_id=" + java.net.URLEncoder.encode(t_id, "UTF-8") + "&status=error&message=" + java.net.URLEncoder.encode(message, "UTF-8"));
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("adminEditTeacher.jsp?t_id=" + java.net.URLEncoder.encode(t_id, "UTF-8") + "&status=error&message=" + java.net.URLEncoder.encode("Unexpected error: " + e.getMessage(), "UTF-8"));
        }
    }
}
