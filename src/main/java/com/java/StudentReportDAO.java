package com.java;

import java.sql.*;
import java.sql.Date;
import java.util.*;

public class StudentReportDAO {
	private Connection conn;

	public StudentReportDAO(Connection conn) {
		this.conn = conn;
	}
	

	// Get classes assigned to teacher from teacher table (comma separated)
	public List<String> getTeacherClasses(String teacherId) throws SQLException {
	    List<String> classes = new ArrayList<>();
	    String sql = "SELECT classes FROM teacher WHERE t_id = ?";
	    try (PreparedStatement ps = conn.prepareStatement(sql)) {
	        ps.setString(1, teacherId);
	        try (ResultSet rs = ps.executeQuery()) {
	            if (rs.next()) {
	                String clsStr = rs.getString("classes");
	                if (clsStr != null && !clsStr.trim().isEmpty()) {
	                    String[] clsArr = clsStr.split(",");
	                    for (String cls : clsArr) {
	                        classes.add(cls.trim());
	                    }
	                }
	            }
	        }
	    }
	    return classes;
	}


	// Get subjects assigned to teacher from teacher table (comma separated)
	public List<String> getTeacherSubjects(String teacherId) throws SQLException {
		List<String> subjects = new ArrayList<>();
		String sql = "SELECT subjects FROM teacher WHERE t_id = ?";
		try (PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setString(1, teacherId);
			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next()) {
					String subStr = rs.getString("subjects");
					if (subStr != null && !subStr.trim().isEmpty()) {
						String[] subArr = subStr.split(",");
						for (String sub : subArr) {
							subjects.add(sub.trim());
						}
					}
				}
			}
		}
		return subjects;
	}

	public List<Map<String, String>> getHomeworksByClassAndTeacher(String className, String t_id) throws SQLException {
	    List<Map<String, String>> homeworks = new ArrayList<>();
	    String sql = "SELECT hw_id, title FROM homework WHERE class_name = ? AND t_id = ?";
	    try (PreparedStatement ps = conn.prepareStatement(sql)) {
	        ps.setString(1, className);
	        ps.setString(2, t_id);
	        try (ResultSet rs = ps.executeQuery()) {
	            while (rs.next()) {
	                Map<String, String> hw = new HashMap<>();
	                hw.put("hw_id", String.valueOf(rs.getInt("hw_id")));
	                hw.put("title", rs.getString("title"));
	                homeworks.add(hw);
	            }
	        }
	    }
	    return homeworks;
	}

	public List<Map<String, String>> getHomeworkSubmissionStatus(String className, String hw_id) throws SQLException {
	    List<Map<String, String>> statusList = new ArrayList<>();

	    String sql = """
	        SELECT s.s_id, s.s_name, COALESCE(hs.status, 'N') AS status
	        FROM student s
	        LEFT JOIN homework_status hs ON s.s_id = hs.s_id AND hs.hw_id = ?
	        WHERE s.class_name = ?
	    """;

	    try (PreparedStatement ps = conn.prepareStatement(sql)) {
	        ps.setString(1, hw_id);
	        ps.setString(2, className);
	        try (ResultSet rs = ps.executeQuery()) {
	            while (rs.next()) {
	                Map<String, String> map = new HashMap<>();
	                map.put("s_id", rs.getString("s_id"));
	                map.put("s_name", rs.getString("s_name"));
	                map.put("status", rs.getString("status"));
	                statusList.add(map);
	            }
	        }
	    }

	    return statusList;
	}
	public List<Map<String, String>> getHomeworkStatus(String className, int hwId) throws SQLException {
	    List<Map<String, String>> list = new ArrayList<>();

	    String sql = "SELECT s.s_id, s.s_name, COALESCE(hs.submitted, 'N') AS submitted " +
	                 "FROM student s " +
	                 "LEFT JOIN homework_status hs ON s.s_id = hs.s_id AND hs.hw_id = ? " +
	                 "WHERE s.class_name = ?";

	    try (PreparedStatement ps = conn.prepareStatement(sql)) {
	        ps.setInt(1, hwId);
	        ps.setString(2, className);
	        try (ResultSet rs = ps.executeQuery()) {
	            while (rs.next()) {
	                Map<String, String> row = new HashMap<>();
	                row.put("s_id", rs.getString("s_id"));
	                row.put("s_name", rs.getString("s_name"));
	                row.put("submitted", rs.getString("submitted"));
	                list.add(row);
	            }
	        }
	    }

	    return list;
	}



    public void updateExamScore(String s_id, String classCode, String examCode, int sub_id, int marks) throws SQLException {
        String sql = "INSERT INTO exam_scores (s_id, classCode, examCode, sub_id, marks) " +
                     "VALUES (?, ?, ?, ?, ?) " +
                     "ON DUPLICATE KEY UPDATE marks = VALUES(marks)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, s_id);
            ps.setString(2, classCode);
            ps.setString(3, examCode);
            ps.setInt(4, sub_id);
            ps.setInt(5, marks);
            ps.executeUpdate();
        }
    }



 // Fetch students by class
    public List<Map<String, String>> getStudentsByClass(String className) throws SQLException {
        List<Map<String, String>> list = new ArrayList<>();
        PreparedStatement ps = conn.prepareStatement("SELECT s_id, s_name FROM student WHERE class_name = ?");
        ps.setString(1, className);
        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            Map<String, String> row = new HashMap<>();
            row.put("s_id", rs.getString("s_id"));
            row.put("s_name", rs.getString("s_name"));
            list.add(row);
        }
        return list;
    }

    public List<String> getAllExamTypes() throws SQLException {
        List<String> list = new ArrayList<>();
        PreparedStatement ps = conn.prepareStatement("SELECT examCode FROM exam_type");
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            list.add(rs.getString("examCode"));
        }
        return list;
    }

    public Map<String, Object> getStudentExamScores(String s_id, String classCode, int subjectId) throws SQLException {
        Map<String, Object> result = new HashMap<>();

        // Basic student info
        String infoSql = "SELECT s_name FROM student WHERE s_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(infoSql)) {
            ps.setString(1, s_id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                result.put("s_id", s_id);
                result.put("s_name", rs.getString("s_name"));
            }
        }

        // Get exam scores
        String marksSql = "SELECT examCode, marks FROM exam_scores \r\n"
        		+ "WHERE s_id = ? AND classCode = ? AND sub_id = ?\r\n"
        		+ "";
        try (PreparedStatement ps = conn.prepareStatement(marksSql)) {
            ps.setString(1, s_id);
            ps.setString(2, classCode);
            ps.setInt(3, subjectId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                result.put(rs.getString("examCode"), rs.getInt("marks"));
            }
        }

        return result;
    }

    
    public List<Map<String, Object>> getExamScoresByClassAndSubject(String classCode, String subjectId) throws SQLException {
        List<Map<String, Object>> result = new ArrayList<>();

        // STEP 1: Get all distinct exam codes (e.g., UT1, UT2, Half-Yearly, Final)
        List<String> allExamCodes = new ArrayList<>();
        String examSql = "SELECT DISTINCT examCode FROM exam_scores";
        PreparedStatement examStmt = conn.prepareStatement(examSql);
        ResultSet examRs = examStmt.executeQuery();
        while (examRs.next()) {
            allExamCodes.add(examRs.getString("examCode"));
        }

        // STEP 2: Get list of students for that class
        String studentSql = "SELECT s_id, s_name FROM student WHERE class_name = ?";
        PreparedStatement ps1 = conn.prepareStatement(studentSql);
        ps1.setString(1, classCode);
        ResultSet rs1 = ps1.executeQuery();

        while (rs1.next()) {
            String s_id = rs1.getString("s_id");
            String s_name = rs1.getString("s_name");

            Map<String, Object> row = new HashMap<>();
            row.put("s_id", s_id);
            row.put("s_name", s_name);

            // STEP 3: Pre-fill all exams with default (e.g., "")
            for (String exam : allExamCodes) {
                row.put(exam, "");  // empty by default
            }

            // STEP 4: Get marks from DB
            String marksSql = "SELECT examCode, marks FROM exam_scores WHERE s_id=? AND classCode=? AND sub_id=?";
            PreparedStatement ps2 = conn.prepareStatement(marksSql);
            ps2.setString(1, s_id);
            ps2.setString(2, classCode);
            ps2.setString(3, subjectId);
            ResultSet rs2 = ps2.executeQuery();

            while (rs2.next()) {
                String examCode = rs2.getString("examCode");
                int marks = rs2.getInt("marks");
                row.put(examCode, marks);
            }

            result.add(row);
        }

        return result;
    }

    // Insert attendance    
    public void markAttendance(String s_id, String className, String date, String status) {
        try {
            PreparedStatement ps = conn.prepareStatement(
                "INSERT INTO attendance_teacher (s_id, class_name, attendance_date, status) VALUES (?, ?, ?, ?)");
            ps.setString(1, s_id);
            ps.setString(2, className);
            ps.setDate(3, java.sql.Date.valueOf(date));
            ps.setString(4, status);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    


}