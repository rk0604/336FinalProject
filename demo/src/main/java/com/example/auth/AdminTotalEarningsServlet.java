package com.example.auth;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.*;
import java.sql.*;

@WebServlet("/admin/totalEarnings")
public class AdminTotalEarningsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String sql = "SELECT SUM(bid_amount) AS earnings FROM Bid";

        try (Connection cn = com.example.util.DBUtil.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            rs.next();
            req.setAttribute("earnings", rs.getInt("earnings"));
            req.getRequestDispatcher("/adminTotalEarnings.jsp").forward(req, resp);

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
