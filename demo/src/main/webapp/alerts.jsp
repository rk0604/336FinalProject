<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>My Alerts</title>
    <style>
        body { font-family: sans-serif; padding: 20px; }
        table { width: 100%; border-collapse: collapse; margin-top: 15px; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background: #f4f4f4; }
    </style>
</head>
<body>

<h1>My Alerts</h1>

<%
    List<Map<String,Object>> alerts =
        (List<Map<String,Object>>) request.getAttribute("alerts");
%>

<% if (alerts == null || alerts.isEmpty()) { %>
    <p>No alerts yet.</p>
<% } else { %>
    <table>
        <tr>
            <th>ID</th>
            <th>Type</th>
            <th>Min Price</th>
            <th>Max Price</th>
        </tr>
        <% for (Map<String,Object> a : alerts) { %>
        <tr>
            <td><%= a.get("alert_id") %></td>
            <td><%= a.get("key_word") %></td>
            <td><%= a.get("min_price") == null ? "" : a.get("min_price") %></td>
            <td><%= a.get("max_price") == null ? "" : a.get("max_price") %></td>
        </tr>
        <% } %>
    </table>
<% } %>

<p><a href="browseAuctions">Back to Auctions</a></p>

</body>
</html>
