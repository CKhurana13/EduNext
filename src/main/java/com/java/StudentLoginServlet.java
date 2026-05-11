package com.java;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.text.SimpleDateFormat;
import java.text.ParseException;

@WebServlet("/StudentLoginServlet")
public class StudentLoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String rollNumber = request.getParameter("rollNumber");
        String dobStr = request.getParameter("dob"); // expecting yyyy-MM-dd

        try {
            // Parse the date
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            sdf.setLenient(false); // Strict date parsing
            java.util.Date parsedDate = sdf.parse(dobStr);
            java.sql.Date sqlDob = new java.sql.Date(parsedDate.getTime());

            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/teacher_web", "root", "vips");

            String sql = "SELECT s_id, s_name, class_name FROM student WHERE s_id = ? AND dob = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, rollNumber);
            stmt.setDate(2, sqlDob);

            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                // Save values in session
                HttpSession session = request.getSession();
                session.setAttribute("s_id", rs.getString("s_id"));
                session.setAttribute("s_name", rs.getString("s_name"));
                session.setAttribute("class_name", rs.getString("class_name"));

                // Redirect to dashboard
                response.sendRedirect("studentDashboard.jsp");
            } else {
                request.setAttribute("errorMessage", "Invalid roll number or date of birth.");
                request.getRequestDispatcher("studentLogin.jsp").forward(request, response);
            }

            rs.close();
            stmt.close();
            conn.close();

        } catch (ParseException pe) {
            request.setAttribute("errorMessage", "Invalid date format. Use YYYY-MM-DD.");
            request.getRequestDispatcher("studentLogin.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Server error: " + e.getMessage());
            request.getRequestDispatcher("studentLogin.jsp").forward(request, response);
        }
    }
}