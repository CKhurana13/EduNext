package com.java;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.sql.*;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@WebServlet("/MarkHomeworkDoneServlet")
public class MarkHomeworkDoneServlet extends HttpServlet {
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String s_id = request.getParameter("s_id");
		String hw_id_str = request.getParameter("hw_id");
		Connection conn = null;
		PreparedStatement ps = null;

		try {
			// Validate input
			if (s_id == null || hw_id_str == null || s_id.isEmpty() || hw_id_str.isEmpty()) {
				response.sendRedirect("studentHomework.jsp?message=Error: Invalid input");
				return;
			}
			int hw_id = Integer.parseInt(hw_id_str);

			// Database connection
			Class.forName("com.mysql.cj.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/teacher_web?useSSL=false", "root", "vips");

			// Check if homework exists and belongs to student's class
			String checkQuery = "SELECT className FROM homework WHERE hw_id = ?";
			ps = conn.prepareStatement(checkQuery);
			ps.setInt(1, hw_id);
			ResultSet rs = ps.executeQuery();
			if (!rs.next()) {
				response.sendRedirect("studentHomework.jsp?message=Error: Homework not found");
				return;
			}
			String className = rs.getString("className");
			rs.close();
			ps.close();

			// Verify student's class_name from session
			HttpSession session = request.getSession(false);
			if (session == null || session.getAttribute("class_name") == null) {
				response.sendRedirect("studentLogin.jsp");
				return;
			}
			String sessionClassName = ((String) session.getAttribute("class_name")).trim().toUpperCase();
			if (!sessionClassName.equals(className)) {
				response.sendRedirect("studentHomework.jsp?message=Error: Unauthorized access to homework");
				return;
			}

			// Check if already marked done
			String checkStatusQuery = "SELECT status_id FROM homework_status WHERE s_id = ? AND hw_id = ?";
			ps = conn.prepareStatement(checkStatusQuery);
			ps.setString(1, s_id);
			ps.setInt(2, hw_id);
			rs = ps.executeQuery();
			if (rs.next()) {
				response.sendRedirect("studentHomework.jsp?message=Error: Homework already marked done");
				return;
			}
			rs.close();
			ps.close();

			// Insert completion record
			String insertQuery = "INSERT INTO homework_status (s_id, hw_id, completed_date) VALUES (?, ?, ?)";
			ps = conn.prepareStatement(insertQuery);
			ps.setString(1, s_id);
			ps.setInt(2, hw_id);
			ps.setString(3, LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));
			int rowsAffected = ps.executeUpdate();
			
			if (rowsAffected > 0) {
				System.out.println("Homework marked done: s_id=" + s_id + ", hw_id=" + hw_id);
				response.sendRedirect("studentHomework.jsp?message=Homework marked as done");
			} else {
				response.sendRedirect("studentHomework.jsp?message=Error: Failed to mark homework");
			}
		} catch (NumberFormatException e) {
			System.out.println("Invalid hw_id format: " + hw_id_str);
			response.sendRedirect("studentHomework.jsp?message=Error: Invalid homework ID");
		} catch (SQLException | ClassNotFoundException e) {
			e.printStackTrace();
			System.out.println("Database error: " + e.getMessage());
			response.sendRedirect("studentHomework.jsp?message=Error: Database error");
		} finally {
			try {
				if (ps != null) ps.close();
				if (conn != null) conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
	}
}