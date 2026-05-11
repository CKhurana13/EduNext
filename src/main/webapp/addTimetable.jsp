<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, java.util.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Class Timetable</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins&display=swap" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        :root {
            --primary-pink: #ffccd5;
            --secondary-pink: #ffb3c1;
            --light-purple: #b388eb;
            --dark-purple: #8a56d6;
            --darker-purple: #5e3a9b;
            --white: #ffffff;
            --light-bg: #f0f4f8;
            --text-dark: #333333;
            --text-light: #f0f0f0;
        }

        body {
            background-color: var(--light-bg);
            background: repeating-linear-gradient(45deg, var(--primary-pink) 0, var(--primary-pink) 10px, var(--secondary-pink) 10px, var(--secondary-pink) 20px),
                        repeating-linear-gradient(-45deg, var(--primary-pink) 0, var(--primary-pink) 10px, var(--secondary-pink) 10px, var(--secondary-pink) 20px);
            background-blend-mode: overlay;
            font-family: 'Poppins', sans-serif;
            position: relative;
            margin: 0;
            padding-bottom: 50px;
        }
        .logo {
            position: absolute;
            top: 20px;
            left: 20px;
            width: 100px;
            height: auto;
            z-index: 1000;
        }
        .form-container {
            background-color: rgba(255, 255, 255, 0.9);
            border-radius: 20px;
            padding: 40px;
            margin-top: 100px;
            margin-bottom: 50px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            width: 700px;
            margin-left: auto;
            margin-right: auto;
            text-align: center;
            animation: fadeIn 1s ease-in-out;
        }
        h2 {
            color: var(--darker-purple);
            font-weight: bold;
        }
        .form-box {
            background: rgba(230, 240, 255, 0.9);
            padding: 25px;
            border-radius: 12px;
        }
        label {
            font-weight: bold;
            color: var(--dark-purple);
            display: block;
            margin-top: 15px;
            margin-bottom: 5px;
            font-size: 16px;
        }
        select, input[type="text"], input[type="hidden"] {
            width: 100%;
            padding: 10px;
            margin-bottom: 20px;
            border: 2px solid #cce0ff;
            border-radius: 8px;
            font-size: 14px;
            background-color: #f2f7ff;
            box-sizing: border-box;
        }
        select:focus, input[type="text"]:focus {
            outline: none;
            border-color: var(--light-purple);
            background-color: #e6f0ff;
            box-shadow: 0 0 5px 2px #9ab3f5;
        }
        .submit-btn {
            background-color: var(--dark-purple);
            border-color: var(--dark-purple);
            border-radius: 50px;
            padding: 10px 20px;
            font-size: 16px;
            font-weight: 600;
            color: var(--white);
            width: 100%;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }
        .submit-btn:hover {
            background-color: var(--secondary-pink);
        }
        .btn-back {
            background-color: var(--light-purple);
            border-color: var(--light-purple);
            border-radius: 50px;
            padding: 10px 20px;
            font-size: 16px;
            font-weight: 600;
            color: var(--white);
            text-decoration: none;
            display: inline-block;
            margin-top: 10px;
        }
        .btn-back:hover {
            background-color: var(--secondary-pink);
        }
        .error {
            color: red;
            margin-bottom: 10px;
            font-size: 14px;
        }
        .success-msg {
            color: green;
            margin-bottom: 10px;
            font-size: 14px;
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>
<body>
    <img src="images/logo.png" alt="School Logo" class="logo">

    <div class="form-container">
        <h2 class="mb-4">📅 Add Class Timetable</h2>
        <% 
            String class_name = request.getParameter("class_name");
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            if (class_name != null && !class_name.isEmpty()) {
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/teacher_web", "root", "vips");
                    pstmt = conn.prepareStatement("SELECT classes FROM subjects WHERE classes = ?");
                    pstmt.setString(1, class_name);
                    rs = pstmt.executeQuery();
                    if (!rs.next()) {
                        out.println("<p class='error'>Class not found.</p>");
                        class_name = "";
                    }
                    rs.close();
                    pstmt.close();
                } catch (Exception e) {
                    out.println("<p class='error'>Error fetching class: " + e.getMessage() + "</p>");
                    class_name = "";
                }
            } else {
                out.println("<p class='error'>No class selected. Please select a class from the timetable page.</p>");
                class_name = "";
            }
        %>
        <% if ("error".equals(request.getParameter("status"))) { %>
            <p class="error">Error adding timetable. Please try again.</p>
            <% String message = request.getParameter("message");
               if (message != null && !message.isEmpty()) { %>
                <p class="error"><%= message %></p>
            <% } %>
        <% } else if ("success".equals(request.getParameter("status"))) { %>
            <p class="success-msg">Timetable entry added successfully!</p>
        <% } %>

        <div class="form-box">
            <form action="AddTimetableServlet" method="post">
                <input type="hidden" name="class_name" value="<%= class_name %>">
                <label for="class_name_display">Class:</label>
                <input type="text" id="class_name_display" value="<%= class_name %>" readonly>

                <label for="day">Day:</label>
                <select name="day" id="day" required>
                    <option value="">Select Day</option>
                    <option value="monday">Monday</option>
                    <option value="tuesday">Tuesday</option>
                    <option value="wednesday">Wednesday</option>
                    <option value="thursday">Thursday</option>
                    <option value="friday">Friday</option>
                </select>

                <label for="sub_id">Subject:</label>
                <select name="sub_id" id="sub_id" required>
                    <option value="">Select Subject</option>
                    <!-- Populated dynamically via AJAX -->
                </select>

                <label for="t_id">Teacher:</label>
                <select name="t_id" id="t_id" required>
                    <option value="">Select Teacher</option>
                    <!-- Populated dynamically via AJAX -->
                </select>

                <label for="period_no">Period:</label>
                <select name="period_no" id="period_no" required>
                    <option value="">Select Period</option>
                    <!-- Populated dynamically via AJAX -->
                </select>

                <button type="submit" class="submit-btn">Add Timetable Entry</button>
            </form>
        </div>
        <div class="text-center">
            <a href="adminTimetable.jsp?class_name=<%= java.net.URLEncoder.encode(class_name, "UTF-8") %>" class="btn btn-back">Back to Timetable</a>
            <a href="classSection.jsp" class="btn btn-back">Back to Class Section</a>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Update subjects based on class selection
        document.getElementById('class_name_display').addEventListener('change', function() {
            var className = '<%= class_name %>';
            var subSelect = document.getElementById('sub_id');
            subSelect.innerHTML = '<option value="">Select Subject</option>';

            if (className) {
                $.ajax({
                    url: 'GetSubjectsForClassServlet',
                    type: 'GET',
                    data: { className: className },
                    dataType: 'json',
                    success: function(data) {
                        data.forEach(function(subject) {
                            var option = document.createElement('option');
                            option.value = subject.sub_id;
                            option.text = subject.sub_name + ' (' + subject.classes + ')';
                            subSelect.appendChild(option);
                        });
                    },
                    error: function(xhr, status, error) {
                        console.error('Error fetching subjects:', error);
                        subSelect.innerHTML = '<option value="">Error loading subjects</option>';
                    }
                });
            }
            updateTeachers();
            updatePeriods();
        });

        // Update teachers based on subject selection
        document.getElementById('sub_id').addEventListener('change', updateTeachers);

        function updateTeachers() {
            var className = '<%= class_name %>';
            var subId = document.getElementById('sub_id').value;
            var teacherSelect = document.getElementById('t_id');
            teacherSelect.innerHTML = '<option value="">Select Teacher</option>';

            if (className && subId) {
                $.ajax({
                    url: 'GetTeachersForSubjectServlet',
                    type: 'GET',
                    data: { className: className, sub_id: subId },
                    dataType: 'json',
                    success: function(data) {
                        data.forEach(function(teacher) {
                            var option = document.createElement('option');
                            option.value = teacher.t_id;
                            option.text = teacher.t_name + ' (' + teacher.t_id + ')';
                            teacherSelect.appendChild(option);
                        });
                    },
                    error: function(xhr, status, error) {
                        console.error('Error fetching teachers:', error);
                        teacherSelect.innerHTML = '<option value="">Error loading teachers</option>';
                    }
                });
            }
            updatePeriods();
        }

        // Update periods based on class and day selection
        document.getElementById('day').addEventListener('change', updatePeriods);

        function updatePeriods() {
            var className = '<%= class_name %>';
            var day = document.getElementById('day').value;
            var periodSelect = document.getElementById('period_no');
            periodSelect.innerHTML = '<option value="">Select Period</option>';

            if (className && day) {
                $.ajax({
                    url: 'GetAvailablePeriodsServlet',
                    type: 'GET',
                    data: { className: className, day: day },
                    dataType: 'json',
                    success: function(data) {
                        data.forEach(function(period) {
                            var option = document.createElement('option');
                            option.value = period.period_no;
                            option.text = `Period ${period.period_no} (${period.start_time} - ${period.end_time})`;
                            periodSelect.appendChild(option);
                        });
                    },
                    error: function(xhr, status, error) {
                        console.error('Error fetching periods:', error);
                        periodSelect.innerHTML = '<option value="">Error loading periods</option>';
                    }
                });
            }
        }

        // Trigger subject population on page load
        document.getElementById('class_name_display').dispatchEvent(new Event('change'));
    </script>
</body>
</html>