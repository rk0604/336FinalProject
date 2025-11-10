<!DOCTYPE html>
<html>
<head><meta charset="UTF-8"><title>Login</title></head>
<body>
  <h2>Login</h2>
  <form method="post" action="<%=request.getContextPath()%>/login">
    <label>Email: <input name="email" required></label><br>
    <label>Password: <input name="password" type="password" required></label><br>
    <button type="submit">Log in</button>
  </form>
</body>
</html>
