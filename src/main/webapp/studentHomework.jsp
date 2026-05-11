<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*, java.text.SimpleDateFormat, java.util.Enumeration"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Homework</title>
<style>
@import url('https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap');

:root {
	--primary-blue: #6b8cff;
	--secondary-blue: #4d6cfa;
	--light-purple: #b388eb;
	--dark-purple: #8a56d6;
	--darker-purple: #5e3a9b;
	--white: #ffffff;
	--light-bg: #f0f4f8;
	--text-dark: #333333;
	--text-light: #f0f0f0;
}

body {
	font-family: 'Poppins', sans-serif;
	margin: 0;
	padding: 20px;
	background-color: var(--light-bg);
	display: flex;
	justify-content: center;
	align-items: flex-start;
	min-height: 100vh;
	position: relative;
	background: repeating-linear-gradient(45deg, #e0e7ff 0, #e0e7ff 10px, #d1e0ff 10px,
		#d1e0ff 20px),
		repeating-linear-gradient(-45deg, #e0e7ff 0, #e0e7ff 10px, #d1e0ff 10px,
		#d1e0ff 20px);
	background-blend-mode: overlay;
}

.logo {
	width: 120px;
	height: auto;
	position: absolute;
	top: 20px;
	left: 20px;
}

.container {
	max-width: 900px;
	width: 100%;
	background-color: var(--white);
	border-radius: 20px;
	box-shadow: 0 10px 30px rgba(107, 140, 255, 0.2);
	padding: 30px;
	margin-top: 60px;
	position: relative;
	z-index: 1;
}

.header {
	display: flex;
	align-items: center;
	margin-bottom: 20px;
}

.back-arrow {
	font-size: 28px;
	font-weight: 500;
	cursor: pointer;
	margin-right: 10px;
	color: var(--dark-purple);
	line-height: 1;
}

.header-title {
	background-color: var(--secondary-blue);
	color: var(--white);
	padding: 10px 20px;
	border-radius: 10px;
	font-size: 24px;
	font-weight: bold;
	flex-grow: 1;
	text-align: center;
	margin: 0 10px;
}

.tabs {
	display: flex;
	margin-bottom: 20px;
	background-color: #d1e0ff;
	border-radius: 10px;
	overflow: hidden;
}

.tab {
	flex: 1;
	padding: 10px;
	text-align: center;
	cursor: pointer;
	transition: background-color 0.3s;
}

.tab.active {
	background-color: var(--primary-blue);
	color: var(--white);
}

.date-wise, .subject-wise, .done-homework {
	display: none;
}

.date-wise.active, .subject-wise.active, .done-homework.active {
	display: block;
}

.task {
	display: flex;
	justify-content: space-between;
	align-items: center;
	background-color: var(--secondary-blue);
	color: var(--white);
	padding: 15px;
	margin-bottom: 10px;
	border-radius: 10px;
}

.task .details {
	display: flex;
	align-items: center;
}

.task .details img {
	width: 40px;
	height: 40px;
	margin-right: 10px;
	object-fit: cover;
}

.task .details div {
	line-height: 1.2;
}

.task .due-date {
	font-weight: bold;
}

.task .mark-done {
	background-color: var(--light-purple);
	padding: 5px 10px;
	border: none;
	border-radius: 5px;
	color: var(--white);
	cursor: pointer;
}

.subject-tab {
	margin-bottom: 10px;
}

.subject-tab summary {
	background-color: var(--primary-blue);
	color: var(--white);
	padding: 10px;
	border-radius: 5px;
	cursor: pointer;
	font-weight: bold;
	list-style: none;
	display: flex;
	align-items: center;
}

.subject-tab summary::-webkit-details-marker {
	display: none;
}

.subject-tab .task-container {
	padding: 10px;
}

.subject-tab[open] .task-container {
	display: block;
}

.student-avatar {
	position: fixed;
	bottom: 10px;
	right: 10px;
	width: 250px;
	height: auto;
	z-index: 999;
}

.preload-images {
	display: none;
}
</style>
</head>
<body>
	<img src="images/logo.png" alt="EduNext Logo" class="logo" onload="console.log('Logo loaded: images/logo.png')" onerror="console.error('Logo failed to load: images/logo.png')">
	<div class="preload-images">
		<img src="images/logo.png">
		<img src="images/stu.png">
		<img src="S/images/default.png">
	</div>
	<div class="container">
		<div class="header">
			<span class="back-arrow" onclick="window.location.href='dashboard.jsp'">←</span>
			<div class="header-title">HOMEWORK</div>
		</div>
		<div class="tabs">
			<div class="tab active" onclick="showTab('date-wise')">DATE WISE</div>
			<div class="tab" onclick="showTab('subject-wise')">SUBJECT WISE</div>
			<div class="tab" onclick="showTab('done-homework')">DONE HOMEWORK</div>
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

			// Date formatters
			SimpleDateFormat dateFormat = new SimpleDateFormat("dd-MM-yyyy");
			SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm:ss");
		%>
		<% 
			// Display success/error messages from servlet
			String message = request.getParameter("message");
			if (message != null) {
				String color = message.startsWith("Error") ? "red" : "green";
				out.println("<div style='color: " + color + "; text-align: center; margin-bottom: 10px;'>" + message + "</div>");
			}
		%>
		<div class="date-wise active">
			<%
				try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/teacher_web?useSSL=false", "root", "vips")) {
					String dueDateQuery = "SELECT DISTINCT due_date FROM homework WHERE className = ? AND hw_id NOT IN " +
										 "(SELECT hw_id FROM homework_status WHERE s_id = ?) ORDER BY due_date";
					try (PreparedStatement psDate = con.prepareStatement(dueDateQuery)) {
						psDate.setString(1, class_name);
						psDate.setString(2, s_id);
						try (ResultSet rsDate = psDate.executeQuery()) {
							if (!rsDate.isBeforeFirst()) {
								out.println("<p>No pending homework found for Class " + class_name + "</p>");
								out.println("<script>console.log('No due dates found for class_name=" + class_name + "');</script>");
							}
							while (rsDate.next()) {
								java.sql.Date dueDate = rsDate.getDate("due_date");
								String formattedDueDate = dueDate != null ? dateFormat.format(dueDate) : "N/A";
								String taskQuery = "SELECT h.hw_id, s.sub_name AS subject, h.chapter, h.description, s.icon_path " +
												  "FROM homework h JOIN subjects s ON h.sub_id = s.sub_id " +
												  "WHERE h.className = ? AND h.due_date = ? AND h.hw_id NOT IN " +
												  "(SELECT hw_id FROM homework_status WHERE s_id = ?)";
								try (PreparedStatement psTask = con.prepareStatement(taskQuery, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY)) {
									psTask.setString(1, class_name);
									psTask.setDate(2, dueDate);
									psTask.setString(3, s_id);
									try (ResultSet rsTask = psTask.executeQuery()) {
										int taskCount = 0;
										while (rsTask.next()) {
											taskCount++;
										}
										if (taskCount > 0) {
											out.println("<h2>Due Date: " + formattedDueDate + "</h2>");
											rsTask.beforeFirst();
											while (rsTask.next()) {
												int hwId = rsTask.getInt("hw_id");
												String subject = rsTask.getString("subject");
												String chapter = rsTask.getString("chapter");
												String description = rsTask.getString("description");
												String iconPath = rsTask.getString("icon_path") != null ? rsTask.getString("icon_path") : "S/images/default.png";
			%>
			<div class="task">
				<div class="details">
					<img src="<%= iconPath %>" alt="<%= subject %> Icon" 
						 onload="console.log('Subject icon loaded: <%= iconPath %>')" 
						 onerror="this.src='S/images/default.png'; console.error('Subject icon failed: <%= iconPath %>')">
					<div>
						<div><strong>Class:</strong> <%= class_name %></div>
						<div><strong>Chapter:</strong> <%= chapter != null ? chapter : "N/A" %></div>
						<div><%= description != null ? description : "No description" %></div>
					</div>
				</div>
				<div class="due-date">
					Due: <%= formattedDueDate %><br>
					<form action="MarkHomeworkDoneServlet" method="post">
						<input type="hidden" name="hw_id" value="<%= hwId %>">
						<input type="hidden" name="s_id" value="<%= s_id %>">
						<button type="submit" class="mark-done">Mark Done</button>
					</form>
				</div>
			</div>
			<%
											}
											out.println("<script>console.log('Found " + taskCount + " tasks for due date " + formattedDueDate + "');</script>");
										}
									}
								}
							}
						}
					}
				} catch (Exception e) {
					out.println("<div style='color: red;'>Error: " + e.getMessage() + "</div>");
					out.println("<script>console.error('Database error: " + e.getMessage() + "');</script>");
					e.printStackTrace();
				}
			%>
		</div>
		<div class="subject-wise">
			<%
				try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/teacher_web?useSSL=false", "root", "vips")) {
					String subjectQuery = "SELECT DISTINCT s.sub_name, s.icon_path " +
										 "FROM homework h JOIN subjects s ON h.sub_id = s.sub_id " +
										 "WHERE h.className = ? AND h.hw_id NOT IN " +
										 "(SELECT hw_id FROM homework_status WHERE s_id = ?) " +
										 "ORDER BY s.sub_name";
					try (PreparedStatement psSubject = con.prepareStatement(subjectQuery)) {
						psSubject.setString(1, class_name);
						psSubject.setString(2, s_id);
						try (ResultSet rsSubject = psSubject.executeQuery()) {
							if (!rsSubject.isBeforeFirst()) {
								out.println("<p>No pending homework found for Class " + class_name + "</p>");
								out.println("<script>console.log('No subjects found for class_name=" + class_name + "');</script>");
							}
							while (rsSubject.next()) {
								String subjectName = rsSubject.getString("sub_name");
								String iconPath = rsSubject.getString("icon_path") != null ? rsSubject.getString("icon_path") : "S/images/default.png";
			%>
			<details class="subject-tab">
				<summary>
					<img src="<%= iconPath %>" alt="<%= subjectName %> Icon"
						 style="width: 30px; height: 30px; margin-right: 10px;"
						 onload="console.log('Summary icon loaded: <%= iconPath %>')"
						 onerror="this.src='S/images/default.png'; console.error('Summary icon failed: <%= iconPath %>')">
					<%= subjectName %>
				</summary>
				<div class="task-container">
					<%
						String taskQuery = "SELECT h.hw_id, h.chapter, h.description, h.due_date " +
										  "FROM homework h JOIN subjects s ON h.sub_id = s.sub_id " +
										  "WHERE h.className = ? AND s.sub_name = ? AND h.hw_id NOT IN " +
										  "(SELECT hw_id FROM homework_status WHERE s_id = ?)";
						try (PreparedStatement psTask = con.prepareStatement(taskQuery)) {
							psTask.setString(1, class_name);
							psTask.setString(2, subjectName);
							psTask.setString(3, s_id);
							try (ResultSet rsTask = psTask.executeQuery()) {
								int taskCount = 0;
								while (rsTask.next()) {
									taskCount++;
									int hwId = rsTask.getInt("hw_id");
									String chapter = rsTask.getString("chapter");
									String description = rsTask.getString("description");
									java.sql.Date dueDate = rsTask.getDate("due_date");
									String formattedDueDate = dueDate != null ? dateFormat.format(dueDate) : "N/A";
					%>
					<div class="task">
						<div class="details">
							<img src="<%= iconPath %>" alt="<%= subjectName %> Icon"
								 onload="console.log('Task icon loaded: <%= iconPath %>')"
								 onerror="this.src='S/images/default.png'; console.error('Task icon failed: <%= iconPath %>')">
							<div>
								<div><strong>Class:</strong> <%= class_name %></div>
								<div><strong>Chapter:</strong> <%= chapter != null ? chapter : "N/A" %></div>
								<div><%= description != null ? description : "No description" %></div>
							</div>
						</div>
						<div class="due-date">
							Due: <%= formattedDueDate %><br>
							<form action="MarkHomeworkDoneServlet" method="post">
								<input type="hidden" name="hw_id" value="<%= hwId %>">
								<input type="hidden" name="s_id" value="<%= s_id %>">
								<button type="submit" class="mark-done">Mark Done</button>
							</form>
						</div>
					</div>
					<%
								}
								out.println("<script>console.log('Found " + taskCount + " tasks for subject " + subjectName + "');</script>");
							}
						}
					%>
				</div>
			</details>
			<%
							}
						}
					}
				} catch (Exception e) {
					out.println("<div style='color: red;'>Error: " + e.getMessage() + "</div>");
					out.println("<script>console.error('Database error: " + e.getMessage() + "');</script>");
					e.printStackTrace();
				}
			%>
		</div>
		<div class="done-homework">
			<%
				try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/teacher_web?useSSL=false", "root", "vips")) {
					String doneDateQuery = "SELECT DISTINCT h.due_date " +
										  "FROM homework h JOIN homework_status hs ON h.hw_id = hs.hw_id " +
										  "WHERE hs.s_id = ? AND h.className = ? ORDER BY h.due_date";
					try (PreparedStatement psDate = con.prepareStatement(doneDateQuery)) {
						psDate.setString(1, s_id);
						psDate.setString(2, class_name);
						try (ResultSet rsDate = psDate.executeQuery()) {
							if (!rsDate.isBeforeFirst()) {
								out.println("<p>No completed homework found for Class " + class_name + "</p>");
								out.println("<script>console.log('No completed homework found for class_name=" + class_name + "');</script>");
							}
							while (rsDate.next()) {
								java.sql.Date dueDate = rsDate.getDate("due_date");
								String formattedDueDate = dueDate != null ? dateFormat.format(dueDate) : "N/A";
								out.println("<h2>Due Date: " + formattedDueDate + "</h2>");
								String taskQuery = "SELECT h.hw_id, s.sub_name AS subject, h.chapter, h.description, s.icon_path, hs.completed_date " +
												  "FROM homework h JOIN subjects s ON h.sub_id = s.sub_id " +
												  "JOIN homework_status hs ON h.hw_id = hs.hw_id " +
												  "WHERE h.className = ? AND h.due_date = ? AND hs.s_id = ?";
								try (PreparedStatement psTask = con.prepareStatement(taskQuery)) {
									psTask.setString(1, class_name);
									psTask.setDate(2, dueDate);
									psTask.setString(3, s_id);
									try (ResultSet rsTask = psTask.executeQuery()) {
										int taskCount = 0;
										while (rsTask.next()) {
											taskCount++;
											int hwId = rsTask.getInt("hw_id");
											String subject = rsTask.getString("subject");
											String chapter = rsTask.getString("chapter");
											String description = rsTask.getString("description");
											java.sql.Timestamp completedDate = rsTask.getTimestamp("completed_date");
											String formattedCompletedDate = completedDate != null ? dateFormat.format(completedDate) : "N/A";
											String formattedCompletedTime = completedDate != null ? timeFormat.format(completedDate) : "N/A";
											String iconPath = rsTask.getString("icon_path") != null ? rsTask.getString("icon_path") : "S/images/default.png";
			%>
			<div class="task">
				<div class="details">
					<img src="<%= iconPath %>" alt="<%= subject %> Icon" 
						 onload="console.log('Done task icon loaded: <%= iconPath %>')" 
						 onerror="this.src='S/images/default.png'; console.error('Done task icon failed: <%= iconPath %>')">
					<div>
						<div><strong>Class:</strong> <%= class_name %></div>
						<div><strong>Chapter:</strong> <%= chapter != null ? chapter : "N/A" %></div>
						<div><%= description != null ? description : "No description" %></div>
						<div><strong>Due Date:</strong> <%= formattedDueDate %></div>
					</div>
				</div>
				<div class="due-date">
					Completed On: <%= formattedCompletedDate %><br>
					Time: <%= formattedCompletedTime %>
				</div>
			</div>
			<%
										}
										out.println("<script>console.log('Found " + taskCount + " completed tasks for due date " + formattedDueDate + "');</script>");
									}
								}
							}
						}
					}
				} catch (Exception e) {
					out.println("<div style='color: red;'>Error: " + e.getMessage() + "</div>");
					out.println("<script>console.error('Database error in done-homework: " + e.getMessage() + "');</script>");
					e.printStackTrace();
				}
			%>
		</div>
	</div>
	<img src="images/stu.png" alt="Student Image" class="student-avatar"
		 onload="console.log('Student avatar loaded: images/stu.png')"
		 onerror="console.error('Student avatar failed: images/stu.png')">
	<script>
		function showTab(tab) {
			const dateWise = document.querySelector('.date-wise');
			const subjectWise = document.querySelector('.subject-wise');
			const doneHomework = document.querySelector('.done-homework');
			const tabs = document.querySelectorAll('.tab');
			tabs.forEach(t => t.classList.remove('active'));
			dateWise.classList.remove('active');
			subjectWise.classList.remove('active');
			doneHomework.classList.remove('active');
			document.querySelector(`.${tab}`).classList.add('active');
			document.querySelector(`[onclick="showTab('${tab}')"]`).classList.add('active');
			if (tab === 'date-wise' || tab === 'done-homework') {
				document.querySelectorAll('.subject-tab[open]').forEach(dropdown => {
					dropdown.removeAttribute('open');
				});
			}
		}
	</script>
</body>
</html>