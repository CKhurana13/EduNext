
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>EDUNEXT</title>
  <style>
    body {
      margin: 0;
      padding: 0;
      font-family: Arial, sans-serif;
      display: flex;
      justify-content: center;
      align-items: center;
      height: 100vh;
      background: linear-gradient(45deg, #6b48ff, #00ddeb, #ff6b6b, #ffd700);
      background-size: 400% 400%;
      animation: gradientShift 15s ease infinite;
      position: relative;
      overflow: hidden;
    }

    @keyframes gradientShift {
      0% { background-position: 0% 50%; }
      50% { background-position: 100% 50%; }
      100% { background-position: 0% 50%; }
    }

    .background-shape {
      position: absolute;
      opacity: 0.5;
    }

    .bubble1 {
      width: 300px;
      height: 300px;
      background: radial-gradient(circle, rgba(255, 255, 255, 0.8), transparent);
      border-radius: 50%;
      top: -50px;
      left: 10%;
      animation: float 5s ease-in-out infinite;
    }

    .bubble2 {
      width: 200px;
      height: 200px;
      background: radial-gradient(circle, rgba(255, 105, 180, 0.7), transparent);
      border-radius: 50%;
      bottom: 20px;
      right: 15%;
      animation: float 7s ease-in-out infinite reverse;
    }

    .star {
      width: 150px;
      height: 150px;
      background: radial-gradient(circle, rgba(255, 215, 0, 0.6), transparent);
      clip-path: polygon(50% 0%, 61% 35%, 98% 35%, 68% 57%, 79% 91%, 50% 70%, 21% 91%, 32% 57%, 2% 35%, 39% 35%);
      top: 20%;
      left: 50%;
      animation: spin 12s linear infinite;
    }

    @keyframes float {
      0% { transform: translateY(0px); }
      50% { transform: translateY(-20px); }
      100% { transform: translateY(0px); }
    }

    @keyframes spin {
      0% { transform: rotate(0deg); }
      100% { transform: rotate(360deg); }
    }

    .container {
      display: flex;
      justify-content: space-between;
      width: 900px;
      z-index: 1;
      gap: 30px;
    }

    .button {
      width: 280px;
      height: 280px;
      border: none;
      display: flex;
      flex-direction: column;
      justify-content: flex-end;
      cursor: pointer;
      box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
      overflow: hidden;
      position: relative;
      text-decoration: none;
      transition: transform 0.3s ease, z-index 0s;
      z-index: 2;
      border-radius: 15px;
    }

    .button:hover {
      transform: scale(1.1);
      z-index: 5;
    }

    .top-part {
      flex: 0 0 70%;
      display: flex;
      align-items: center;
      justify-content: center;
      position: relative;
      z-index: 2;
    }

    .color-overlay {
      position: absolute;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      z-index: 1;
      border-radius: 15px 15px 0 0;
    }

    .bottom-part {
      flex: 0 0 30%;
      background: #fff;
      display: flex;
      align-items: center;
      justify-content: center;
      position: relative;
      z-index: 3;
    }

    .button span {
      font-size: 24px;
      font-weight: bold;
      color: #000;
      z-index: 4;
      text-decoration: none;
    }

    .admin .color-overlay {
      background: linear-gradient(135deg, #4a90e2, #2a6eb6);
    }

    .teacher .color-overlay {
      background: linear-gradient(135deg, #e23b53, #b62a3c);
    }

    .student .color-overlay {
      background: linear-gradient(135deg, #f5a623, #d68c1a);
    }

    .icon {
      width: 100px;
      height: 100px;
      background: #fff;
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      z-index: 2;
    }

    .icon img {
      width: 70px;
      height: 70px;
      object-fit: contain;
    }

    a {
      text-decoration: none;
    }
  </style>
</head>
<body>
  <%@ include file="logo.jsp" %>
  <div class="background-shape bubble1"></div>
  <div class="background-shape bubble2"></div>
  <div class="background-shape star"></div>
  <div class="container">
    <a href="adminLogin.jsp" class="button admin">
      <div class="top-part">
        <div class="icon">
          <img src="data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='%23000000'><path d='M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm0 18c-4.41 0-8-3.59-8-8s3.59-8 8-8 8 3.59 8 8-3.59 8-8 8zm-1-13h2v6h-2zm0 8h2v2h-2z'/></svg>" alt="Admin Icon">
        </div>
      </div>
      <div class="color-overlay"></div>
      <div class="bottom-part"><span>Admin</span></div>
    </a>
    <a href="teacherLogin.jsp" class="button teacher">
      <div class="top-part">
        <div class="icon">
          <img src="data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='%23000000'><path d='M5 13.18v4L12 21l7-3.82v-4L12 17l-7-3.82zM12 3L1 9l11 6 11-6-11-6z'/></svg>" alt="Teacher Icon">
        </div>
      </div>
      <div class="color-overlay"></div>
      <div class="bottom-part"><span>Teacher</span></div>
    </a>
    <a href="studentLogin.jsp" class="button student">
      <div class="top-part">
        <div class="icon">
          <img src="data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='%23000000'><path d='M4 6H2v14c0 1.1.9 2 2 2h14v-2H4V6zm16-4H8c-1.1 0-2 .9-2 2v12c0 1.1.9 2 2 2h12c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2zm-1 9h-4v4h-2v-4H9V9h4V5h2v4h4v2z'/></svg>" alt="Student Icon">
        </div>
      </div>
      <div class="color-overlay"></div>
      <div class="bottom-part"><span>Student</span></div>
    </a>
  </div>
</body>
</html>