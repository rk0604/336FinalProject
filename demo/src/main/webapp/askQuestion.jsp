<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <title>Ask Customer Representative</title>

    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet"
          href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">

    <style>
        body {
            background: #f4f7fb;
            font-family: Arial, sans-serif;
            padding-bottom: 40px;
        }
        .navbar-inverse {
            border-radius: 0;
            background-color: #2c3e50 !important;
            border-color: #2c3e50 !important;
        }
        .navbar-inverse .navbar-brand,
        .navbar-inverse .nav > li > a {
            color: #ecf0f1 !important;
            font-weight: bold;
        }
        .card {
            background: #ffffff;
            border-radius: 10px;
            padding: 25px;
            margin-top: 25px;
            box-shadow: 0 3px 8px rgba(0,0,0,0.08);
        }
        label { font-weight: bold; }
        hr { border-color: #d0d7de; }
    </style>
</head>
<body>

<%
    String email = (String) session.getAttribute("email");
%>

<nav class="navbar navbar-inverse">
    <div class="container-fluid">
        <div class="navbar-header">
            <a class="navbar-brand">Auction System</a>
        </div>
        <ul class="nav navbar-nav">
            <li><a href="browseAuctions">Browse</a></li>
            <li><a href="myAuctions">My Auctions</a></li>
            <li class="active"><a href="askQuestion">Ask a Question</a></li>
        </ul>
        <ul class="nav navbar-nav navbar-right">
            <li><a href="myAlerts">My Alerts</a></li>
            <li><a>Logged in as: <strong><%= (email != null ? email : "") %></strong></a></li>
            <li><a href="logout">Logout</a></li>
        </ul>
    </div>
</nav>

<div class="container">
    <div class="card">
        <h3>Contact Customer Representative</h3>
        <hr/>

        <form action="askQuestion" method="POST">
            <label>Subject</label>
            <input type="text" class="form-control" name="subject" required>

            <label style="margin-top:10px;">Your Question</label>
            <textarea class="form-control" name="body" rows="5" required></textarea>

            <button type="submit" class="btn btn-primary" style="margin-top:15px;">
                Submit Question
            </button>
        </form>
    </div>
</div>

</body>
</html>
