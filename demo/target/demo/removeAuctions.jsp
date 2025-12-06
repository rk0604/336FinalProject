<%@ page import="com.example.auth.CustomerRepDAO" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Remove Auctions</title>
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
    <h1>Remove Auctions</h1>

    <%
        CustomerRepDAO dao = new CustomerRepDAO();
        
        // Handle Delete Action
        String action = request.getParameter("action");
        if ("delete".equals(action)) {
            int aid = Integer.parseInt(request.getParameter("id"));
            dao.deleteAuction(aid);
            out.println("<p style='color:green'>Auction removed.</p>");
        }

        List<Map<String, Object>> auctions = dao.getAllAuctions();
    %>

    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Item Title</th>
                <th>Seller</th>
                <th>Price</th>
                <th>Condition</th>
                <th>Status</th>
                <th>Action</th>
            </tr>
        </thead>
        <tbody>
            <% for (Map<String, Object> a : auctions) { %>
            <tr>
                <td><%= a.get("auction_id") %></td>
                <td><%= a.get("title") %></td>
                <td><%= a.get("seller") %></td>
                <td>$<%= a.get("price") %></td>
                <td><%= a.get("condition") %></td> <!-- Uses Item_Condition -->
                <td><%= a.get("status") %></td>
                <td>
                    <form method="POST" onsubmit="return confirm('Delete this auction?');">
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" name="id" value="<%= a.get("auction_id") %>">
                        <button type="submit" class="btn-del">Remove</button>
                    </form>
                </td>
            </tr>
            <% } %>
        </tbody>
    </table>
</body>
</html>