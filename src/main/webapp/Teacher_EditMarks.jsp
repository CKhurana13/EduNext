
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>

<%
    String s_id = (String) request.getAttribute("s_id");
    String class_name = (String) request.getAttribute("class_name");
    String subject = (String) request.getAttribute("subject");

    Map<String, Object> student = (Map<String, Object>) request.getAttribute("student");
    List<String> examCodes = (List<String>) request.getAttribute("examCodes");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Marks</title>
        
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
    <style>
    @charset "UTF-8";

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
	margin: 0;
	font-family: 'Lato', sans-serif;
	background-color: var(--light-bg);
	background: repeating-linear-gradient(45deg, #e0e7ff 0, #e0e7ff 10px, #d1e0ff 10px,
		#d1e0ff 20px),
		repeating-linear-gradient(-45deg, #e0e7ff 0, #e0e7ff 10px, #d1e0ff 10px,
		#d1e0ff 20px);
	background-blend-mode: overlay;
	min-height: 100vh;
}

/* HEADER */
.header {
	background: linear-gradient(to right, var(--primary-blue),
		var(--secondary-blue));
	color: var(--white);
	box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
	display: flex;
	justify-content: space-between;
	align-items: center;
	padding: 10px 25px;
	position: relative;
	z-index: 1;
}

.header-logo {
	height: 35px;
	max-width: 100px;
	border-radius: 5px;
	object-fit: contain;
	margin-right: 15px;
	transition: transform 0.3s ease;
}

.header-left {
	display: flex;
	align-items: center;
}

.profile-dropdown {
	position: relative;
	display: inline-block;
	cursor: pointer;
}

.profile-circle {
	width: 40px;
	height: 40px;
	background-color: var(--primary-blue);
	color: var(--text-light);
	border-radius: 50%;
	display: flex;
	align-items: center;
	justify-content: center;
	font-size: 18px;
	margin-right: 5px;
	float: left;
	transition: all 0.3s ease;
}

.profile-circle:hover {
	background-color: var(--secondary-blue);
	box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
}

.profile-name {
	color: var(--white);
	display: inline-block;
	vertical-align: middle;
	font-weight: 600;
	margin-left: 8px;
}

.dropdown-content {
	display: none;
	position: absolute;
	top: 100%;
	right: 0;
	background-color: rgba(255, 255, 255, 0.95);
	min-width: 160px;
	box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1);
	z-index: 999;
	border-radius: 4px;
	backdrop-filter: blur(4px);
}

.profile-dropdown:hover .dropdown-content {
	display: block;
}

.dropdown-content a {
	display: block;
	padding: 12px 16px;
	text-decoration: none;
	color: var(--text-dark);
	transition: all 0.3s ease;
}

.dropdown-content a:hover {
	background-color: var(--light-purple);
	color: var(--text-light);
}


.container {
    max-width: 1100px;
    margin: 40px auto;
    background: white;
    padding: 30px;
    border-radius: 15px;
    box-shadow: 0 6px 18px rgba(0, 0, 0, 0.1);
}

h2 {
    text-align: center;
    color: var(--primary-blue);
    margin-bottom: 30px;
}

form {
    text-align: center;
    margin-bottom: 30px;
}

label {
    font-weight: bold;
    margin-right: 10px;
    color: var(--primary-blue);
}

select {
    padding: 8px 12px;
    margin-right: 15px;
    border-radius: 6px;
    border: 1px solid #ccc;
    font-size: 14px;
}

button {
    padding: 10px 20px;
    background-color: var(--primary-blue);
    color: white;
    border: none;
    border-radius: 6px;
    font-weight: bold;
    cursor: pointer;
    transition: background-color 0.3s ease;
}


button:hover {
    background-color: var(--dark-purple);
}

.table-container {
    overflow-x: auto;
}

.styled-table {
    width: 100%;
    border-collapse: collapse;
    font-size: 14px;
    text-align: center;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
}

.styled-table th,
.styled-table td {
    padding: 12px;
    border-bottom: 1px solid #ddd;
}

.styled-table thead {
    background-color: var(--primary-blue);
    color: white;
}

.styled-table tr:nth-child(even) {
    background-color: #f9f9f9;
}

.styled-table tr:hover {
    background: linear-gradient(to right, var(--light-purple), var(--dark-purple));
    color: white;
}

.no-data {
    text-align: center;
    font-size: 16px;
    color: #999;
    margin-top: 30px;
}
    </style>
</head>
<body class="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-50 p-6">
<img src="images/logo.png" alt="School Logo" class="logo">

    <div class="max-w-2xl mx-auto bg-blue-50 shadow-xl rounded-2xl p-8">
        <h1 class="text-2xl font-semibold text-gray-800 mb-6">Update Marks for Student ID: <span class="text-blue-600 font-bold"><%= s_id %></span></h1>

        <% if (student != null && examCodes != null) { %>
            <form method="post" action="Teacher_EditMarksServlet" class="space-y-6">
                <input type="hidden" name="s_id" value="<%= s_id %>">
                <input type="hidden" name="class_name" value="<%= class_name %>">
                <input type="hidden" name="subject" value="<%= subject %>">

                <% for (String exam : examCodes) { 
                    Object value = student.get(exam);
                    String mark = value != null ? value.toString() : "";
                %>
                    <div>
                        <label class="block text-sm font-medium text-indigo-700 mb-1"><%= exam %>:</label>
                        <input type="number" name="<%= exam %>" value="<%= mark %>"
                            class="w-full px-4 py-2 rounded-lg border border-gray-300 focus:ring-2 focus:ring-indigo-400 focus:outline-none">
                    </div>
                <% } %>

                <div>
                    <button type="submit"
                            class="w-full bg-indigo-500 text-white font-semibold py-2 px-4 rounded-lg hover:bg-indigo-600 transition">
                        Save
                    </button>
                </div>
            </form>
        <% } else { %>
            <div class="text-red-600 font-medium">
                ⚠ Unable to load student marks. Please try again.
            </div>
        <% } %>
    </div>
</body>
</html>