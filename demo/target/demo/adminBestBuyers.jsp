<%@ page import="java.util.List, java.util.Map" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Best Buyers</title>
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
        .top-buyer-row {
            background-color: #f9fef5;
        }
        .rank-badge {
            display: inline-block;
            min-width: 26px;
            padding: 4px 8px;
            border-radius: 20px;
            text-align: center;
            font-size: 12px;
            font-weight: bold;
            background-color: #e9ecf5;
        }
        .rank-1 {
            background-color: #f1c40f;
            color: #000;
        }
        .back-link {
            margin-top: 20px;
        }
    </style>
</head>
<body>
<div class="container">

    <div class="page-header">
        <h2>Best Buyers</h2>
        <p class="text-muted">
            Ranked list of users by total amount spent across all winning bids.
        </p>
    </div>

    <%
        List<Map<String,Object>> buyers =
                (List<Map<String,Object>>) request.getAttribute("buyers");

        if (buyers == null || buyers.isEmpty()) {
    %>
        <p>No buyer data available.</p>
    <%
        } else {
            int totalSpentAll = 0;
            for (Map<String,Object> m : buyers) {
                totalSpentAll += (Integer) m.get("total");
            }
    %>

    <!-- Summary cards -->
    <div class="row summary-box">
        <div class="col-sm-6">
            <div class="panel panel-default">
                <div class="panel-heading">Number of Buyers</div>
                <div class="panel-body">
                    <%= buyers.size() %>
                </div>
            </div>
        </div>
        <div class="col-sm-6">
            <div class="panel panel-default">
                <div class="panel-heading">Total Spend (all buyers)</div>
                <div class="panel-body">
                    $<%= totalSpentAll %>
                </div>
            </div>
        </div>
    </div>

    <!-- Buyers table -->
    <div class="table-container">
        <div class="table-responsive">
            <table class="table table-striped table-bordered">
                <thead>
                <tr>
                    <th>#</th>
                    <th>Email</th>
                    <th>Total Spent</th>
                </tr>
                </thead>
                <tbody>
                <%
                    int rank = 1;
                    for (Map<String,Object> m : buyers) {
                        String email = (String) m.get("email");
                        int total   = (Integer) m.get("total");
                        boolean isTop = (rank == 1);
                %>
                <tr class="<%= isTop ? "top-buyer-row" : "" %>">
                    <td>
                        <span class="rank-badge <%= isTop ? "rank-1" : "" %>">
                            <%= rank %>
                        </span>
                    </td>
                    <td><%= email %></td>
                    <td>$<%= total %></td>
                </tr>
                <%
                        rank++;
                    }
                %>
                </tbody>
            </table>
        </div>
    </div>

    <%
        } // end else
    %>

    <div class="back-link">
        <a href="adminDashboard.jsp" class="btn btn-default">Back to Admin Dashboard</a>
    </div>

</div>
</body>
</html>
