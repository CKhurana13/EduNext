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
import java.util.ArrayList;
import java.util.List;
import org.json.JSONArray;
import org.json.JSONObject;

@WebServlet("/GetSubjectsForClassServlet")
public class GetSubjectsForClassServlet extends HttpServlet {
    private static final String DB_URL = "jdbc:mysql://localhost:3306/teacher_web";
    private static final String DB_USER = "root";
    private static final String DB_PASS = "vips";

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("application/json");
        String className = request.getParameter("className");

        List<JSONObject> subjects = new ArrayList<>();
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
            PreparedStatement pstmt = conn.prepareStatement(
                "SELECT sub_id, sub_name, classes FROM subjects WHERE classes = ?"
            );
            pstmt.setString(1, className);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                JSONObject subject = new JSONObject();
                subject.put("sub_id", rs.getString("sub_id"));
                subject.put("sub_name", rs.getString("sub_name"));
                subject.put("classes", rs.getString("classes"));
                subjects.add(subject);
            }

            rs.close();
            pstmt.close();
            conn.close();

            JSONArray jsonArray = new JSONArray(subjects);
            response.getWriter().write(jsonArray.toString());

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("[]");
        }
    }
}
