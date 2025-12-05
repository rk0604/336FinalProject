package com.example.auth;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

public class LoginServlet extends HttpServlet {
  private Connection conn;

  @Override public void init() {
    try {
      Class.forName("com.mysql.cj.jdbc.Driver");
      conn = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/login_demo?useSSL=false&serverTimezone=UTC",
        "root","YOUR_PASSWORD");
    } catch (Exception e) { throw new RuntimeException(e); }
  }

  @Override protected void doPost(HttpServletRequest req, HttpServletResponse resp)
      throws ServletException, IOException {
    String u = req.getParameter("username");
    String p = req.getParameter("password");
    boolean ok = false;
    try (PreparedStatement st = conn.prepareStatement(
           "SELECT 1 FROM users WHERE username=? AND password_hash=?")) {
      st.setString(1,u); st.setString(2,p);
      try (ResultSet rs = st.executeQuery()) { ok = rs.next(); }
    } catch (SQLException e) { throw new ServletException(e); }

    if (ok) req.getSession(true).setAttribute("user", u);
    req.setAttribute("ok", ok);
    req.setAttribute("username", u);
    req.getRequestDispatcher("/result.jsp").forward(req, resp);
  }

  @Override public void destroy() {
    try { if (conn != null) conn.close(); } catch (SQLException ignored) {}
  }
}
