<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Create Customer Representative</title>

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
        .form-title {
            margin-bottom: 15px;
        }
        .message {
            margin-top: 10px;
        }
    </style>
</head>
<body>

<%
    String emailSession = (String) session.getAttribute("email");
    String success = (String) request.getAttribute("success");
    String error   = (String) request.getAttribute("error");
%>

<nav class="navbar navbar-inverse">
    <div class="container-fluid">
        <div class="navbar-header">
            <a class="navbar-brand">Auction System - Admin</a>
        </div>
        <ul class="nav navbar-nav navbar-right">
            <li><a>Logged in as: <strong><%= (emailSession != null ? emailSession : "") %></strong></a></li>
            <li><a href="logout">Logout</a></li>
        </ul>
    </div>
</nav>

<div class="container">
    <div class="card">
        <h3 class="form-title">Create Customer Representative Account</h3>
        <p class="text-muted">
            Fill in the details below to create a new customer representative. The representative
            will be able to manage bids, auctions, and user questions.
        </p>
        <hr/>

        <% if (success != null) { %>
            <div class="alert alert-success message"><%= success %></div>
        <% } else if (error != null) { %>
            <div class="alert alert-danger message"><%= error %></div>
        <% } %>

        <form method="post" action="createRep" class="form-horizontal">

            <div class="form-group">
                <label class="col-sm-2 control-label">Email</label>
                <div class="col-sm-6">
                    <input type="email" name="email" class="form-control"
                           placeholder="rep@example.com" required>
                </div>
            </div>

            <div class="form-group">
                <label class="col-sm-2 control-label">Password</label>
                <div class="col-sm-6">
                    <input type="password" name="password" class="form-control"
                           placeholder="Temporary password" required>
                </div>
            </div>

            <div class="form-group">
                <label class="col-sm-2 control-label">Region</label>
                <div class="col-sm-6">
                    <input type="text" name="region" class="form-control"
                           placeholder="e.g. Northeast, West Coast" required>
                </div>
            </div>

            <div class="form-group">
                <label class="col-sm-2 control-label">Hire Date</label>
                <div class="col-sm-3">
                    <input type="date" name="hire_date" class="form-control">
                    <span class="help-block">
                        Leave blank to use today's date.
                    </span>
                </div>
            </div>

            <div class="form-group">
                <div class="col-sm-offset-2 col-sm-6">
                    <button type="submit" class="btn btn-primary">
                        Create Representative
                    </button>
                    <a href="../adminDashboard.jsp" class="btn btn-default">
                        Back to Admin Dashboard
                    </a>
                </div>
            </div>
        </form>
    </div>
</div>

</body>
</html>
