package com.java;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;

@WebServlet("/SyllabusPageLoaderServlet")
public class SyllabusPageLoaderServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        StringBuilder attrLog = new StringBuilder();
        if (session != null) {
            Enumeration<String> sessionAttributes = session.getAttributeNames();
            while (sessionAttributes.hasMoreElements()) {
                String attr = sessionAttributes.nextElement();
                attrLog.append(attr).append("=").append(session.getAttribute(attr)).append(", ");
            }
            log("Session attributes: " + attrLog.toString());
        } else {
            log("Session is null");
        }

        String t_id = (session != null) ? (String) session.getAttribute("t_id") : null;

        if (t_id == null) {
            log("Missing t_id in session");
            response.sendRedirect("teacherLogin.jsp?error=unauthorized");
            return;
        }

        List<String> classList = new ArrayList<>();
        List<String> subjectList = new ArrayList<>();
        List<Map<String, String>> examList = new ArrayList<>();

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/teacher_web", "root", "vips");

            // Fetch classes from teacher table
            PreparedStatement ps1 = conn.prepareStatement("SELECT classes FROM teacher WHERE t_id = ?");
            ps1.setString(1, t_id);
            ResultSet rs1 = ps1.executeQuery();
            if (rs1.next()) {
                String[] clsArr = rs1.getString("classes").split(",");
                for (String cls : clsArr) {
                    if (!cls.trim().isEmpty()) {
                        classList.add(cls.trim());
                        log("Fetched class: " + cls.trim());
                    }
                }
            }
            rs1.close();
            ps1.close();
            log("Total classes fetched: " + classList.size());

            // Fetch subjects based on selected class
            String selectedClass = request.getParameter("className");
            if (selectedClass != null && !selectedClass.trim().isEmpty()) {
                PreparedStatement ps2 = conn.prepareStatement(
                    "SELECT DISTINCT sub_name FROM subjects WHERE t_id = ? AND classes = ?"
                );
                ps2.setString(1, t_id);
                ps2.setString(2, selectedClass);
                ResultSet rs2 = ps2.executeQuery();
                while (rs2.next()) {
                    String subName = rs2.getString("sub_name");
                    subjectList.add(subName);
                    log("Fetched subject: " + subName + " for class " + selectedClass);
                }
                rs2.close();
                ps2.close();
                log("Total subjects fetched: " + subjectList.size());
            }

            // Fetch exam types from exam_type table
            PreparedStatement ps3 = conn.prepareStatement("SELECT examCode, examName FROM exam_type");
            ResultSet rs3 = ps3.executeQuery();
            while (rs3.next()) {
                Map<String, String> exam = new HashMap<>();
                exam.put("examCode", rs3.getString("examCode"));
                exam.put("examName", rs3.getString("examName"));
                examList.add(exam);
                log("Fetched exam: " + rs3.getString("examCode") + " - " + rs3.getString("examName"));
            }
            rs3.close();
            ps3.close();
            log("Total exams fetched: " + examList.size());

            conn.close();

            request.setAttribute("classes", classList);
            request.setAttribute("subjects", subjectList);
            request.setAttribute("exam_types", examList);
            log("Forwarding to teacherSyllabus.jsp with attributes: classes=" + classList.size() + ", subjects=" + subjectList.size() + ", exams=" + examList.size());
            request.getRequestDispatcher("teacherSyllabus.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            log("Error loading class/subject/exam list: " + e.getMessage());
            response.getWriter().println("Error loading class/subject/exam list: " + e.getMessage());
        }
    }
}