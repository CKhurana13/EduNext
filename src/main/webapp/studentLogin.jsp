<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Portal Login</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap');

        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, #89CFF0, #A1C4FD, #D8BFD8, #E6E6FA);
            height: 100vh;
            margin: 0;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .login-container {
            width: 90%;
            max-width: 1000px;
            background: white;
            border-radius: 15px;
            box-shadow: 0 20px 30px rgba(98, 16, 238, 0.2);
            overflow: hidden;
            display: flex;
            min-height: 600px;
        }

        .illustration-side {
            width: 50%;
            background: linear-gradient(to right bottom, #4f6cea, #6578f1);
            color: white;
            padding: 40px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            text-align: center;
        }

        .form-side {
            width: 50%;
            padding: 40px;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: #334155;
        }

        .form-group input {
            width: 100%;
            padding: 12px 15px;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            font-size: 16px;
            transition: all 0.3s;
        }

        .form-group input:focus {
            outline: none;
            border-color: #4f46e5;
            box-shadow: 0 0 0 2px rgba(79, 70, 229, 0.2);
        }

        .btn {
            background: #4f46e5;
            color: white;
            border: none;
            padding: 12px;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s;
            width: 100%;
            margin-top: 10px;
        }

        .btn:hover {
            background: #4338ca;
        }

        .forgot-pass {
            text-align: center;
            margin-top: 20px;
            color: #64748b;
        }

        .forgot-pass a {
            color: #4f46e5;
            text-decoration: none;
        }

        .logo {
            width: 100px;
            margin-bottom: 30px;
        }

        .illustration-img {
            width: 50%;
            margin-bottom: 30px;
        }

        .features {
            margin-top: 30px;
        }

        .feature {
            display: flex;
            align-items: center;
            margin-bottom: 15px;
            font-size: 14px;
        }

        .feature-icon {
            width: 20px;
            height: 20px;
            margin-right: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: rgba(255, 255, 255, 0.2);
            border-radius: 50%;
        }

        .divider {
            display: flex;
            align-items: center;
            margin: 30px 0;
            color: #64748b;
        }

        .divider::before, .divider::after {
            content: '';
            flex: 1;
            border-bottom: 1px solid #e2e8f0;
        }

        .divider-text {
            padding: 0 15px;
        }

        @media (max-width: 768px) {
            .login-container {
                flex-direction: column;
                max-width: 500px;
            }

            .illustration-side, .form-side {
                width: 100%;
            }

            .illustration-side {
                padding: 30px;
            }

            .illustration-img {
                width: 60%;
            }
        }
    </style>
</head>
<body>
    <div class="login-container">
        <div class="illustration-side">
            <img src="S/images/logo.png" alt="Website logo" class="logo">
            <img src="S/images/group.avif" alt="Group Photo" class="illustration-img">
            <h2>Welcome to the Student Portal</h2>
            <p>Access your learning materials, assignments, and class information</p>
            <div class="features">
                <div class="feature">
                    <div class="feature-icon">✓</div>
                    <span>Track your academic performance</span>
                </div>
                <div class="feature">
                    <div class="feature-icon">✓</div>
                    <span>Submit assignments online</span>
                </div>
                <div class="feature">
                    <div class="feature-icon">✓</div>
                    <span>Access class materials anytime</span>
                </div>
            </div>
        </div>
        <div class="form-side">
            <form id="student-form" method="post" action="StudentLoginServlet">
                <h2 class="text-2xl font-bold mb-6 text-gray-800">Student Login</h2>
                <div class="form-group">
                    <label for="roll-number">Roll Number</label>
                    <input type="text" id="roll-number" name="rollNumber" placeholder="Enter your roll number" required>
                </div>
                <div class="form-group">
                    <label for="dob">Date of Birth</label>
                    <input type="date" id="dob" name="dob" required>
                </div>
                <button type="submit" class="btn">Login</button>
            </form>
            <%
                String error = (String) request.getAttribute("errorMessage");
                if (error != null) {
            %>
                <p style="color: red; text-align: center; margin-top: 10px;"><%= error %></p>
            <%
                }
            %>
        </div>
    </div>
</body>
</html>