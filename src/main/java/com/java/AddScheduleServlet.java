
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

@WebServlet("/AddScheduleServlet")
public class AddScheduleServlet extends HttpServlet {
    private static final String DB_URL = "jdbc:mysql://localhost:3306/teacher_web";
    private static final String DB_USER = "root";
    private static final String DB_PASS = "vips";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("text/html");

        // Retrieve form parameters
        String t_id = request.getParameter("t_id");
        String className = request.getParameter("className");
        String day = request.getParameter("day");
        String sub_id = request.getParameter("sub_id");
        String period_no = request.getParameter("period_no");

        try {
            // Validate required fields
            if (t_id == null || t_id.trim().isEmpty()) {
                throw new IllegalArgumentException("Teacher ID is required.");
            }
            if (className == null || className.trim().isEmpty()) {
                throw new IllegalArgumentException("Class is required.");
            }
            if (day == null || day.trim().isEmpty()) {
                throw new IllegalArgumentException("Day is required.");
            }
            if (day.equalsIgnoreCase("saturday")) {
                throw new IllegalArgumentException("Saturday is not allowed in the schedule.");
            }
            if (sub_id == null || sub_id.trim().isEmpty()) {
                throw new IllegalArgumentException("Subject is required.");
            }
            if (period_no == null || period_no.trim().isEmpty()) {
                throw new IllegalArgumentException("Period is required.");
            }

            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            // Validate teacher exists
            PreparedStatement validateTeacherStmt = conn.prepareStatement("SELECT t_id FROM teacher WHERE t_id = ?");
            validateTeacherStmt.setString(1, t_id);
            ResultSet rs = validateTeacherStmt.executeQuery();
            if (!rs.next()) {
                rs.close();
                validateTeacherStmt.close();
                conn.close();
                throw new IllegalArgumentException("Invalid teacher ID.");
            }
            rs.close();
            validateTeacherStmt.close();

            // Validate className matches subject's classes
            PreparedStatement validateStmt = conn.prepareStatement("SELECT classes FROM subjects WHERE sub_id = ?");
            validateStmt.setString(1, sub_id);
            rs = validateStmt.executeQuery();
            if (!rs.next() || !className.equals(rs.getString("classes"))) {
                rs.close();
                validateStmt.close();
                conn.close();
                throw new IllegalArgumentException("Selected subject does not match the class.");
            }
            rs.close();
            validateStmt.close();

            // Check for schedule conflict (same class, day, period)
            PreparedStatement conflictStmt = conn.prepareStatement(
                "SELECT sc_id FROM schedule WHERE className = ? AND day = ? AND period_no = ?"
            );
            conflictStmt.setString(1, className);
            conflictStmt.setString(2, day);
            conflictStmt.setString(3, period_no);
            rs = conflictStmt.executeQuery();
            if (rs.next()) {
                rs.close();
                conflictStmt.close();
                conn.close();
                throw new IllegalArgumentException("Schedule conflict: This class already has a schedule for this day and period.");
            }
            rs.close();
            conflictStmt.close();

            // Check for teacher conflict (same teacher, day, period)
            PreparedStatement teacherConflictStmt = conn.prepareStatement(
                "SELECT sc_id FROM schedule WHERE t_id = ? AND day = ? AND period_no = ?"
            );
            teacherConflictStmt.setString(1, t_id);
            teacherConflictStmt.setString(2, day);
            teacherConflictStmt.setString(3, period_no);
            rs = teacherConflictStmt.executeQuery();
            if (rs.next()) {
                rs.close();
                teacherConflictStmt.close();
                conn.close();
                throw new IllegalArgumentException("Teacher conflict: This teacher is already scheduled for this day and period.");
            }
            rs.close();
            teacherConflictStmt.close();

            // Insert new schedule
            PreparedStatement pstmt = conn.prepareStatement(
                "INSERT INTO schedule (className, day, sub_id, t_id, period_no) VALUES (?, ?, ?, ?, ?)"
            );
            pstmt.setString(1, className);
            pstmt.setString(2, day);
            pstmt.setString(3, sub_id);
            pstmt.setString(4, t_id);
            pstmt.setString(5, period_no);
            int rowsAffected = pstmt.executeUpdate();

            pstmt.close();
            conn.close();

            if (rowsAffected > 0) {
                response.sendRedirect("addSchedule.jsp?t_id=" + java.net.URLEncoder.encode(t_id, "UTF-8") + "&status=success");
            } else {
                response.sendRedirect("addSchedule.jsp?t_id=" + java.net.URLEncoder.encode(t_id, "UTF-8") + 
                    "&status=error&message=" + java.net.URLEncoder.encode("Failed to add schedule.", "UTF-8"));
            }

        } catch (IllegalArgumentException e) {
            response.sendRedirect("addSchedule.jsp?t_id=" + java.net.URLEncoder.encode(t_id != null ? t_id : "", "UTF-8") + 
                "&status=error&message=" + java.net.URLEncoder.encode(e.getMessage(), "UTF-8"));
        } catch (SQLException e) {
            e.printStackTrace();
            String message = e.getMessage().contains("Duplicate entry") ? 
                "Schedule already exists." : "Database error: " + e.getMessage();
            response.sendRedirect("addSchedule.jsp?t_id=" + java.net.URLEncoder.encode(t_id != null ? t_id : "", "UTF-8") + 
                "&status=error&message=" + java.net.URLEncoder.encode(message, "UTF-8"));
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("addSchedule.jsp?t_id=" + java.net.URLEncoder.encode(t_id != null ? t_id : "", "UTF-8") + 
                "&status=error&message=" + java.net.URLEncoder.encode("Unexpected error: " + e.getMessage(), "UTF-8"));
        }
    }
}
