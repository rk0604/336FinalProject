<%@ page import="com.example.auth.CustomerRepDAO" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Remove Bids</title>
    <style>
        body { font-family: sans-serif; padding: 20px; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { padding: 10px; border: 1px solid #ddd; text-align: left; }
        th { background-color: #f4f4f4; }
        .btn-del { background-color: #dc3545; color: white; padding: 5px 10px; border: none; border-radius: 3px; cursor: pointer; }
        .back-btn { display: inline-block; margin-bottom: 20px; padding: 10px 15px; background: #666; color: white; text-decoration: none; border-radius: 5px; }
    </style>
</head>
<body>
    <a href="customerRepDashboard.jsp" class="back-btn">&larr; Back to Dashboard</a>
    <h1>Remove Bids</h1>

    <%
        CustomerRepDAO dao = new CustomerRepDAO();
        
        // Handle Delete Action
        String action = request.getParameter("action");
        if ("delete".equals(action)) {
            int bidId = Integer.parseInt(request.getParameter("id"));
            dao.deleteBid(bidId);
            out.println("<p style='color:green'>Bid removed.</p>");
        }

        List<Map<String, Object>> bids = dao.getAllBids();
    %>

    <table>
        <thead>
            <tr>
                <th>Bid ID</th>
                <th>Auction ID</th>
                <th>User Email</th>
                <th>Amount</th>
                <th>Time</th>
                <th>Action</th>
            </tr>
        </thead>
        <tbody>
            <% for (Map<String, Object> b : bids) { %>
            <tr>
                <td><%= b.get("bid_id") %></td>
                <td><%= b.get("auction_id") %></td>
                <td><%= b.get("email") %></td>
                <td>$<%= b.get("amount") %></td>
                <td><%= b.get("time") %></td>
                <td>
                    <form method="POST">
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" name="id" value="<%= b.get("bid_id") %>">
                        <button type="submit" class="btn-del">Remove</button>
                    </form>
                </td>
            </tr>
            <% } %>
        </tbody>
    </table>
</body>
</html>