
package com.java;

import com.java.StudentReportDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.util.*;

@WebServlet("/AttendanceServlet")
public class AttendanceServlet extends HttpServlet {

    // Load and display form: class list and students
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    	
        HttpSession session = request.getSession();
        String t_id = (String) session.getAttribute("t_id");

        try {
            // Ensure JDBC driver is loaded
            Class.forName("com.mysql.cj.jdbc.Driver");

            try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/teacher_web", "root", "vips")) {
                StudentReportDAO dao = new StudentReportDAO(conn);

                // Get classes assigned to this teacher
                List<String> classes = dao.getTeacherClasses(t_id);
                request.setAttribute("classes", classes);

                String className = request.getParameter("class_name");
                if (className != null && !className.isEmpty()) {
                    // Get students in selected class
                    List<Map<String, String>> studentList = dao.getStudentsByClass(className);
                    request.setAttribute("studentList", studentList);
                }

                request.getRequestDispatcher("teacherAttendance.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error loading attendance form: " + e.getMessage());
        }
    }

    // Save attendance entries
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/teacher_web", "root", "vips")) {
                StudentReportDAO dao = new StudentReportDAO(conn);

                String className = request.getParameter("class_name");
                String attendanceDate = request.getParameter("attendance_date");
                int count = Integer.parseInt(request.getParameter("count"));

                for (int i = 0; i < count; i++) {
                    String s_id = request.getParameter("s_id_" + i);
                    String status = request.getParameter("status_" + i);

                    dao.markAttendance(s_id, className, attendanceDate, status);
                }

                // Reload the page with updated class
                response.sendRedirect("AttendanceServlet?class_name=" + className + "&success=true");

            }

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error saving attendance: " + e.getMessage());
        }
    }
}