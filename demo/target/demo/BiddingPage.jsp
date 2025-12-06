<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <title>Browse Auctions</title>

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
        .auction-card {
            background: #ffffff;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 25px;
            box-shadow: 0 3px 8px rgba(0,0,0,0.08);
        }
        .auction-title {
            font-size: 20px;
            font-weight: bold;
            margin-bottom: 8px;
        }
        .auction-meta {
            color: #7f8c8d;
            font-size: 13px;
            margin-bottom: 10px;
        }
        .auction-price {
            font-weight: bold;
            color: #2980b9;
            margin-bottom: 10px;
        }
        .bid-section input {
            margin-bottom: 8px;
        }
        hr {
            border-color: #d0d7de;
        }
        .filter-bar {
            background: #ffffff;
            padding: 15px;
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.06);
            margin-bottom: 20px;
        }
        .filter-label {
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: .5px;
            color: #7f8c8d;
        }
    </style>
</head>
<body>

<%
    String email = (String) session.getAttribute("email");
    List<Map<String,Object>> auctions =
       (List<Map<String,Object>>) request.getAttribute("auctions");
    List<String> categories =
       (List<String>) request.getAttribute("categories");

    String q = (String) request.getAttribute("q");
    String selectedCategory = (String) request.getAttribute("selectedCategory");
    String sort = (String) request.getAttribute("sort");

    if (q == null) q = "";
    if (selectedCategory == null) selectedCategory = "";
    if (sort == null) sort = "";
%>

<nav class="navbar navbar-inverse">
    <div class="container-fluid">
        <div class="navbar-header">
            <a class="navbar-brand">Auction System</a>
        </div>
        <ul class="nav navbar-nav navbar-right">
            <li><a href="myAlerts">My Alerts</a></li>
            <li><a>Logged in as: <strong><%= (email != null ? email : "") %></strong></a></li>
            <li><a href="logout">Logout</a></li>
        </ul>
    </div>
</nav>

<div class="container">
    <h2>Active Auctions</h2>
    <hr/>

    <!-- Search / Filter / Sort bar -->
    <div class="filter-bar">
        <form class="form-inline" method="get" action="browseAuctions">
            <div class="row">
                <div class="col-sm-4">
                    <label class="filter-label">Search</label>
                    <input type="text" class="form-control" name="q"
                           placeholder="Search by title, description, brand..."
                           style="width:100%;"
                           value="<%= q %>"/>
                </div>

                <div class="col-sm-3">
                    <label class="filter-label">Category</label>
                    <select name="category" class="form-control" style="width:100%;">
                        <option value="">All categories</option>
                        <%
                            if (categories != null) {
                                for (String cat : categories) {
                        %>
                        <option value="<%= cat %>"
                            <%= cat.equals(selectedCategory) ? "selected" : "" %>>
                            <%= cat %>
                        </option>
                        <%
                                }
                            }
                        %>
                    </select>
                </div>

                <div class="col-sm-3">
                    <label class="filter-label">Sort by</label>
                    <select name="sort" class="form-control" style="width:100%;">
                        <option value="">Ending soon</option>
                        <option value="priceAsc"  <%= "priceAsc".equals(sort)  ? "selected" : "" %>>Price: Low to High</option>
                        <option value="priceDesc" <%= "priceDesc".equals(sort) ? "selected" : "" %>>Price: High to Low</option>
                        <option value="title"     <%= "title".equals(sort)     ? "selected" : "" %>>Title A–Z</option>
                    </select>
                </div>

                <div class="col-sm-2" style="margin-top:22px;">
                    <button type="submit" class="btn btn-primary btn-block">
                        Apply
                    </button>
                </div>
            </div>
        </form>
    </div>

    <%
        if (auctions == null || auctions.isEmpty()) {
    %>
        <p>No active auctions match your criteria.</p>
    <%
        } else {
            for (Map<String,Object> a : auctions) {
                int auctionId     = (Integer) a.get("auction_id");
                String title      = (String) a.get("title");
                String desc       = (String) a.get("description");
                String category   = (String) a.get("category");
                String brand      = (String) a.get("brand");
                String color      = (String) a.get("color");
                String size       = (String) a.get("size");
                String condition  = (String) a.get("condition");
                int startPrice    = (Integer) a.get("start_price");
                java.sql.Timestamp endTime = (java.sql.Timestamp) a.get("end_time");
    %>

    <div class="auction-card">
        <div class="auction-title"><%= title %></div>

        <div class="auction-meta">
            <b>Category:</b> <%= category %> |
            <b>Brand:</b> <%= (brand != null ? brand : "N/A") %> |
            <b>Color:</b> <%= (color != null ? color : "N/A") %> |
            <b>Size:</b> <%= (size != null ? size : "N/A") %> |
            <b>Condition:</b> <%= (condition != null ? condition : "N/A") %>
        </div>

        <p><%= (desc != null ? desc : "") %></p>

        <div class="auction-price">Starting price: $<%= startPrice %></div>
        <div class="auction-meta">Ends: <%= endTime %></div>

        <div class="row bid-section" style="margin-top:15px;">
            <div class="col-sm-6">
                <form action="placeBid" method="POST">
                    <input type="hidden" name="auction_id" value="<%= auctionId %>">
                    <label>Manual Bid</label>
                    <input type="number" class="form-control" name="bid_amount"
                           placeholder="Enter bid amount" min="<%= startPrice %>" required/>
                    <button type="submit" class="btn btn-primary btn-block" style="margin-top:8px;">
                        Place Bid
                    </button>
                </form>
            </div>

            <div class="col-sm-6">
                <form action="setAutoBid" method="POST">
                    <input type="hidden" name="auction_id" value="<%= auctionId %>">
                    <label>Auto-Bid (Max Amount)</label>
                    <input type="number" class="form-control" name="max_bid_amount"
                           placeholder="Enter max auto-bid" min="<%= startPrice %>" required/>
                    <button type="submit" class="btn btn-default btn-block" style="margin-top:8px;">
                        Set Auto-Bid
                    </button>
                </form>
            </div>
        </div>

        <div style="margin-top:10px;">
            <a href="bidHistory?auction_id=<%= auctionId %>">View Bid History</a>
        </div>
    </div>

    <%
            } // end loop
        }
    %>

</div>

</body>
</html>
