package com.java;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.Date;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.time.LocalDate;
import java.util.Enumeration;

@WebServlet("/TeacherSyllabusServlet")
@MultipartConfig
public class TeacherSyllabusServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
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
        String className = request.getParameter("className");
        String sub_name = request.getParameter("sub_name");
        String examCode = request.getParameter("examCode");
        LocalDate uploadDate = LocalDate.now();

        if (t_id == null || className == null || sub_name == null || examCode == null) {
            log("Missing parameters: t_id=" + t_id + ", className=" + className + ", sub_name=" + sub_name + ", examCode=" + examCode);
            response.sendRedirect("teacherLogin.jsp?error=unauthorized");
            return;
        }

        // Upload directory
        String uploadPath = getServletContext().getRealPath("/") + "Uploads" + File.separator + "syllabus";
        Files.createDirectories(Paths.get(uploadPath));

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/teacher_web", "root", "vips");

            Part filePart = request.getPart("syllabus_file");
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = t_id + "_" + className + "_" + sub_name + "_" + examCode + ".pdf";
                String fullPath = uploadPath + File.separator + fileName;
                filePart.write(fullPath);

                String relativePath = "Uploads/syllabus/" + fileName;

                String sql = "INSERT INTO syllabus (t_id, className, sub_name, examCode, file_path, upload_date) " +
                             "VALUES (?, ?, ?, ?, ?, ?)";
                ps = conn.prepareStatement(sql);
                ps.setString(1, t_id);
                ps.setString(2, className);
                ps.setString(3, sub_name);
                ps.setString(4, examCode);
                ps.setString(5, relativePath);
                ps.setDate(6, Date.valueOf(uploadDate));
                ps.executeUpdate();

                response.sendRedirect("teacherSyllabus.jsp?upload=success&className=" + className);
            } else {
                log("No file uploaded for t_id=" + t_id);
                response.getWriter().println("No file uploaded.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            log("Upload failed: " + e.getMessage());
            response.getWriter().println("Upload failed: " + e.getMessage());
        } finally {
            try { if (ps != null) ps.close(); } catch (Exception e) { e.printStackTrace(); }
            try { if (conn != null) conn.close(); } catch (Exception e) { e.printStackTrace(); }
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("SyllabusPageLoaderServlet");
    }
}