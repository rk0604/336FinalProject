<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head><title>Bid History</title></head>
<body>
<h2>Bid History</h2>

<%
    List<Map<String,Object>> history =
        (List<Map<String,Object>>) request.getAttribute("history");

    if (history == null || history.isEmpty()) {
%>
    <p>No bids yet for this auction.</p>
<%
    } else {
%>
    <table border="1" cellpadding="5" cellspacing="0">
        <tr>
            <th>Bidder</th>
            <th>Amount</th>
            <th>Time</th>
        </tr>
        <%
            for (Map<String,Object> m : history) {
        %>
        <tr>
            <td><%= m.get("email") %></td>
            <td>$<%= m.get("bid_amount") %></td>
            <td><%= m.get("bid_time") %></td>
        </tr>
        <%
            }
        %>
    </table>
<%
    }
%>

<p><a href="browseAuctions">Back to Auctions</a></p>
</body>
</html>
