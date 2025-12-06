<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard</title>

    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet"
          href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">

    <style>
        body {
            background: #f4f7fb;
            font-family: Arial, sans-serif;
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
            border-radius: 8px;
            padding: 20px;
            margin-top: 20px;
            box-shadow: 0 3px 8px rgba(0,0,0,0.08);
        }
    </style>
</head>
<body>

<%
    String email = (String) session.getAttribute("email");
%>

<nav class="navbar navbar-inverse">
    <div class="container-fluid">
        <div class="navbar-header">
            <a class="navbar-brand">Auction System - Admin</a>
        </div>
        <ul class="nav navbar-nav navbar-right">
            <li><a>Logged in as: <strong><%= (email != null ? email : "") %></strong></a></li>
            <li><a href="logout">Logout</a></li>
        </ul>
    </div>
</nav>

<div class="container">

    <div class="card">
        <h3>Reports</h3>
        <hr/>
        <p><a href="admin/totalEarnings">Total Earnings</a></p>
        <p><a href="admin/bestBuyers">Best Buyers</a></p>
        <p><a href="admin/bestItems">Best Selling Items</a></p>
    </div>

    <div class="card">
        <h3>Customer Representatives</h3>
        <hr/>
        <p><a href="admin/createRep">Create Customer Representative Account</a></p>
    </div>

</div>

</body>
</html>
