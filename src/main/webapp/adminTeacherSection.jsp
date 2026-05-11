
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Teacher Section</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
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
            --gradient-enter: linear-gradient(135deg, #a7e6d7, #c1f0e5);
            --gradient-view: linear-gradient(135deg, #f5d0e6, #fce2f1);
            --gradient-edit: linear-gradient(135deg, #b9d8f5, #d1e9ff);
            --gradient-timetable: linear-gradient(135deg, #ffd6a5, #ffe8cc);
        }

        body {
            font-family: 'Poppins', sans-serif;
            margin: 0;
            padding: 10px;
            background-color: var(--light-bg);
            background: repeating-linear-gradient(45deg, #e0e7ff 0, #e0e7ff 10px, #d1e0ff 10px, #d1e0ff 20px),
                        repeating-linear-gradient(-45deg, #e0e7ff 0, #e0e7ff 10px, #d1e0ff 10px, #d1e0ff 20px);
            background-blend-mode: overlay;
            min-height: 100vh;
            position: relative;
            overflow-x: hidden;
        }
        .logo {
            position: fixed;
            top: 20px;
            left: 20px;
            width: 100px;
            height: auto;
            z-index: 1000;
        }
        .main-container {
            background-color: rgba(255, 255, 255, 0.9);
            border-radius: 20px;
            padding: 30px;
            margin-top: 80px;
            margin-bottom: 50px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            max-width: 900px;
            margin-left: auto;
            margin-right: auto;
            text-align: center;
        }
        h1 {
            font-size: 3em;
            font-weight: bold;
            color: var(--darker-purple);
        }
        .option-card {
            border-radius: 25px;
            box-shadow: 0 6px 15px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s, box-shadow 0.3s;
            padding: 30px;
            text-align: center;
            position: relative;
            overflow: hidden;
            min-height: 100px; /* Ensure consistent height */
        }
        .option-card:hover {
            transform: scale(1.05) rotate(1deg);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.15), 0 0 10px rgba(0, 0, 0, 0.1);
        }
        .option-card.enter-card {
            background: var(--gradient-enter);
            border: 2px solid #6bdac4;
        }
        .option-card.view-card {
            background: var(--gradient-view);
            border: 2px solid #f4a8d1;
        }
        .option-card.edit-card {
            background: var(--gradient-edit);
            border: 2px solid #89b8e8;
        }
        .option-card.timetable-card {
            background: var(--gradient-timetable);
            border: 2px solid #ffb876;
        }
        .option-icon {
            width: 60px;
            height: auto;
            margin-bottom: 15px;
            display: block;
            margin-left: auto;
            margin-right: auto;
        }
        .btn-custom {
            background-color: #3333a3;
            color: var(--white);
            border-radius: 30px;
            padding: 12px 25px;
            font-size: 18px;
            font-weight: 600;
            letter-spacing: 0.5px;
            text-decoration: none;
            transition: background-color 0.3s ease;
        }
        .btn-custom:hover {
            background-color: #4d4db3;
            color: var(--white);
        }
        .btn-back {
            background-color: #3333a3;
            color: var(--white);
            border-radius: 20px;
            padding: 10px 20px;
            font-size: 16px;
            font-weight: 500;
            border: none;
            transition: background-color 0.3s ease;
        }
        .btn-back:hover {
            background-color: #4d4db3;
            color: var(--white);
        }
        .text-muted {
            color: var(--text-dark) !important;
        }
    </style>
</head>
<body>
    <img src="images/logo.png" alt="School Logo" class="logo">

    <div class="main-container">
        <h1 class="mb-4">Teacher Section</h1>
        <div class="row justify-content-center">
            <div class="col-md-4 mb-4">
                <div class="option-card enter-card">
                    <img src="https://img.icons8.com/ios-filled/50/000000/add-user-male.png" alt="Enter Icon" class="option-icon">
                    <h3>Enter Teacher Details</h3>
                    <a href="adminAddTeacher.jsp" class="btn btn-custom mt-3">Enter Details</a>
                </div>
            </div>
            <div class="col-md-4 mb-4">
                <div class="option-card view-card">
                    <img src="https://cdn-icons-png.flaticon.com/512/709/709612.png" alt="View Teacher Icon" class="option-icon">
                    <h3>View Teacher Details</h3>
                    <a href="adminViewTeacher.jsp" class="btn btn-custom mt-3">View Details</a>
                </div>
            </div>
            <div class="col-md-4 mb-4">
                <div class="option-card edit-card">
                    <img src="https://cdn-icons-png.flaticon.com/512/2919/2919592.png" alt="Edit Teacher Icon" class="option-icon">
                    <h3>Edit Teacher Details</h3>
                    <a href="adminEditTeacher.jsp" class="btn btn-custom mt-3">Edit Details</a>
                </div>
            </div>
        </div>
        <div class="row justify-content-center">
            <div class="col-md-8 mb-4">
                <div class="option-card timetable-card">
                    <img src="https://cdn-icons-png.flaticon.com/512/2693/2693507.png" alt="Timetable Icon" class="option-icon">
                    <h3>Manage Timetable</h3>
                    <a href="adminSchedule.jsp" class="btn btn-custom mt-3">Manage Timetable</a>
                </div>
            </div>
        </div>
        <a href="adminDashboard.jsp" class="btn btn-back mt-4">Back to Home</a>
    </div>
</body>
</html>
