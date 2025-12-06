<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <title>Seller Dashboard</title>

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
    List<Map<String,Object>> categories =
        (List<Map<String,Object>>) request.getAttribute("categories");
%>

<nav class="navbar navbar-inverse">
    <div class="container-fluid">
        <div class="navbar-header">
            <a class="navbar-brand">Auction System – Seller</a>
        </div>
        <ul class="nav navbar-nav navbar-right">
            <li><a>Logged in as: <strong><%= email %></strong></a></li>
            <li><a href="logout">Logout</a></li>
        </ul>
    </div>
</nav>

<div class="container">

    <div class="card">
        <h3>Create New Auction</h3>
        <hr/>

        <form action="createAuction" method="POST">

            <!-- ITEM DETAILS -->
            <h4>Item Details</h4>
            <label>Title</label>
            <input type="text" class="form-control" name="title" required>

            <label>Description</label>
            <textarea class="form-control" name="description"></textarea>

            <label>Category</label>
            <select class="form-control" name="category" required>
                <%
                    if (categories != null) {
                        for (Map<String,Object> c : categories) {
                %>
                    <option value="<%= c.get("cat_id") %>"><%= c.get("name") %></option>
                <%
                        }
                    }
                %>
            </select>

            <label>Size</label>
            <input type="text" class="form-control" name="size">

            <label>Brand</label>
            <input type="text" class="form-control" name="brand">

            <label>Color</label>
            <input type="text" class="form-control" name="color">

            <label>Condition</label>
            <input type="text" class="form-control" name="condition">

            <hr/>

            <!-- AUCTION DETAILS -->
            <h4>Auction Details</h4>

            <label>Start Time</label>
            <input type="datetime-local" class="form-control" name="start_time" required>

            <label>End Time</label>
            <input type="datetime-local" class="form-control" name="end_time" required>

            <label>Starting Price ($)</label>
            <input type="number" class="form-control" name="start_price" required>

            <label>Reserve Price ($)</label>
            <input type="number" class="form-control" name="reserve_price" required>

            <button type="submit" class="btn btn-primary" style="margin-top:15px;">
                Create Auction
            </button>
        </form>
    </div>

</div>

</body>
</html>
