package com.java;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;

@WebServlet("/Teacher_ViewMarksServlet")
public class Teacher_ViewMarksServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String s_id = request.getParameter("s_id");
        String class_name = request.getParameter("class_name");
        String subject = request.getParameter("subject");

        List<String> examCodes = new ArrayList<>();
        Map<String, Object> student = new HashMap<>();

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/teacher_web", "root", "vips");

            // Fetch all available exam codes
            PreparedStatement examStmt = conn.prepareStatement("SELECT DISTINCT examCode FROM exam_scores ORDER BY examCode");
            ResultSet examRs = examStmt.executeQuery();
            while (examRs.next()) {
                examCodes.add(examRs.getString("examCode"));
            }
            examRs.close();
            examStmt.close();

            // Fetch student name
            PreparedStatement studentStmt = conn.prepareStatement("SELECT s_name FROM student WHERE s_id = ?");
            studentStmt.setString(1, s_id);
            ResultSet studentRs = studentStmt.executeQuery();
            if (studentRs.next()) {
                student.put("s_id", s_id);
                student.put("s_name", studentRs.getString("s_name"));
            }
            studentRs.close();
            studentStmt.close();

            // Fetch marks for each exam of that subject
            PreparedStatement markStmt = conn.prepareStatement(
                "SELECT examCode, marks FROM exam_scores WHERE s_id = ? AND className = ? AND sub_id = ?"
            );
            markStmt.setString(1, s_id);
            markStmt.setString(2, class_name);
            markStmt.setString(3, subject);
            ResultSet markRs = markStmt.executeQuery();
            while (markRs.next()) {
                student.put(markRs.getString("examCode"), markRs.getInt("marks"));
            }
            markRs.close();
            markStmt.close();
            conn.close();

            // Send data to JSP
            request.setAttribute("examCodes", examCodes);
            request.setAttribute("student", student);
            request.setAttribute("className", class_name);
            request.setAttribute("subjectId", subject);

            RequestDispatcher rd = request.getRequestDispatcher("Teacher_ViewMarks.jsp");
            rd.forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}
