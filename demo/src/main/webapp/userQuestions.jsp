<%@ page import="com.example.auth.CustomerRepDAO" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>User Questions</title>
    <style>
        body { font-family: sans-serif; padding: 20px; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { padding: 10px; border: 1px solid #ddd; text-align: left; }
        th { background-color: #f4f4f4; }
        .back-btn { display: inline-block; margin-bottom: 20px; padding: 10px 15px; background: #666; color: white; text-decoration: none; border-radius: 5px; }
        .reply-btn { padding: 6px 12px; background: #007bff; color: white; border-radius: 4px; text-decoration: none; }
        .reply-btn:hover { background: #0056b3; }
    </style>
</head>
<body>

<a href="customerRepDashboard.jsp" class="back-btn">Back to Dashboard</a>
<h1>User Questions</h1>

<%
    CustomerRepDAO dao = new CustomerRepDAO();
    List<Map<String, Object>> questions = dao.getAllQuestions();
%>

<% if (questions.isEmpty()) { %>
    <p>No questions found.</p>
<% } else { %>

<table>
<thead>
<tr>
    <th>ID</th>
    <th>User Email</th>
    <th>Subject</th>
    <th>Message</th>
    <th>Status</th>
    <th>Answer</th>
    <th>Action</th>
</tr>
</thead>
<tbody>

<% for (Map<String, Object> q : questions) { %>
<tr>
    <td><%= q.get("qid") %></td>
    <td><%= q.get("email") %></td>
    <td><%= q.get("subject") %></td>
    <td><%= q.get("message") %></td>
    <td><%= q.get("status") %></td>
    <td><%= q.get("answer") == null ? "" : q.get("answer") %></td>
    <td>
        <% if (!"Resolved".equals(q.get("status"))) { %>
            <a class="reply-btn" href="replyQuestion.jsp?id=<%= q.get("qid") %>">Reply</a>
        <% } %>
    </td>
</tr>
<% } %>

</tbody>
</table>

<% } %>

</body>
</html>
