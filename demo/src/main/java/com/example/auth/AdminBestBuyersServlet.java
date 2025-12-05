package com.example.auth;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;

@WebServlet("/admin/bestBuyers")
public class AdminBestBuyersServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String sql =
            "SELECT U.Email, SUM(B.bid_amount) AS total " +
            "FROM Bid B JOIN User U ON B.user_id = U.user_id " +
            "GROUP BY U.Email ORDER BY total DESC";

        try (Connection cn = com.example.util.DBUtil.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            List<Map<String,Object>> list = new ArrayList<>();

            while (rs.next()) {
                Map<String,Object> m = new HashMap<>();
                m.put("email", rs.getString("Email"));
                m.put("total", rs.getInt("total"));
                list.add(m);
            }

            req.setAttribute("buyers", list);
            req.getRequestDispatcher("/adminBestBuyers.jsp").forward(req, resp);

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
