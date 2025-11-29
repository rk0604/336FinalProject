<%@ page import="java.sql.*, javax.sql.*, java.util.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<html>
<head>
    <title>Admin Dashboard</title>

    <!-- Bootstrap -->
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet"
          href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>

<style>
    body {
        margin: 0in;
        font-family: Arial, sans-serif;
        background: #f7f7f7;
    }

    .navbar-inverse {
        background-color: #2c3e50 !important;
        border-color: #2c3e50 !important;
        border-radius: 0 !important;
    }

    .navbar-inverse .navbar-brand,
    .navbar-inverse .nav > li > a {
        color: white !important;
        font-weight: bold;
    }

    .container {
        padding: 40px;
        max-width: 900px;
        margin: auto;
        background: white;
        border-radius: 8px;
        box-shadow: 0 3px 8px rgba(0,0,0,0.1);
    }

    h1, h2, h3 {
        color: #2c3e50;
        font-weight: bold;
    }

    .admin-card {
        border: 1px solid #d8d8d8;
        padding: 20px;
        background: #fff;
        border-radius: 10px;
        margin-bottom: 25px;
    }

    .admin-btn {
        padding: 10px 14px;
        border-radius: 6px;
        background:#2980b9;
        color:white;
        border:none;
        margin-top:10px;
    }

    .admin-btn:hover {
        background:#1f6391;
    }

</style>
</head>

<body>

<!-- NAVBAR -->
<nav class="navbar navbar-inverse">
    <div class="container-fluid">
        <div class="navbar-header">
            <a class="navbar-brand" href="#">Auction System - Admin</a>
        </div>
    </div>
</nav>

<div class="container">

<h1>Admin Dashboard</h1>

<!-- ============================================================ -->
<!-- CREATE CUSTOMER REPRESENTATIVES                              -->
<!-- ============================================================ -->
<div class="admin-card">
    <h2>Create Customer Representative</h2>

    <form action="createRep.jsp" method="POST">

        <label>Email</label>
        <input type="email" name="email" required />
		<p>
		<p>
        <label>Password</label>
        <input type="password" name="password" required />
		<p>
        <label>Region</label>
        <input type="text" name="region" required />
		<p>
        <button class="admin-btn" type="submit">Create Representative</button>
    </form>

    <!-- BACKEND DEV -->
    <!-- Query:
        INSERT INTO User (user_id, Email, Password, Role, Is_active)
        VALUES (?, ?, ?, 'customer_rep', TRUE);
        INSERT INTO Customer_Rep(rep_id, Region, hire_date, user_id, admin_id)
        VALUES (?, ?, NOW(), ?, ?);
    -->
</div>

<!-- ============================================================ -->
<!-- SALES REPORTS SECTION                                        -->
<!-- ============================================================ -->
<div class="admin-card">
    <h2>Sales Reports (you can display SQL here or have each button lead you to the display of the SQL table)</h2>

    <!-- TOTAL EARNINGS -->
    <form action="reportTotalEarnings.jsp" method="GET">
        <button class="admin-btn">Total Earnings</button>
    </form>

    <!-- EARNINGS PER ITEM -->
    <form action="reportEarningsPerItem.jsp" method="GET">
        <button class="admin-btn">Earnings Per Item</button>
    </form>

    <!-- EARNINGS PER ITEM TYPE -->
    <form action="reportEarningsPerType.jsp" method="GET">
        <button class="admin-btn">Earnings Per Item Type</button>
    </form>

    <!-- EARNINGS PER END-USER -->
    <form action="reportEarningsPerUser.jsp" method="GET">
        <button class="admin-btn">Earnings Per End-User</button>
    </form>

    <!-- BACKEND DEV NOTES:
        Total earnings:
        SELECT SUM(bid_amount) FROM Bid;
        
        Earnings per item:
        SELECT item_id, SUM(bid_amount) FROM Bid GROUP BY item_id;

        Earnings per item type:
        JOIN Item -> Category
        SELECT Category.name, SUM(bid_amount)
        FROM Bid JOIN Auction JOIN Item JOIN Category
        GROUP BY Category.name;

        Earnings per end-user:
        SELECT user_id, SUM(bid_amount) FROM Bid GROUP BY user_id;
    -->
</div>

<!-- ============================================================ -->
<!-- BEST SELLERS + BEST BUYERS                                   -->
<!-- ============================================================ -->
<div class="admin-card">
    <h2>Performance Reports(same with this)</h2>

    <!-- BEST-SELLING ITEMS -->
    <form action="reportBestSellingItems.jsp" method="GET">
        <button class="admin-btn">Best-Selling Items</button>
    </form>

    <!-- BEST BUYERS -->
    <form action="reportBestBuyers.jsp" method="GET">
        <button class="admin-btn">Best Buyers</button>
    </form>

    <!-- BACKEND DEV NOTES:
        Best-selling items:
        SELECT item_id, COUNT(*) FROM Bid GROUP BY item_id ORDER BY COUNT(*) DESC;

        Best buyers:
        SELECT user_id, SUM(bid_amount) AS total
        FROM Bid
        GROUP BY user_id
        ORDER BY total DESC;
    -->
</div>

<!-- ============================================================ -->
<!-- CUSTOMER SERVICE & ACCOUNT CONTROLS                         -->
<!-- ============================================================ -->
<div class="admin-card">
    <h2>Customer Service Tools</h2>

    <!-- Admin review questions -->
    <form action="adminQuestions.jsp">
        <button class="admin-btn">View All Customer Questions</button>
    </form>

    <!-- Remove auction -->
    <form action="adminRemoveAuction.jsp">
        <button class="admin-btn" style="background:#d9534f;">Remove Auctions</button>
    </form>

    <!-- Remove bids -->
    <form action="adminRemoveBids.jsp">
        <button class="admin-btn" style="background:#c9302c;">Remove Bids</button>
    </form>

    <!-- Account editing -->
    <form action="adminEditAccounts.jsp">
        <button class="admin-btn" style="background:#8a6d3b;">Edit User Accounts</button>
    </form>

</div>

</div>
</body>
</html>
