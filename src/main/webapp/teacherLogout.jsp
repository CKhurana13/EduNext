<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Logged Out</title>
    <style>
    @charset "UTF-8";
body {
    margin: 0;
    font-family: 'Lato', sans-serif;
     background-image: url('../images/background.jpg');
    background-repeat: no-repeat;
    background-size: cover;
    background-position: center center;
    display: flex;
    align-items: center;
    justify-content: center;
    height: 100vh;
}

.logout-container {
    background: white;
    padding: 40px;
    border-radius: 10px;
    box-shadow: 0 0 12px rgba(0,0,0,0.1);
    text-align: center;
}

.logout-container h2 {
    color: #004d99;
    margin-bottom: 15px;
}

.logout-container p {
    margin-bottom: 25px;
    font-size: 16px;
    color: #333;
}

.back-btn {
    padding: 12px 25px;
    background-color: #004d99;
    color: white;
    text-decoration: none;
    border-radius: 8px;
    font-weight: bold;
    transition: background-color 0.3s ease;
}

.back-btn:hover {
    background-color: #003366;
}
    
</style>   
</head>
<body>
<div class="logout-container">
    <h2>You have been logged out.</h2>
    <p>Thank you for using the EduNext.</p>
    <a href="teacherLogin.jsp" class="back-btn">🔐 Login Again</a>
    
</div>
</body>
</html>
