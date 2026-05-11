

package com.java;

import com.java.StudentReportDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.util.List;

@WebServlet("/Teacher_EditMarksServlet")
public class Teacher_EditMarksServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String classCode = request.getParameter("class_name");
        String subjectIdStr = request.getParameter("subject");
        String studentId = request.getParameter("s_id");

        try {
            int subjectId = Integer.parseInt(subjectIdStr); // ✅ Ensure correct type

            try (Connection conn = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/teacher_web", "root", "vips")) {

                StudentReportDAO dao = new StudentReportDAO(conn);

                List<String> examCodes = dao.getAllExamTypes();

                for (String examCode : examCodes) {
                    String markStr = request.getParameter(examCode);

                    if (markStr != null && !markStr.trim().isEmpty()) {
                        int marks = Integer.parseInt(markStr.trim());
                        dao.updateExamScore(studentId, classCode, examCode, subjectId, marks);
                    }
                }

                // ✅ Redirect back to performance page with success
                response.sendRedirect("teacherPerformance.jsp?success=1");

            }

        } catch (NumberFormatException e) {
            response.getWriter().println("Invalid subject ID or marks input.");
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}