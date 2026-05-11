<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.TimeZone" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Attendance - EduNext</title>
    <style>
        :root {
            --blue: #003087;
            --green: #28a745;
            --red: #dc3545;
            --purple: #a678e2;
            --light: #f0f3fc;
            --text: #333;
            --light-bg: #f0f3fc;
        }

        body {
            font-family: 'Segoe UI', sans-serif;
            margin: 0;
            padding: 20px;
            background-color: var(--light-bg);
            background: repeating-linear-gradient(45deg, #e0e7ff 0, #e0e7ff 10px, #d1e0ff 10px, #d1e0ff 20px),
                        repeating-linear-gradient(-45deg, #e0e7ff 0, #e0e7ff 10px, #d1e0ff 10px, #d1e0ff 20px);
            background-blend-mode: overlay;
            display: flex;
            flex-direction: column;
            align-items: center;
            min-height: 100vh;
        }

        .logo-container {
            align-self: flex-start;
            padding: 20px;
        }

        .logo-container img {
            width: 140px;
            height: auto;
        }

        .container {
            background: white;
            padding: 20px;
            border-radius: 20px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
            max-width: 800px;
            width: 100%;
            margin-top: 10px;
            margin-bottom: 30px;
        }

        .header {
            display: flex;
            align-items: center;
            font-size: 20px;
            font-weight: bold;
            color: white;
            background-color: var(--blue);
            padding: 10px 15px;
            border-radius: 10px;
            margin-bottom: 20px;
        }

        .header i {
            font-style: normal;
            margin-right: 10px;
            cursor: pointer;
            color: white;
        }

        .overall-bar {
            background-color: #eef1f5;
            padding: 10px 20px;
            border-radius: 8px;
            margin-bottom: 15px;
            display: flex;
            justify-content: space-between;
            font-weight: bold;
            font-size: 14px;
        }

        .status-cards {
            display: flex;
            justify-content: space-between;
            gap: 10px;
            margin-bottom: 25px;
        }

        .status-card {
            background-color: #edf4fc;
            border-radius: 15px;
            padding: 10px 15px;
            display: flex;
            align-items: center;
            width: 30%;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
        }

        .status-left {
            margin-right: 12px;
        }

        .status-circle {
            width: 40px;
            height: 40px;
            border: 4px solid;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            font-size: 12px;
        }

        .status-circle.green {
            border-color: var(--green);
            color: var(--green);
        }

        .status-circle.red {
            border-color: var(--red);
            color: var(--red);
        }

        .status-circle.purple {
            border-color: var(--purple);
            color: var(--purple);
        }

        .status-label {
            font-size: 14px;
            font-weight: 600;
            color: #333;
        }

        .status-count {
            font-size: 12px;
            color: #666;
        }

        .calendar-container {
            text-align: center;
            border: 2px dashed var(--purple);
            border-radius: 15px;
            padding: 15px;
            width: 50%;
            margin: 0 auto;
        }

        .calendar-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
            font-size: 14px;
        }

        .calendar-header button {
            background: var(--blue);
            color: white;
            border: none;
            border-radius: 5px;
            padding: 3px 8px;
            cursor: pointer;
        }

        .calendar-grid {
            display: grid;
            grid-template-columns: repeat(7, 1fr);
            gap: 6px;
            font-weight: bold;
        }

        .calendar-day {
            width: 25px;
            height: 25px;
            line-height: 25px;
            border-radius: 50%;
            background: #fff;
            color: var(--text);
            font-size: 10px;
            display: flex;
            justify-content: center;
            align-items: center;
            border: 2px solid transparent;
        }

        .present-day {
            background-color: var(--green);
            color: white;
            border-color: var(--green);
        }

        .absent-day {
            background-color: var(--red);
            color: white;
            border-color: var(--red);
        }

        .holiday-day {
            background-color: var(--purple);
            color: white;
            border-color: var(--purple);
        }

        .no-data {
            background-color: transparent;
            border-color: transparent;
        }

        .disabled {
            opacity: 0.4;
        }
    </style>
</head>

<body>
    <div class="logo-container">
        <img src="images/logo.png" alt="EduNext Logo" />
    </div>

    <div class="container">
        <div class="header">
            <i onclick="window.location.href='dashboardStudent.jsp'">←</i>
            ATTENDANCE
        </div>

        <%
            // Retrieve s_id from session with error handling
            String s_id = null;
            Object sessionSId = session.getAttribute("s_id");
            if (sessionSId != null) {
                if (sessionSId instanceof String) {
                    s_id = (String) sessionSId;
                } else {
                    out.println("<p>Error: Invalid s_id format in session.</p>");
                    return;
                }
            }

            if (s_id == null) {
                response.sendRedirect("studentLogin.jsp"); // Redirect to login if not logged in
                return;
            }

            // Database connection
            Connection conn = null;
            Statement stmt = null;
            ResultSet rs = null;
            Map<String, String> attendanceMap = new HashMap<>();
            int present = 0, absent = 0, holiday = 0;
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/teacher_web", "root", "vips");
                stmt = conn.createStatement();

                // Fetch attendance data for the s_id
                String sql = "SELECT attendance_date, status FROM attendance_teacher WHERE s_id = '" + s_id + "'";
                rs = stmt.executeQuery(sql);

                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                sdf.setTimeZone(TimeZone.getTimeZone("Asia/Kolkata")); // Set to IST

                while (rs.next()) {
                    String dateStr = sdf.format(rs.getDate("attendance_date"));
                    String status = rs.getString("status");
                    attendanceMap.put(dateStr, status);
                    if ("P".equals(status)) present++;
                    else if ("A".equals(status)) absent++;
                }

                int totalDays = present + absent; // Total days with attendance data
                double overallPercentage = (totalDays > 0) ? (present * 100.0 / totalDays) : 0;
        %>
        <div class="overall-bar">
            <span>Overall Attendance</span>
            <span><%= String.format("%.2f", overallPercentage) %>% | <%= present %>/<%= totalDays %> days</span>
        </div>

        <div class="status-cards">
            <div class="status-card">
                <div class="status-left">
                    <div class="status-circle green" id="presentPercent"><%= String.format("%.0f", (present * 100.0 / totalDays)) %>%</div>
                </div>
                <div class="status-right">
                    <div class="status-label">Present</div>
                    <div class="status-count" id="presentDays"><%= present %> days</div>
                </div>
            </div>
            <div class="status-card">
                <div class="status-left">
                    <div class="status-circle red" id="absentPercent"><%= String.format("%.0f", (absent * 100.0 / totalDays)) %>%</div>
                </div>
                <div class="status-right">
                    <div class="status-label">Absent</div>
                    <div class="status-count" id="absentDays"><%= absent %> days</div>
                </div>
            </div>
            <div class="status-card">
                <div class="status-left">
                    <div class="status-circle purple" id="holidayPercent"><%= String.format("%.0f", (holiday * 100.0 / totalDays)) %>%</div>
                </div>
                <div class="status-right">
                    <div class="status-label">Holiday</div>
                    <div class="status-count" id="holidayDays"><%= holiday %> days</div>
                </div>
            </div>
        </div>

        <div class="calendar-container">
            <div class="calendar-header">
                <button onclick="prevMonth()"><</button>
                <div id="monthYear"></div>
                <button onclick="nextMonth()">></button>
            </div>
            <div class="calendar-grid" id="calendarGrid"></div>
        </div>
        <%
            } catch (Exception e) {
                out.println("<p>Error: " + e.getMessage() + "</p>");
            } finally {
                if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
                if (stmt != null) try { stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
                if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
        %>

    </div>

    <script>
        // Convert attendanceMap to a JavaScript object manually
        <% 
            StringBuilder jsonStr = new StringBuilder("{");
            boolean first = true;
            for (Map.Entry<String, String> entry : attendanceMap.entrySet()) {
                if (!first) jsonStr.append(",");
                jsonStr.append("\"").append(entry.getKey()).append("\":\"").append(entry.getValue()).append("\"");
                first = false;
            }
            jsonStr.append("}");
        %>
        const attendanceData = <%= jsonStr.toString() %> || {};
        const calendarGrid = document.getElementById("calendarGrid");
        const monthYear = document.getElementById("monthYear");
        let currentDate = new Date();

        function renderCalendar(date) {
            calendarGrid.innerHTML = "";
            const year = date.getFullYear();
            const month = date.getMonth();
            const firstDay = new Date(year, month, 1).getDay(); // Get the day of the week for the 1st
            const totalDays = new Date(year, month + 1, 0).getDate(); // Total days in the month

            const weekdays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
            weekdays.forEach(day => {
                const cell = document.createElement('div');
                cell.textContent = day;
                cell.style.fontWeight = 'bold';
                calendarGrid.appendChild(cell);
            });

            // Add empty cells before the first day
            for (let i = 0; i < firstDay; i++) {
                const empty = document.createElement("div");
                empty.classList.add("calendar-day", "disabled");
                calendarGrid.appendChild(empty);
            }

            // Add days of the month
            for (let day = 1; day <= totalDays; day++) {
                const cell = document.createElement("div");
                cell.className = "calendar-day no-data"; // Default to no color
                const current = new Date(year, month, day);
                // Adjust to IST for consistency
                const dateStr = new Date(current.getTime() + (5.5 * 60 * 60 * 1000)).toISOString().split('T')[0];
                if (current.getDay() === 0 || current.getDay() === 6) {
                    cell.classList.remove("no-data");
                    cell.classList.add("holiday-day");
                } else if (attendanceData[dateStr]) {
                    const status = attendanceData[dateStr].toLowerCase();
                    cell.classList.remove("no-data");
                    if (status === "p") cell.classList.add("present-day");
                    else if (status === "a") cell.classList.add("absent-day");
                }
                cell.textContent = day;
                calendarGrid.appendChild(cell);
            }

            monthYear.textContent = `${date.toLocaleString('default', { month: 'long' })} ${year}`;
        }

        function prevMonth() {
            currentDate.setMonth(currentDate.getMonth() - 1);
            renderCalendar(currentDate);
        }

        function nextMonth() {
            currentDate.setMonth(currentDate.getMonth() + 1);
            renderCalendar(currentDate);
        }

        renderCalendar(currentDate);
    </script>
</body>
</html>