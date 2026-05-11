<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*, java.text.SimpleDateFormat, java.util.Enumeration, java.util.HashMap, java.util.ArrayList, java.util.Map, java.util.List, java.util.Collections, java.util.Comparator"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Timetable - EduNext</title>
    <style>
        :root {
            --primary: #1565c0;
            --secondary: #e3f2fd;
            --break-color: #e1f5fe;
            --header-blue: #0d47a1;
            --pastel-blue: #90caf9;
            --tab-bg: #bbdefb;
            --text-dark: #212121;
            --text-light: #616161;
            --page-bg: #f5faff;
        }

        body {
            margin: 0;
            padding: 20px;
            font-family: 'Segoe UI', sans-serif;
            background-color: var(--page-bg);
            display: flex;
            justify-content: center;
            align-items: flex-start;
            min-height: 100vh;
            position: relative;
            background: repeating-linear-gradient(45deg, var(--secondary) 0, var(--secondary) 10px, var(--tab-bg) 10px, var(--tab-bg) 20px),
                        repeating-linear-gradient(-45deg, var(--secondary) 0, var(--secondary) 10px, var(--tab-bg) 10px, var(--tab-bg) 20px);
            background-blend-mode: overlay;
        }

        .top-left-img {
            position: absolute;
            top: 20px;
            left: 20px;
            width: 120px;
            height: auto;
            z-index: 10;
        }

        .bottom-right-img {
            position: fixed;
            bottom: 10px;
            right: 20px;
            width: 300px;
            height: auto;
            z-index: 10;
        }

        .container {
            min-width: 600px;
            background: white;
            border-radius: 15px;
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
            padding: 30px;
            margin: 40px;
        }

        .header {
            display: flex;
            align-items: center;
            margin-bottom: 30px;
            background-color: var(--header-blue);
            padding: 10px 20px;
            border-radius: 10px;
        }

        .back-arrow {
            text-decoration: none;
            font-size: 22px;
            color: white;
            margin-right: 15px;
        }

        .header h1 {
            font-size: 28px;
            color: white;
            margin: 0;
            text-align: center;
            flex-grow: 1;
        }

        .tabs {
            display: flex;
            justify-content: space-around;
            margin-bottom: 20px;
            background-color: var(--tab-bg);
            border-radius: 10px;
            padding: 5px;
        }

        .tab {
            padding: 10px 15px;
            cursor: pointer;
            font-weight: bold;
            color: var(--text-dark);
            border-radius: 8px;
            transition: background-color 0.3s, color 0.3s;
        }

        .tab.active {
            background-color: var(--primary);
            color: white;
        }

        .day-content {
            display: none;
        }

        .day-content.active {
            display: block;
        }

        .period {
            background-color: var(--secondary);
            margin: 10px 0;
            padding: 10px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
        }

        .period-content {
            flex: 1;
            display: flex;
            flex-direction: column;
        }
.logo {
            position: absolute;
            top: 20px;
            left: 20px;
            width: 100px;
            height: auto;
            z-index: 1000;
        }
        .period .subject {
            font-size: 18px;
            font-weight: bold;
            color: var(--text-dark);
            padding: 5px 10px;
            background-color: var(--pastel-blue);
            border-radius: 5px;
            text-align: left;
            width: calc(100% - 10px);
        }

        .period .details {
            font-size: 14px;
            color: var(--text-light);
            text-align: left;
            margin-top: 5px;
        }

        .period img {
            width: 40px;
            height: 40px;
            margin-left: 15px;
            object-fit: cover;
        }

        .break {
            background-color: var(--break-color);
            text-align: center;
            padding: 10px;
            border-radius: 10px;
            font-weight: bold;
            color: var(--text-dark);
            margin: 10px 0;
        }

        .preload-images {
            display: none;
        }

        @media (max-width: 600px) {
            .container {
                padding: 15px;
                margin: 40px 15px 15px;
            }

            .top-left-img, .bottom-right-img {
                width: 60px;
                height: 60px;
            }

            .header h1 {
                font-size: 24px;
            }

            .tab {
                font-size: 14px;
                padding: 8px;
            }

            .period .subject {
                font-size: 16px;
            }

            .period .details {
                font-size: 12px;
            }

            .period img {
                width: 30px;
                height: 30px;
            }

            .break {
                font-size: 14px;
            }
        }
    </style>
</head>
<body>
    <img src="images/logo.png" alt="School Logo" class="logo">
    <div class="preload-images">
        <img src="images/logo.png">
        <img src="images/time_teacher.png">
        <img src="S/images/default.png">
    </div>
    <div class="container">
        <div class="header">
            <a href="dashboard.jsp" class="back-arrow">←</a>
            <h1>Timetable</h1>
        </div>

        <%
            // Debug session attributes
            StringBuilder attrLog = new StringBuilder();
            Enumeration<String> sessionAttributes = session.getAttributeNames();
            while (sessionAttributes.hasMoreElements()) {
                String attr = sessionAttributes.nextElement();
                attrLog.append(attr).append("=").append(session.getAttribute(attr)).append(", ");
            }
            out.println("<script>console.log('Session attributes: " + attrLog.toString() + "');</script>");

            // Check session and attributes
            if (session == null || session.getAttribute("s_id") == null || 
                session.getAttribute("class_name") == null) {
                out.println("<script>console.error('Missing session attributes: s_id=" + 
                            session.getAttribute("s_id") + ", class_name=" + 
                            session.getAttribute("class_name") + "');</script>");
                response.sendRedirect("studentLogin.jsp");
                return;
            }
            String s_id = (String) session.getAttribute("s_id");
            String class_name = ((String) session.getAttribute("class_name")).trim().toUpperCase();
            out.println("<script>console.log('Using s_id=" + s_id + ", class_name=" + class_name + "');</script>");

            Connection conn = null;
            PreparedStatement ps = null;
            ResultSet rs = null;
            String url = "jdbc:mysql://localhost:3306/teacher_web?useSSL=false";
            String user = "root";
            String password = "vips";

            Map<Integer, String> subjects = new HashMap<>();
            Map<Integer, String> subjectIcons = new HashMap<>();
            Map<Integer, String> teachers = new HashMap<>();
            Map<Integer, Map<String, String>> periodSlots = new HashMap<>();
            Map<String, List<Map<String, Object>>> timetable = new HashMap<>();

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection(url, user, password);

                // Load period slots
                ps = conn.prepareStatement("SELECT period_no, start_time, end_time, is_break FROM period_slots ORDER BY period_no");
                rs = ps.executeQuery();
                SimpleDateFormat dbFormat = new SimpleDateFormat("HH:mm:ss");
                SimpleDateFormat displayFormat = new SimpleDateFormat("hh:mm a");
                while (rs.next()) {
                    Map<String, String> slot = new HashMap<>();
                    java.sql.Time startTime = rs.getTime("start_time");
                    java.sql.Time endTime = rs.getTime("end_time");
                    slot.put("start_time", startTime != null ? displayFormat.format(startTime) : "N/A");
                    slot.put("end_time", endTime != null ? displayFormat.format(endTime) : "N/A");
                    slot.put("is_break", rs.getString("is_break"));
                    periodSlots.put(rs.getInt("period_no"), slot);
                }

                // Load subjects
                ps = conn.prepareStatement("SELECT sub_id, sub_name, icon_path FROM subjects");
                rs = ps.executeQuery();
                while (rs.next()) {
                    subjects.put(rs.getInt("sub_id"), rs.getString("sub_name"));
                    subjectIcons.put(rs.getInt("sub_id"), rs.getString("icon_path") != null ? rs.getString("icon_path") : "S/images/default.png");
                }

                // Load teachers
                ps = conn.prepareStatement("SELECT t_id, t_name FROM teacher");
                rs = ps.executeQuery();
                while (rs.next()) {
                    teachers.put(rs.getInt("t_id"), rs.getString("t_name"));
                }

                // Load timetable for the class
                ps = conn.prepareStatement(
                    "SELECT t.day, t.period_no, t.sub_id, t.t_id FROM timetable t WHERE t.class_name = ? " +
                    "ORDER BY FIELD(t.day, 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'), t.period_no"
                );
                ps.setString(1, class_name);
                rs = ps.executeQuery();

                while (rs.next()) {
                    String day = rs.getString("day");
                    int periodNo = rs.getInt("period_no");
                    int subId = rs.getInt("sub_id");
                    int teacherId = rs.getInt("t_id");

                    Map<String, String> slot = periodSlots.get(periodNo);
                    if (slot != null && "1".equals(slot.get("is_break")) && periodNo != 3 && periodNo != 6) {
                        Map<String, Object> breakPeriod = new HashMap<>();
                        breakPeriod.put("type", "break");
                        breakPeriod.put("description", "Break");
                        breakPeriod.put("start_time", slot.get("start_time"));
                        breakPeriod.put("end_time", slot.get("end_time"));
                        breakPeriod.put("period_no", periodNo);
                        timetable.computeIfAbsent(day, k -> new ArrayList<>()).add(breakPeriod);
                    } else if (periodNo != 3 && periodNo != 6) {
                        Map<String, Object> period = new HashMap<>();
                        period.put("type", "period");
                        period.put("subject", subjects.getOrDefault(subId, "Unknown"));
                        period.put("teacher", teachers.getOrDefault(teacherId, "Unknown"));
                        period.put("icon", subjectIcons.getOrDefault(subId, "S/images/default.png"));
                        period.put("start_time", slot != null ? slot.get("start_time") : "N/A");
                        period.put("end_time", slot != null ? slot.get("end_time") : "N/A");
                        period.put("period_no", periodNo);
                        timetable.computeIfAbsent(day, k -> new ArrayList<>()).add(period);
                    }
                }

                // Add Fruit Break (period_no = 3) and Lunch Break (period_no = 6) for all days
                String[] days = {"Monday", "Tuesday", "Wednesday", "Thursday", "Friday"};
                for (String day : days) {
                    List<Map<String, Object>> daySchedule = timetable.computeIfAbsent(day, k -> new ArrayList<>());

                    // Add Fruit Break at period_no = 3
                    Map<String, String> fruitSlot = periodSlots.get(3);
                    if (fruitSlot != null) {
                        Map<String, Object> fruitBreak = new HashMap<>();
                        fruitBreak.put("type", "break");
                        fruitBreak.put("description", "Fruit Break");
                        fruitBreak.put("start_time", fruitSlot.get("start_time"));
                        fruitBreak.put("end_time", fruitSlot.get("end_time"));
                        fruitBreak.put("period_no", 3);
                        daySchedule.add(fruitBreak);
                    }

                    // Add Lunch Break at period_no = 6
                    Map<String, String> lunchSlot = periodSlots.get(6);
                    if (lunchSlot != null) {
                        Map<String, Object> lunchBreak = new HashMap<>();
                        lunchBreak.put("type", "break");
                        lunchBreak.put("description", "Lunch Break");
                        lunchBreak.put("start_time", lunchSlot.get("start_time"));
                        lunchBreak.put("end_time", lunchSlot.get("end_time"));
                        lunchBreak.put("period_no", 6);
                        daySchedule.add(lunchBreak);
                    }

                    // Sort by period_no
                    Collections.sort(daySchedule, new Comparator<Map<String, Object>>() {
                        @Override
                        public int compare(Map<String, Object> o1, Map<String, Object> o2) {
                            Integer p1 = (Integer) o1.get("period_no");
                            Integer p2 = (Integer) o2.get("period_no");
                            return p1.compareTo(p2);
                        }
                    });
                }

            } catch (SQLException e) {
                out.println("<div style='color: red;'>Error retrieving timetable: " + e.getMessage() + "</div>");
                out.println("<script>console.error('Database error: " + e.getMessage() + "');</script>");
                e.printStackTrace();
            } catch (Exception e) {
                out.println("<div style='color: red;'>Error parsing time: " + e.getMessage() + "</div>");
                out.println("<script>console.error('Time parsing error: " + e.getMessage() + "');</script>");
                e.printStackTrace();
            } finally {
                try {
                    if (rs != null) rs.close();
                    if (ps != null) ps.close();
                    if (conn != null) conn.close();
                } catch (SQLException e) {
                    out.println("<div style='color: red;'>Error closing resources: " + e.getMessage() + "</div>");
                    out.println("<script>console.error('Resource closing error: " + e.getMessage() + "');</script>");
                }
            }
        %>

        <div class="tabs">
            <div class="tab active" onclick="showDay('monday')">Monday</div>
            <div class="tab" onclick="showDay('tuesday')">Tuesday</div>
            <div class="tab" onclick="showDay('wednesday')">Wednesday</div>
            <div class="tab" onclick="showDay('thursday')">Thursday</div>
            <div class="tab" onclick="showDay('friday')">Friday</div>
        </div>

        <div id="monday" class="day-content active">
            <% for (Map<String, Object> item : timetable.getOrDefault("Monday", new ArrayList<>())) { %>
                <% if ("break".equals(item.get("type"))) { %>
                    <div class="break">
                        <%= item.get("description") %>
                        <div class="details">
                            <div><strong>Time:</strong> <%= item.get("start_time") + "-" + item.get("end_time") %></div>
                        </div>
                    </div>
                <% } else { %>
                    <div class="period">
                        <div class="period-content">
                            <div class="subject"><%= item.get("subject") %></div>
                            <div class="details">
                                <div><strong>Teacher:</strong> <%= item.get("teacher") %></div>
                                <div><strong>Time:</strong> <%= item.get("start_time") + "-" + item.get("end_time") %></div>
                            </div>
                        </div>
                        <img src="<%= item.get("icon") %>" alt="<%= item.get("subject") %>" 
                             onload="console.log('Icon loaded: <%= item.get("icon") %>')"
                             onerror="this.src='S/images/default.png'; console.error('Icon failed: <%= item.get("icon") %>')">
                    </div>
                <% } %>
            <% } %>
            <div class="break">Dismiss | 02:00 PM</div>
        </div>

        <div id="tuesday" class="day-content">
            <% for (Map<String, Object> item : timetable.getOrDefault("Tuesday", new ArrayList<>())) { %>
                <% if ("break".equals(item.get("type"))) { %>
                    <div class="break">
                        <%= item.get("description") %>
                        <div class="details">
                            <div><strong>Time:</strong> <%= item.get("start_time") + "-" + item.get("end_time") %></div>
                        </div>
                    </div>
                <% } else { %>
                    <div class="period">
                        <div class="period-content">
                            <div class="subject"><%= item.get("subject") %></div>
                            <div class="details">
                                <div><strong>Teacher:</strong> <%= item.get("teacher") %></div>
                                <div><strong>Time:</strong> <%= item.get("start_time") + "-" + item.get("end_time") %></div>
                            </div>
                        </div>
                        <img src="<%= item.get("icon") %>" alt="<%= item.get("subject") %>" 
                             onload="console.log('Icon loaded: <%= item.get("icon") %>')"
                             onerror="this.src='S/images/default.png'; console.error('Icon failed: <%= item.get("icon") %>')">
                    </div>
                <% } %>
            <% } %>
            <div class="break">Dismiss | 02:00 PM</div>
        </div>

        <div id="wednesday" class="day-content">
            <% for (Map<String, Object> item : timetable.getOrDefault("Wednesday", new ArrayList<>())) { %>
                <% if ("break".equals(item.get("type"))) { %>
                    <div class="break">
                        <%= item.get("description") %>
                        <div class="details">
                            <div><strong>Time:</strong> <%= item.get("start_time") + "-" + item.get("end_time") %></div>
                        </div>
                    </div>
                <% } else { %>
                    <div class="period">
                        <div class="period-content">
                            <div class="subject"><%= item.get("subject") %></div>
                            <div class="details">
                                <div><strong>Teacher:</strong> <%= item.get("teacher") %></div>
                                <div><strong>Time:</strong> <%= item.get("start_time") + "-" + item.get("end_time") %></div>
                            </div>
                        </div>
                        <img src="<%= item.get("icon") %>" alt="<%= item.get("subject") %>" 
                             onload="console.log('Icon loaded: <%= item.get("icon") %>')"
                             onerror="this.src='S/images/default.png'; console.error('Icon failed: <%= item.get("icon") %>')">
                    </div>
                <% } %>
            <% } %>
            <div class="break">Dismiss | 02:00 PM</div>
        </div>

        <div id="thursday" class="day-content">
            <% for (Map<String, Object> item : timetable.getOrDefault("Thursday", new ArrayList<>())) { %>
                <% if ("break".equals(item.get("type"))) { %>
                    <div class="break">
                        <%= item.get("description") %>
                        <div class="details">
                            <div><strong>Time:</strong> <%= item.get("start_time") + "-" + item.get("end_time") %></div>
                        </div>
                    </div>
                <% } else { %>
                    <div class="period">
                        <div class="period-content">
                            <div class="subject"><%= item.get("subject") %></div>
                            <div class="details">
                                <div><strong>Teacher:</strong> <%= item.get("teacher") %></div>
                                <div><strong>Time:</strong> <%= item.get("start_time") + "-" + item.get("end_time") %></div>
                            </div>
                        </div>
                        <img src="<%= item.get("icon") %>" alt="<%= item.get("subject") %>" 
                             onload="console.log('Icon loaded: <%= item.get("icon") %>')"
                             onerror="this.src='S/images/default.png'; console.error('Icon failed: <%= item.get("icon") %>')">
                    </div>
                <% } %>
            <% } %>
            <div class="break">Dismiss | 02:00 PM</div>
        </div>

        <div id="friday" class="day-content">
            <% for (Map<String, Object> item : timetable.getOrDefault("Friday", new ArrayList<>())) { %>
                <% if ("break".equals(item.get("type"))) { %>
                    <div class="break">
                        <%= item.get("description") %>
                        <div class="details">
                            <div><strong>Time:</strong> <%= item.get("start_time") + "-" + item.get("end_time") %></div>
                        </div>
                    </div>
                <% } else { %>
                    <div class="period">
                        <div class="period-content">
                            <div class="subject"><%= item.get("subject") %></div>
                            <div class="details">
                                <div><strong>Teacher:</strong> <%= item.get("teacher") %></div>
                                <div><strong>Time:</strong> <%= item.get("start_time") + "-" + item.get("end_time") %></div>
                            </div>
                        </div>
                        <img src="<%= item.get("icon") %>" alt="<%= item.get("subject") %>" 
                             onload="console.log('Icon loaded: <%= item.get("icon") %>')"
                             onerror="this.src='S/images/default.png'; console.error('Icon failed: <%= item.get("icon") %>')">
                    </div>
                <% } %>
            <% } %>
            <div class="break">Dismiss | 02:00 PM</div>
        </div>
    </div>
    <img src="images/time_teacher.png" alt="Bottom Right Image" class="bottom-right-img"
         onload="console.log('Teacher image loaded: images/time_teacher.png')"
         onerror="console.error('Teacher image failed: images/time_teacher.png')">
</body>

<script>
    function showDay(dayId) {
        const tabs = document.querySelectorAll('.tab');
        const contents = document.querySelectorAll('.day-content');

        tabs.forEach(tab => tab.classList.remove('active'));
        contents.forEach(content => content.classList.remove('active'));

        document.querySelector(`.tab[onclick="showDay('${dayId}')"]`).classList.add('active');
        document.getElementById(dayId).classList.add('active');
    }
</script>