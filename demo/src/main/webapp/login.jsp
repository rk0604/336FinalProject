<%@ page import="java.sql.*, javax.sql.*, java.util.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <title>Login</title>

    <!-- BOOTSTRAP IMPORTS -->
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet"
          href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>

    <style>
        body {
            margin: 0in;
            background: #f7f7f7;
            font-family: Arial, sans-serif;
        }

        /* Navbar override for consistency */
        .navbar-inverse {
            border-radius: 0 !important;
            background-color: #2c3e50 !important;
            border-color: #2c3e50 !important;
        }

        .navbar-inverse .navbar-brand,
        .navbar-inverse .nav > li > a {
            color: white !important;
            font-weight: bold;
        }

        /* Centered login box */
        .login-box {
            margin: auto;
            max-width: 450px;
            margin-top: 80px;
            padding: 35px;
            background: white;
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        }

        h2 {
            color: #2c3e50;
            text-align: center;
            margin-bottom: 25px;
        }

        label {
            font-weight: bold;
            margin-top: 12px;
        }

        input {
            width: 100%;
            padding: 10px;
            border-radius: 6px;
            border: 1px solid #bdc3c7;
            margin-top: 5px;
        }

        button {
            width: 100%;
            padding: 12px;
            margin-top: 20px;
            background: #2980b9;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 17px;
        }

        button:hover {
            background: #1f6391;
        }

        .signup-link {
            text-align: center;
            margin-top: 15px;
        }
    </style>
</head>

<body>

<!-- NAVBAR -->
<nav class="navbar navbar-inverse">
    <div class="container-fluid">
        <div class="navbar-header">
            <a class="navbar-brand">Auction System</a>
        </div>
    </div>
</nav>

<!-- LOGIN CONTAINER -->
<div class="login-box">

    <h2>Login</h2>

    <!-- 
        IMPORTANT FOR BACKEND:
        
        When the user submits this form, loginBackend.jsp should:
        1. SELECT user from DB:
              SELECT * FROM User WHERE Email=? AND Password=? AND Is_active=1;
        
        2. If match found:
              - create session:
                    session.setAttribute("userID", user_id);
                    session.setAttribute("role", Role);
              
              - redirect based on role:
                    seller -> sellerDashboard.jsp
                    buyer -> biddingPage.jsp
                    admin -> adminDashboard.jsp
                    rep -> repDashboard.jsp
        
        3. If no match:
              - return an error message:
                    "Invalid login, please try again."
    -->

    <form action="loginBackend.jsp" method="POST">

        <label>Email</label>
        <input type="text" name="email" placeholder="Enter Email" required>

        <label>Password</label>
        <input type="password" name="password" placeholder="Enter Password" required>

        <button type="submit">Login</button>
    </form>

    <div class="signup-link">
        <p>Don't have an account? <a href="register.jsp">Register here</a></p>
    </div>

</div>

</body>
</html>
