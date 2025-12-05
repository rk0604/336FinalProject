<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<html>
<head>
    <title>Customer Service Dashboard</title>

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

    .navbar-inverse .navbar-brand {
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

    h1, h2 {
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
        width: 100%;
        font-size: 16px;
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
            <a class="navbar-brand" href="#">
                Auction System – Customer Service
            </a>
        </div>
    </div>
</nav>

<div class="container">

<h1>Customer Service Dashboard</h1>


<!-- CUSTOMER SERVICE TOOLS (4 BUTTONS ONLY)                     -->

<div class="admin-card">
    <h2>Customer Service Tools</h2>

    <!-- USER QUESTIONS -->
    <form action="userQuestions.jsp" method="GET">
        <button class="admin-btn">User Questions</button>
    </form>

    <!-- EDIT OR DELETE USER ACCOUNTS -->
    <form action="editDeleteUsers.jsp" method="GET">
        <button class="admin-btn" style="background:#8a6d3b;">
            Edit or Delete User Accounts
        </button>
    </form>

    <!-- REMOVE BIDS -->
    <form action="removeBids.jsp" method="GET">
        <button class="admin-btn" style="background:#c9302c;">
            Remove Bids
        </button>
    </form>

    <!-- REMOVE AUCTIONS -->
    <form action="removeAuctions.jsp" method="GET">
        <button class="admin-btn" style="background:#d9534f;">
            Remove Auctions
        </button>
    </form>

</div>

</div>
</body>
</html>
