<%@ page import="java.util.List, java.util.Map" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Admin - Profit / Loss by Auction</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link rel="stylesheet"
          href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">

    <style>
        body {
            background: #f4f7fb;
            font-family: Arial, sans-serif;
        }
        .page-header {
            margin-top: 30px;
            margin-bottom: 20px;
        }
        .summary-box {
            margin-bottom: 20px;
        }
        .summary-box .panel-heading {
            font-size: 16px;
            font-weight: bold;
        }
        .summary-box .panel-body {
            font-size: 18px;
        }
        .table-container {
            background: #ffffff;
            padding: 20px;
            border-radius: 4px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
        }
        .profit-positive {
            color: #27ae60;
            font-weight: bold;
        }
        .profit-negative {
            color: #c0392b;
            font-weight: bold;
        }
        .back-link {
            margin-top: 20px;
        }
    </style>
</head>
<body>
<div class="container">

    <div class="page-header">
        <h2>Total Earnings - Profit / Loss by Auction</h2>
        <p class="text-muted">
            Each row shows the highest bid for an auction, the revenue from that auction,
            and the resulting profit (revenue minus start price).
        </p>
    </div>

    <%
        List<Map<String,Object>> rows =
                (List<Map<String,Object>>) request.getAttribute("earningsRows");
        Integer totalRevenue = (Integer) request.getAttribute("totalRevenue");
        Integer totalProfit  = (Integer) request.getAttribute("totalProfit");
        if (totalRevenue == null) totalRevenue = 0;
        if (totalProfit == null) totalProfit = 0;
    %>

    <div class="row summary-box">
        <div class="col-sm-6">
            <div class="panel panel-default">
                <div class="panel-heading">Total Revenue (all auctions)</div>
                <div class="panel-body">
                    $<%= totalRevenue %>
                </div>
            </div>
        </div>
        <div class="col-sm-6">
            <div class="panel panel-default">
                <div class="panel-heading">Total Profit (all auctions)</div>
                <div class="panel-body">
                    $<%= totalProfit %>
                </div>
            </div>
        </div>
    </div>

    <div class="table-container">
        <%
            if (rows == null || rows.isEmpty()) {
        %>
            <p>No auction earnings data available.</p>
        <%
            } else {
        %>
        <div class="table-responsive">
            <table class="table table-striped table-bordered">
                <thead>
                <tr>
                    <th>Auction ID</th>
                    <th>Item Title</th>
                    <th>Start Price</th>
                    <th>Highest Bid</th>
                    <th>Revenue</th>
                    <th>Profit / Loss</th>
                </tr>
                </thead>
                <tbody>
                <%
                    for (Map<String,Object> m : rows) {
                        int auctionId   = (Integer) m.get("auctionId");
                        String title    = (String) m.get("title");
                        int startPrice  = (Integer) m.get("startPrice");
                        int highestBid  = (Integer) m.get("highestBid");
                        int revenue     = (Integer) m.get("revenue");
                        int profit      = (Integer) m.get("profit");
                        String profitClass = (profit >= 0) ? "profit-positive" : "profit-negative";
                %>
                <tr>
                    <td><%= auctionId %></td>
                    <td><%= title %></td>
                    <td>$<%= startPrice %></td>
                    <td>
                        <% if (highestBid > 0) { %>
                            $<%= highestBid %>
                        <% } else { %>
                            <span class="text-muted">No bids</span>
                        <% } %>
                    </td>
                    <td>$<%= revenue %></td>
                    <td class="<%= profitClass %>">$<%= profit %></td>
                </tr>
                <%
                    }
                %>
                </tbody>
            </table>
        </div>
        <%
            }
        %>
    </div>

    <div class="back-link">
        <a href="adminDashboard.jsp" class="btn btn-default">Back to Admin Dashboard</a>
    </div>

</div>
</body>
</html>
