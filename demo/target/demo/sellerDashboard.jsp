<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<html>
<head>
    <title>Seller Dashboard</title>

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

    .seller-card {
        border: 1px solid #d8d8d8;
        padding: 20px;
        background: #fff;
        border-radius: 10px;
        margin-bottom: 25px;
    }

    label {
        display: block;
        margin-top: 10px;
        font-weight: bold;
    }

    input, textarea, select {
        width: 100%;
        padding: 8px;
        margin-top: 5px;
        border-radius: 6px;
        border: 1px solid #bdc3c7;
        font-size: 14px;
    }

    .seller-btn {
        padding: 10px 14px;
        border-radius: 6px;
        background:#2980b9;
        color:white;
        border:none;
        margin-top:15px;
        font-size: 15px;
    }

    .seller-btn:hover {
        background:#1f6391;
    }

    .seller-btn-danger {
        background:#d9534f;
    }

    .seller-btn-danger:hover {
        background:#c9302c;
    }

    .auction-row {
        border-top: 1px solid #e0e0e0;
        padding-top: 10px;
        margin-top: 10px;
    }

    .auction-meta {
        font-size: 13px;
        color: #555;
    }
</style>

</head>

<body>

<!-- NAVBAR -->
<nav class="navbar navbar-inverse">
    <div class="container-fluid">
        <div class="navbar-header">
            <a class="navbar-brand" href="#">Auction System – Seller</a>
        </div>
    </div>
</nav>

<div class="container">

<h1>Seller Dashboard</h1>

<%
%>


<div class="seller-card">
    <h2>Create New Auction</h2>

    <form action="createAuction.jsp" method="POST">
        <h3>Item Details</h3>

        <label>Title</label>
        <input type="text" name="title" placeholder="e.g. Used Laptop, 15 inch" required />

        <label>Description</label>
        <textarea name="description" rows="3"
                  placeholder="Describe condition, features, accessories..."></textarea>

        <label>Category</label>
        <select name="cat_id" required>
            <option value="">Select Category</option>
            <!-- BACKEND: populate from Category table
                 SELECT cat_id, name FROM Category; -->
            <option value="1">Electronics</option>
            <option value="2">Fashion</option>
            <option value="3">Home</option>
        </select>

        <label>Size</label>
        <input type="text" name="size" placeholder="e.g. 15 inches" />

        <label>Brand</label>
        <input type="text" name="brand" placeholder="e.g. HP, Apple, Samsung" />

        <label>Color</label>
        <input type="text" name="color" placeholder="e.g. Black, Silver" />

        <label>Condition</label>
        <input type="text" name="condition" placeholder="e.g. New, Like New, Good, Fair" />

        <h3>Auction Details</h3>

        <label>Start Time</label>
        <input type="datetime-local" name="start_time" required />

        <label>End Time</label>
        <input type="datetime-local" name="end_time" required />

        <label>Starting Price ($)</label>
        <input type="number" name="start_price" min="0" step="1" required />

        <label>Reserve Price (Hidden, $)</label>
        <input type="number" name="reserve_price" min="0" step="1" required />

        <button class="seller-btn" type="submit">Create Auction</button>

        <!-- BACKEND DEV NOTES:
             1) Insert item:
                INSERT INTO Item(item_id, user_id, cat_id, Title, Description,
                                 Size, Brand, Color, Condition)
                VALUES (?,?,?, ?,?,?, ?,?,?);

             2) Insert auction:
                INSERT INTO Auction(auction_id, item_id, user_id, start_time, end_time,
                                    start_price, status, reserve_price)
                VALUES (?,?,?, ?,?, ?, 'active', ?);
        -->
    </form>
</div>


<div class="seller-card">
    <h2>My Active Auctions</h2>

    <!-- BACKEND DEV:
         Replace this loop with ResultSet:

         SELECT a.auction_id, i.Title, a.start_price, a.end_time,
                MAX(b.bid_amount) AS highest_bid
         FROM Auction a
         JOIN Item i ON a.item_id = i.item_id
         LEFT JOIN Bid b ON a.auction_id = b.auction_id
         WHERE a.user_id = :seller_id
           AND a.status = 'active'
         GROUP BY a.auction_id, i.Title, a.start_price, a.end_time;
    -->

    <%
        // Demo: pretend seller has 2 auctions
        for(int i = 1; i <= 2; i++) {
    %>

    <div class="auction-row">
        <h3>Auction #<%= i %> – Example Item Title</h3>
        <p class="auction-meta">
            Starting Price: $200<br/>
            Current Highest Bid: $260<br/>
            Ends: 2025-12-01 12:00:00
        </p>

  
        <form action="viewBids.jsp" method="GET" style="display:inline-block; margin-right:10px;">
            <input type="hidden" name="auction_id" value="<%= i %>" />
            <button class="seller-btn" type="submit">View Bid History</button>
        </form>


        <form action="closeAuction.jsp" method="POST" style="display:inline-block;">
            <input type="hidden" name="auction_id" value="<%= i %>" />
            <button class="seller-btn seller-btn-danger" type="submit">
                Close Auction Now
            </button>
        </form>

        <!-- BACKEND DEV:
             When auction reaches end_time OR seller closes early:
             1) Get highest bid:
                SELECT user_id, bid_amount
                FROM Bid
                WHERE auction_id = ?
                ORDER BY bid_amount DESC
                LIMIT 1;

             2) Get reserve:
                SELECT reserve_price FROM Auction WHERE auction_id = ?;

             3) Compare:
                IF highest_bid < reserve_price → no winner.
                ELSE highest_bidder_id is winner.

             4) Insert winner alert:
                INSERT INTO Alert(user_id, alert_id, key_word)
                VALUES (?, ?, 'winner');
        -->
    </div>

    <% } %>

</div>

<div class="seller-card">
    <h2>Closed Auctions and Winners</h2>

    <!-- BACKEND DEV:
         Query suggestion:

         SELECT a.auction_id, i.Title,
                MAX(b.bid_amount) AS highest_bid,
                a.reserve_price,
                CASE
                  WHEN MAX(b.bid_amount) IS NULL THEN 'No bids'
                  WHEN MAX(b.bid_amount) < a.reserve_price THEN 'Reserve not met'
                  ELSE 'Winner determined'
                END AS result_status
         FROM Auction a
         JOIN Item i ON a.item_id = i.item_id
         LEFT JOIN Bid b ON a.auction_id = b.auction_id
         WHERE a.user_id = :seller_id
           AND a.status = 'closed'
         GROUP BY a.auction_id, i.Title, a.reserve_price;
    -->

  
    <div class="auction-row">
        <h3>Auction #10 – Example Closed Item</h3>
        <p class="auction-meta">
            Highest Bid: $300<br/>
            Reserve: $250<br/>
            Result: Winner determined
        </p>

        <form action="viewWinnerDetails.jsp" method="GET">
            <input type="hidden" name="auction_id" value="10" />
            <button class="seller-btn" type="submit">View Winner Details</button>
        </form>
    </div>

    <div class="auction-row">
        <h3>Auction #11 – Example Closed Item</h3>
        <p class="auction-meta">
            Highest Bid: $180<br/>
            Reserve: $250<br/>
            Result: Reserve not met (no winner)
        </p>
    </div>

</div>

</div> 

</body>
</html>
