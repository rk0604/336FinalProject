<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <title>My Auctions</title>

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
            padding: 20px;
            margin-top: 25px;
            box-shadow: 0 3px 8px rgba(0,0,0,0.08);
        }
        table {
            width: 100%;
            background: #ffffff;
        }
        th, td {
            padding: 8px 10px;
            border-bottom: 1px solid #e1e4e8;
        }
        th {
            background: #f6f8fa;
        }
    </style>
</head>
<body>

<%
    String email = (String) session.getAttribute("email");
    String mode  = (String) request.getAttribute("mode"); // "seller" or "buyer"
    List<Map<String,Object>> auctions =
        (List<Map<String,Object>>) request.getAttribute("auctions");

    if (mode == null) mode = "buyer";
%>

<nav class="navbar navbar-inverse">
    <div class="container-fluid">
        <div class="navbar-header">
            <a class="navbar-brand">Auction System</a>
        </div>
        <ul class="nav navbar-nav">
            <li><a href="browseAuctions">Browse Auctions</a></li>
        </ul>
        <ul class="nav navbar-nav navbar-right">
            <li><a href="myAlerts">My Alerts</a></li>
            <li><a>Logged in as: <strong><%= email %></strong></a></li>
            <li><a href="logout">Logout</a></li>
        </ul>
    </div>
</nav>

<div class="container">
    <div class="card">
        <h3>
            <% if ("seller".equalsIgnoreCase(mode)) { %>
                Auctions I am selling
            <% } else { %>
                Auctions I have bid on
            <% } %>
        </h3>
        <hr/>

        <%
            if (auctions == null || auctions.isEmpty()) {
        %>
            <p>No auctions found.</p>
        <%
            } else {
        %>
            <table class="table table-striped">
                <thead>
                <tr>
                    <th>Auction ID</th>
                    <th>Title</th>
                    <th>Category</th>
                    <th>Status</th>
                    <th>Start Price</th>
                    <th>Final Price</th>
                    <th>Ends / Ended</th>
                    <th>Actions</th>
                </tr>
                </thead>
                <tbody>
                <%
                    for (Map<String,Object> a : auctions) {
                        int auctionId = (Integer) a.get("auction_id");
                        String title  = (String) a.get("title");
                        String category = (String) a.get("category");
                        String status = (String) a.get("status");
                        Integer startPrice = (Integer) a.get("start_price");
                        Object finalPriceObj = a.get("final_price");
                        String finalPrice = (finalPriceObj != null) ? finalPriceObj.toString() : "-";
                        java.sql.Timestamp endTime = (java.sql.Timestamp) a.get("end_time");
                %>
                <tr>
                    <td><%= auctionId %></td>
                    <td><%= title %></td>
                    <td><%= category %></td>
                    <td><%= status %></td>
                    <td>$<%= startPrice %></td>
                    <td><%= finalPrice.equals("-") ? "-" : "$" + finalPrice %></td>
                    <td><%= endTime %></td>
                    <td>
                        <a href="bidHistory?auction_id=<%= auctionId %>">Bid history</a>
                    </td>
                </tr>
                <%
                    }
                %>
                </tbody>
            </table>
        <%
            }
        %>
    </div>
</div>

</body>
</html>
