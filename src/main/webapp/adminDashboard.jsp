<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>School Portal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
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
        }
        .logo {
            position: absolute;
            top: 20px;
            left: 20px;
            width: 100px;
            height: auto;
            z-index: 1000;
        }
        .main-container {
            background-color: rgba(255, 255, 255, 0.9);
            border-radius: 20px;
            padding: 40px;
            margin-top: 100px;
            margin-bottom: 50px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            max-width: 900px;
            margin-left: auto;
            margin-right: auto;
            text-align: center;
        }
        h1 {
            color: var(--darker-purple);
            font-weight: bold;
        }
        .option-card {
            background-color: var(--white);
            border-radius: 50%; /* Circular shape */
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            transition: transform 0.3s, background-color 0.3s;
            padding: 20px;
            height: 200px;
            width: 200px; /* Fixed width for circular shape */
            display: inline-flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            text-align: center;
            margin: 10px;
        }
        .option-card:hover {
            transform: scale(1.07);
            background-color: #e8f5e9;
        }
        .btn-custom {
            background-color: var(--dark-purple);
            color: var(--white);
            border-radius: 50px;
            padding: 10px 20px;
            font-size: 16px;
            font-weight: 600;
            text-decoration: none;
            display: inline-block;
            margin-top: 10px;
        }
        .btn-custom:hover {
            background-color: var(--secondary-pink);
            color: var(--white);
        }
        .icon-img {
            width: 80px;
            height: 80px;
            margin-bottom: 10px;
            display: block;
        }
        .text-muted {
            color: var(--text-dark) !important;
        }
    </style>
</head>
<body>
    <img src="images/logo.png" alt="School Logo" class="logo">

    <div class="main-container">
        <h1 class="mb-3">🏫 Welcome to Admin Portal</h1>

        <div class="row justify-content-center">
            <!-- Student Section -->
            <div class="col-md-4 mb-4">
                <div class="option-card">
                    <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRB0qo95bURsm9dvb9vVQYF-K3TVWpxyp5HxBN9NIzqHn_iv2H9K5YVyfK5oMWkKjo121Y&usqp=CAU" alt="Student Icon" class="icon-img">
                    <h3 style="color:var(--darker-purple);">Student Section</h3>
                    <a href="adminStudentSection.jsp" class="btn btn-custom mt-3">Explore Students</a>
                </div>
            </div>

            <!-- Teacher Section -->
            <div class="col-md-4 mb-4">
                <div class="option-card">
                    <img src="https://5.imimg.com/data5/BM/WR/GLADMIN-70100492/teacher-login-portal-500x500.png" alt="Teacher Icon" class="icon-img">
                    <h3 style="color:var(--darker-purple);">Teacher Section</h3>
                    <a href="adminTeacherSection.jsp" class="btn btn-custom mt-3">Meet Teachers</a>
                </div>
            </div>

            <!-- Circulars Section -->
            <div class="col-md-4 mb-4">
                <div class="option-card">
                    <img src="https://cdn-icons-png.flaticon.com/512/2720/2720981.png" alt="Circular Icon" class="icon-img">
                    <h3 style="color:var(--darker-purple);">Circulars</h3>
                    <a href="adminCircular.jsp" class="btn btn-custom mt-3">View Circulars</a>
                </div>
            </div>

            
        </div>
    </div>

</body>
</html>