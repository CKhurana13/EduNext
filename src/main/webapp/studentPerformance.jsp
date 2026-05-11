<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Performance</title>
  <style>
    :root {
      --primary-blue: #6b8cff;
      --secondary-blue: #4d6cfa;
      --pastel-blue: #e0e7ff;
      --dark-blue: #1e40af;
      --light-blue: #b3c9e6;
      --navy-blue: #1a2a44;
      --white: #ffffff;
      --text-dark: #333333;
      --light-gray: #d3d3d3;
      --pastel-gradient: linear-gradient(135deg, rgba(107, 140, 255, 0.7), rgba(147, 197, 253, 0.7));
      --pastel-gradient-hover: linear-gradient(135deg, rgba(77, 108, 250, 0.7), rgba(96, 165, 250, 0.7));
    }

    body {
      font-family: 'Arial', sans-serif;
      margin: 0;
      padding: 20px;
      background-color: var(--pastel-blue);
      background: repeating-linear-gradient(45deg, var(--light-blue) 0, var(--light-blue) 10px, #d1e0ff 10px, #d1e0ff 20px),
                  repeating-linear-gradient(-45deg, var(--light-blue) 0, var(--light-blue) 10px, #d1e0ff 10px, #d1e0ff 20px);
      background-blend-mode: overlay;
      display: flex;
      justify-content: center;
      align-items: center;
      min-height: 100vh;
      position: relative;
    }

    .logo {
      position: absolute;
      top: 20px;
      left: 20px;
      width: 100px;
      height: auto;
    }

    .container {
      background: var(--white);
      padding: 0 30px 30px 30px;
      border-radius: 20px;
      box-shadow: 0 10px 30px rgba(107, 140, 255, 0.2);
      text-align: center;
      width: 100%;
      max-width: 1000px;
      min-height: 450px;
      display: flex;
      flex-direction: column;
      justify-content: flex-start;
      z-index: 1;
    }

    .header-container {
      display: flex;
      align-items: center;
      width: 100%;
      margin-top: 20px;
    }

    .tab-arrow {
      color: var(--primary-blue);
      font-size: 24px;
      font-weight: bold;
      cursor: pointer;
      padding: 10px;
      margin-right: 10px;
    }

    .tab-container {
      flex-grow: 1;
      background: var(--dark-blue);
      border-radius: 10px 10px 0 0;
    }

    .header {
      background: transparent;
      color: var(--white);
      padding: 10px;
      text-align: center;
      font-size: 18px;
      font-weight: bold;
    }

    .options-container {
      display: flex;
      justify-content: space-around;
      align-items: center;
      flex-wrap: wrap;
      gap: 30px;
      padding: 100px;
    }

    .option-box {
      display: flex;
      flex-direction: column;
      align-items: center;
      cursor: pointer;
      transition: transform 0.2s;
    }

    .option-circle {
      width: 200px;
      height: 200px;
      background: var(--pastel-gradient);
      border: 3px solid var(--dark-blue);
      border-radius: 50%;
      display: flex;
      justify-content: center;
      align-items: center;
      overflow: hidden;
      transition: background 0.3s, transform 0.3s, border-color 0.3s;
    }

    .option-circle img {
      width: 100%;
      height: 100%;
      object-fit: cover;
      display: block;
    }

    .option-box:hover .option-circle {
      background: var(--pastel-gradient-hover);
      border-color: var(--navy-blue);
      transform: scale(1.05);
    }

    .option-text {
      margin-top: 10px;
      color: var(--navy-blue);
      font-size: 18px;
      font-weight: bold;
    }

    .modal {
      display: none;
      position: fixed;
      top: 0; left: 0;
      width: 100%; height: 100%;
      background: rgba(0, 0, 0, 0.5);
      z-index: 1000;
      justify-content: center;
      align-items: center;
    }

    .modal-content {
      background: var(--white);
      padding: 0 20px 20px 20px;
      border-radius: 10px;
      max-width: 600px;
      width: 90%;
      text-align: left;
      box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
    }

    .modal-title {
      background: var(--navy-blue);
      color: var(--white);
      margin: 0 -20px 20px -20px;
      padding: 10px;
      font-size: 24px;
      text-align: center;
      border-radius: 10px 10px 0 0;
    }

    .modal-content p {
      color: var(--text-dark);
      font-size: 16px;
      white-space: pre-line;
      margin: 0;
      font-weight: bold;
      text-transform: uppercase;
    }

    .modal-content button {
      background: var(--primary-blue);
      color: var(--white);
      border: none;
      padding: 10px 20px;
      border-radius: 5px;
      cursor: pointer;
      display: block;
      margin: 20px auto 0;
    }

    .modal-content button:hover {
      background: var(--secondary-blue);
    }

    .tab-buttons {
      display: flex;
      justify-content: center;
      gap: 10px;
      flex-wrap: wrap;
      margin-bottom: 10px;
    }

    .tab-buttons button {
      background: var(--light-blue);
      border: none;
      padding: 8px 16px;
      border-radius: 5px;
      cursor: pointer;
      font-weight: bold;
      color: var(--navy-blue);
    }

    .tab-buttons button.active {
      background: var(--primary-blue);
      color: var(--white);
    }

    @media (max-width: 600px) {
      .container {
        width: 95%;
        padding: 0 20px 20px 20px;
      }

      .option-circle {
        width: 120px;
        height: 120px;
      }

      .option-text {
        font-size: 16px;
      }

      .modal-content p {
        font-size: 14px;
      }
    }
  </style>
</head>
<body>
<%
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    session = request.getSession(false);
    if (session == null || session.getAttribute("rollNumber") == null) {
        response.sendRedirect("studentLogin.jsp");
        return;
    }

    int rollNumber = Integer.parseInt((String) session.getAttribute("rollNumber"));

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/teacher_web", "root", "vips");

        // --- Generate Exam JSON ---
        out.println("<script>var examData = {");
        String examSql = "SELECT es.examCode, s.sub_name, es.marks FROM exam_scores es JOIN subjects s ON es.sub_id = s.sub_id WHERE es.rollNumber = ?";
        ps = conn.prepareStatement(examSql);
        ps.setInt(1, rollNumber);
        rs = ps.executeQuery();

        Map<String, Map<String, Integer>> examMap = new LinkedHashMap<>();
        while (rs.next()) {
            String exam = rs.getString("examCode");
            String subject = rs.getString("sub_name");
            int marks = rs.getInt("marks");

            examMap.putIfAbsent(exam, new LinkedHashMap<>());
            examMap.get(exam).put(subject, marks);
        }

        int examCount = 0;
        for (Map.Entry<String, Map<String, Integer>> examEntry : examMap.entrySet()) {
            String exam = examEntry.getKey();
            Map<String, Integer> subjectMarks = examEntry.getValue();

            out.print("\"" + exam + "\": { subjects: {");
            int subjCount = 0;
            int total = 0;
            for (Map.Entry<String, Integer> subj : subjectMarks.entrySet()) {
                out.print("\"" + subj.getKey() + "\": " + subj.getValue());
                total += subj.getValue();
                if (++subjCount < subjectMarks.size()) out.print(", ");
            }
            double percentage = (double) total / subjectMarks.size();
            out.print("}, percentage: " + String.format("%.1f", percentage) + " }");

            if (++examCount < examMap.size()) out.print(", ");
        }
        out.println("};</script>");

        // --- Generate Overall Exam Data ---
        out.println("<script>var overallExamData = {");
        String overallSql = "SELECT s.sub_name, es.marks FROM exam_scores es JOIN subjects s ON es.sub_id = s.sub_id WHERE es.rollNumber = ?";
        ps = conn.prepareStatement(overallSql);
        ps.setInt(1, rollNumber);
        rs = ps.executeQuery();

        Map<String, List<Integer>> overallMap = new LinkedHashMap<>();
        while (rs.next()) {
            String subject = rs.getString("sub_name");
            int marks = rs.getInt("marks");
            overallMap.computeIfAbsent(subject, k -> new ArrayList<>()).add(marks);
        }

        int subjCount = 0;
        int grandTotal = 0;
        int totalSubjects = 0;
        for (Map.Entry<String, List<Integer>> entry : overallMap.entrySet()) {
            String subject = entry.getKey();
            List<Integer> marksList = entry.getValue();
            int avgMarks = (int) marksList.stream().mapToInt(Integer::intValue).average().orElse(0);
            out.print("\"" + subject + "\": " + avgMarks);
            grandTotal += avgMarks;
            totalSubjects++;
            if (++subjCount < overallMap.size()) out.print(", ");
        }
        double overallPercentage = totalSubjects > 0 ? (double) grandTotal / totalSubjects : 0;
        out.println(", \"overallPercentage\": " + String.format("%.1f", overallPercentage) + "};");
        out.println("</script>");

        // --- Generate Homework JSON ---
        out.println("<script>var homeworkData = {");
        String hwSql = "SELECT h.className, h.description, hs.status FROM homework h JOIN homework_status hs ON h.hw_id = hs.hw_id WHERE hs.rollNumber = ?";
        ps = conn.prepareStatement(hwSql);
        ps.setInt(1, rollNumber);
        rs = ps.executeQuery();

        Map<String, List<String>> hwMap = new LinkedHashMap<>();
        while (rs.next()) {
            String className = rs.getString("className");
            String desc = rs.getString("description");
            String status = rs.getString("status");
            String entry = "`" + desc + "` - " + status;

            hwMap.computeIfAbsent(className, k -> new ArrayList<>()).add(entry);
        }

        int i = 0;
        for (Map.Entry<String, List<String>> entry : hwMap.entrySet()) {
            out.print("\"" + entry.getKey() + "\": [");
            for (int j = 0; j < entry.getValue().size(); j++) {
                out.print("\"" + entry.getValue().get(j) + "\"");
                if (j < entry.getValue().size() - 1) out.print(", ");
            }
            out.print("]");
            if (++i < hwMap.size()) out.print(", ");
        }
        out.println("};</script>");

        // --- Generate Attendance JSON ---
        out.println("<script>var attendanceData = {");
        String attSql = "SELECT COUNT(*) as total, SUM(CASE WHEN status = 'P' THEN 1 ELSE 0 END) as present, SUM(CASE WHEN status = 'A' THEN 1 ELSE 0 END) as absent FROM attendance_teacher WHERE rollNumber = ?";
        ps = conn.prepareStatement(attSql);
        ps.setInt(1, rollNumber);
        rs = ps.executeQuery();

        if (rs.next()) {
            int totalDays = rs.getInt("total");
            int presentDays = rs.getInt("present");
            int absentDays = rs.getInt("absent");
            double attendancePercentage = totalDays > 0 ? ((double) presentDays / totalDays) * 100 : 0;
            out.print("\"total\": " + totalDays + ", ");
            out.print("\"present\": " + presentDays + ", ");
            out.print("\"absent\": " + absentDays + ", ");
            out.print("\"percentage\": " + String.format("%.1f", attendancePercentage));
        }
        out.println("};</script>");

    } catch (Exception e) {
        out.println("<script>console.error('Error fetching data: " + e.getMessage() + "');</script>");
        e.printStackTrace();
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
        if (ps != null) try { ps.close(); } catch (SQLException ignored) {}
        if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
    }
%>

  <img src="images/logo.png" alt="EduNext Logo" class="logo">
  <div class="container">
    <div class="header-container">
      <span class="tab-arrow" onclick="goToDashboard()">←</span>
      <div class="tab-container">
        <div class="header">PERFORMANCE</div>
      </div>
    </div>
    <div class="options-container">
      <div class="option-box" onclick="goToSection('exam')">
        <div class="option-circle">
          <img src="images/exam.png" alt="Exam"/>
        </div>
        <div class="option-text">EXAM</div>
      </div>
      <div class="option-box" onclick="goToSection('homework')">
        <div class="option-circle">
          <img src="images/performance_homework.png" alt="Homework"/>
        </div>
        <div class="option-text">HOMEWORK</div>
      </div>
      <div class="option-box" onclick="goToSection('attendance')">
        <div class="option-circle">
          <img src="images/attendance3.png" alt="Attendance"/>
        </div>
        <div class="option-text">ATTENDANCE</div>
      </div>
    </div>
  </div>

  <div class="modal" id="infoModal">
    <div class="modal-content">
      <h2 class="modal-title" id="modalTitle"></h2>
      <div class="tab-buttons" id="examTabs" style="display: none;"></div>
      <p id="modalMessage"></p>
      <button onclick="closeModal()">Close</button>
    </div>
  </div>

  <script>
    function goToDashboard() {
      window.location.href = 'studentDashboard.jsp';
    }

    function goToSection(section) {
      const modal = document.getElementById('infoModal');
      const modalTitle = document.getElementById('modalTitle');
      const modalMessage = document.getElementById('modalMessage');
      const tabs = document.getElementById('examTabs');

      modalTitle.textContent = section.toUpperCase();

      if (section === 'exam') {
        tabs.innerHTML = '';
        tabs.style.display = 'flex';
        modalMessage.textContent = '';

        for (let key in examData) {
          const button = document.createElement('button');
          button.textContent = key;
          button.onclick = () => showExamTab(key, button);
          tabs.appendChild(button);
        }

        const first = tabs.querySelector('button');
        if (first) showExamTab(first.textContent, first);

      } else if (section === 'homework') {
        tabs.style.display = 'none';
        let hwText = "";

        for (let className in homeworkData) {
          hwText += className + ":\n";
          homeworkData[className].forEach(hw => hwText += "• " + hw + "\n");
          hwText += "\n";
        }
        modalMessage.textContent = hwText.trim();

      } else if (section === 'attendance') {
        tabs.style.display = 'none';
        if (attendanceData && Object.keys(attendanceData).length > 0) {
          modalMessage.textContent = `Total Days: ${attendanceData.total}\nPresent: ${attendanceData.present}\nAbsent: ${attendanceData.absent}\nOverall Percentage: ${attendanceData.percentage}%`;
        } else {
          modalMessage.textContent = "No attendance data available.";
        }
      }

      modal.style.display = 'flex';
    }

    function showExamTab(key, activeBtn) {
      const examDataEntry = examData[key];
      let message = "Subject-wise Marks:\n";
      for (let subject in overallExamData) {
        if (subject !== "overallPercentage") {
          message += `${subject}: ${overallExamData[subject]}\n`;
        }
      }
      message += `\nOverall Percentage: ${overallExamData.overallPercentage}%`;

      document.getElementById('modalMessage').textContent = message;

      const buttons = document.querySelectorAll('#examTabs button');
      buttons.forEach(btn => btn.classList.remove('active'));
      activeBtn.classList.add('active');
    }

    function closeModal() {
      document.getElementById('infoModal').style.display = 'none';
    }
  </script>
</body>
</html>