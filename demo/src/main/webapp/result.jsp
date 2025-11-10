<!DOCTYPE html>
<html>
<head><meta charset="UTF-8"><title>Result</title></head>
<body>
  <h3><%= request.getAttribute("message") %></h3>
  <%
    Object email = (session != null) ? session.getAttribute("email") : null;
    if (email != null) {
  %>
      <p>You are logged in as: <%= email %></p>
      <a href="<%=request.getContextPath()%>/logout">Logout</a>
  <%
    } else {
  %>
      <a href="<%=request.getContextPath()%>/">Back to login</a>
  <%
    }
  %>
</body>
</html>
