package com.java;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.*;
import java.sql.*;

@WebServlet("/TeacherLoginServlet")
public class TeacherLoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        // Get form parameters
        String t_id = request.getParameter("t_id");
        String password = request.getParameter("password");

        if (t_id == null || password == null || t_id.isEmpty() || password.isEmpty()) {
            response.sendRedirect("teacherLogin.jsp?error=invalid");
            return;
        }

        try {
            // Load MySQL JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Connect to DB
            Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/teacher_web", "root", "vips");

            // SQL query
            PreparedStatement ps = con.prepareStatement(
                    "SELECT t_id, t_name FROM teacher WHERE t_id = ? AND password = ?");
            ps.setString(1, t_id);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                // Successful login
                HttpSession session = request.getSession();
                session.setAttribute("t_id", rs.getString("t_id"));
                session.setAttribute("t_name", rs.getString("t_name"));

                response.sendRedirect("teacherDashboard.jsp");
            } else {
                // Invalid login
                response.sendRedirect("teacherLogin.jsp?error=invalid");
            }

            // Clean up
            rs.close();
            ps.close();
            con.close();

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("teacherLogin.jsp?error=server");
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("teacherLogin.jsp");
    }
}