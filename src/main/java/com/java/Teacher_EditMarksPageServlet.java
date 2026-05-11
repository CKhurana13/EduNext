

package com.java;

import com.java.StudentReportDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.*;
import java.sql.*;
import java.util.*;

@WebServlet("/Teacher_EditMarksPageServlet")
public class Teacher_EditMarksPageServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String s_id = request.getParameter("s_id");
        String classCode = request.getParameter("class_name");
        String subjectParam = request.getParameter("subject");

        try {
            int subjectId = Integer.parseInt(subjectParam); // sub_id from subject table

            try (Connection conn = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/teacher_web", "root", "vips")) {

                StudentReportDAO dao = new StudentReportDAO(conn);

                // Get marks for the student in this class & subject across all exams
                Map<String, Object> student = dao.getStudentExamScores(s_id, classCode, subjectId);
                List<String> examCodes = dao.getAllExamTypes();

                request.setAttribute("student", student);
                request.setAttribute("examCodes", examCodes);
                request.setAttribute("s_id", s_id);
                request.setAttribute("class_name", classCode);
                request.setAttribute("subject", subjectParam); // pass sub_id back

                request.getRequestDispatcher("Teacher_EditMarks.jsp").forward(request, response);

            }

        } catch (NumberFormatException e) {
            response.getWriter().println("Invalid subject ID");
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}