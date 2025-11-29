<%@ page import="java.sql.*, javax.sql.*, java.util.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<html>
<head>
    <title>Bidding Page</title>

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
    }

    form {
        border-radius: 8px;
    }

    label {
        display: block;
        margin-top: 12px;
        font-weight: bold;
    }

    input, textarea {
        width: 100%;
        padding: 10px;
        margin-top: 5px;
        border: 1px solid #bdc3c7;
        border-radius: 6px;
        font-size: 14px;
    }

    /* Auction Cards */
    .auction-card {
        border: 1px solid #d8d8d8;
        padding: 20px;
        border-radius: 10px;
        margin-bottom: 20px;
        background: #ffffff;
        display: flex;
        justify-content: space-between;
    }

	.auction-tools {
    display: flex;
    flex-wrap: wrap;
    gap: 8px;
    margin-top: 10px;
}

.auction-tools form {
    margin: 0;
}
		
    .auction-info {
        max-width: 65%;
    }

    .bid-section input {
        margin-bottom: 10px;
    }

    .auction-tools button,
    .qna-tools button {
        padding: 6px 10px;
        border-radius: 4px;
        color: white;
        border: none;
        margin-right: 5px;
        font-size: 13px;
    }
	.auction-tools {
	    display: flex;
	    flex-wrap: wrap;
	    margin-top: 10px;
	}
	
	.auction-tools form {
	    margin: 0;
	    display: inline-block;
	}
    	
</style>
</head>

<body>

<nav class="navbar navbar-inverse">
    <div class="container-fluid">
        <div class="navbar-header">
            <a class="navbar-brand" href="#">Auction System</a>
        </div>
    </div>
</nav>

<div class="container">

<%
    String role = (String) session.getAttribute("role");
    if (role == null) role = "buyer";
%>

<h1>Bidding Page</h1>

<!-- ============================================================ -->
<!-- ADVANCED SEARCH + FILTERS + SORTING                         -->
<!-- ============================================================ -->

<% if(role.equals("buyer")) { %>

<h2>Browse Active Auctions</h2>

<div style="background:#eef2f5; padding:15px; border-radius:8px; margin-bottom:25px;">

    <!-- SEARCH BAR -->
    <form method="GET" action="biddingpage.jsp" style="display:flex;">
        <input type="text" name="keyword" placeholder="Search items, keywords, brands..."
               style="flex:1; padding:10px; border-radius:6px; border:1px solid #ccc;">

        <button type="submit"
                style="padding:10px 18px; background:#2980b9; color:white; border:none; border-radius:6px;">
            Search
        </button>
    </form>

    <!-- SORT + CATEGORY + PRICE FILTERS -->

    <div style="display:flex; gap:15px;">

        <!-- SORT -->
        <form method="GET" action="biddingpage.jsp">
          <select name="sort" style="padding:8px; border-radius:6px;">
              <option value="">Sort By</option>
              <option value="price_low">Price: Low to High</option>
              <option value="price_high">Price: High to Low</option>
              <option value="ending_soon">Ending Soon</option>
          </select>
        </form>

        <!-- CATEGORY (backend should generate categories) -->
        <form method="GET" action="biddingpage.jsp">
          <select name="category" style="padding:8px; border-radius:6px;">
              <option value="">Filter by Category</option>
              <option value="1">Electronics</option>
              <option value="2">Fashion</option>
              <option value="3">Home Items</option>
          </select>
        </form>

        <!-- PRICE RANGE -->
        <form method="GET" action="biddingpage.jsp" style="display:flex; gap:8px;">
            <input type="number" name="min" placeholder="Min $" style="width:90px;">
            <input type="number" name="max" placeholder="Max $" style="width:90px;">
        </form>
    </div>

</div>


<!-- ============================================================ -->
<!-- BEGIN AUCTION ITEM LOOP                                     -->
<!-- ============================================================ -->

<%
    for(int i = 1; i <= 3; i++) {
%>

<div class="auction-card">

    <!-- ITEM INFO -->
    <div class="auction-info">
        <h3>Item Placeholder <%= i %></h3>
        <p><b>Description:</b> A sample auction item.</p>
        <p><b>Starting Price:</b> $100</p>
        <p><b>Status:</b> Active</p>
        <p><b>Ends:</b> 2025-12-01 12:00:00</p>

	<div class="auction-tools">
	
	    <!-- BID HISTORY -->
	    <form action="viewBids.jsp" method="GET">
	        <input type="hidden" name="auction_id" value="<%= i %>">
	        <button style="background:#6c7ae0;">Bid History</button>
	    </form>
	
	    <!-- USER PARTICIPATION -->
	    <form action="userAuctions.jsp" method="GET">
	        <input type="hidden" name="auction_id" value="<%= i %>">
	        <button style="background:#3c8dbc;">User Activity</button>
	    </form>
	
	    <!-- SIMILAR ITEMS -->
	    <form action="similarItems.jsp" method="GET">
	        <input type="hidden" name="auction_id" value="<%= i %>">
	        <button style="background:#5cb85c;">Similar Items</button>
	    </form>
	
	    <!-- SET ITEM ALERT -->
	    <form action="setItemAlert.jsp" method="POST">
	        <input type="hidden" name="auction_id" value="<%= i %>">
	        <button style="background:#d9534f;">Alert Me</button>
	    </form>
	</div>
		
    </div>

    <!-- BID INPUTS -->
    <div class="bid-section" style="display:flex; flex-direction:column;">

        <input class="bid-input"
               type="number"
               id="shared_bid_input_<%= i %>"
               placeholder="Enter Amount ($)"
               required />

        <!-- BUTTON ROW -->
        <div style="display:flex; gap:10px;">

            <!-- MANUAL BID -->
            <form action="placeBid.jsp" method="POST" style="margin:0;">
                <input type="hidden" name="auction_id" value="<%= i %>"/>
                <input type="hidden" name="bid_amount" id="manual_bid_<%= i %>" />
                <button class="bid-btn"
                        style="width:120px;"
                        onclick="document.getElementById('manual_bid_<%= i %>').value =
                                  document.getElementById('shared_bid_input_<%= i %>').value;">
                    Manual Bid
                </button>
            </form>

            <!-- AUTO BID -->
            <form action="setAutoBid.jsp" method="POST" style="margin:0;">
                <input type="hidden" name="auction_id" value="<%= i %>"/>
                <input type="hidden" name="max_bid" id="auto_bid_<%= i %>" />

                <button class="bid-btn"
                        style="width:120px; background:#1e7ec8;"
                        onclick="document.getElementById('auto_bid_<%= i %>').value =
                                  document.getElementById('shared_bid_input_<%= i %>').value;">
                    Auto Bid
                </button>
            </form>

        </div>

    </div>
</div>

<% } %> 

<hr>

<!-- ============================================================ -->
<!-- QUESTIONS & ANSWERS SECTION                                 -->
<!-- ============================================================ -->

<h2>Questions and Answers</h2>

<div class="qna-tools" style="margin-bottom:20px;">

    <form action="browseQuestions.jsp" style="display:inline;">
        <button style="background:#2980b9;">Browse QnA</button>
    </form>

    <form action="searchQuestions.jsp" style="display:inline;">
        <button style="background:#1e7ec8;">Search QnA</button>
    </form>

    <form action="askQuestion.jsp" style="display:inline;">
        <button style="background:#5cb85c;">Ask Question</button>
    </form>
</div>

<% } %>

<!-- ============================================================ -->
<!-- SELLER CREATE ITEM + AUCTION                                -->
<!-- ============================================================ -->

<% if(role.equals("seller")) { %>

<h2>Create New Item and Auction</h2>
<form action="createAuction.jsp" method="POST">

    <h3>Item Details</h3>
    <label>Title</label><input type="text" name="title" />
    <label>Description</label><textarea name="description"></textarea>
    <label>Category ID</label><input type="number" name="cat_id" />
    <label>Size</label><input type="text" name="size" />
    <label>Brand</label><input type="text" name="brand" />
    <label>Color</label><input type="text" name="color" />
    <label>Condition</label><input type="text" name="condition" />

    <h3>Auction Details</h3>
    <label>Start Time</label><input type="datetime-local" name="start_time" />
    <label>End Time</label><input type="datetime-local" name="end_time" />
    <label>Start Price</label><input type="number" name="start_price" />
    <label>Reserve Price (Hidden)</label><input type="number" name="reserve_price" />

    <button type="submit">Create Auction</button>
</form>

<% } %>

</div>
</body>
</html>
