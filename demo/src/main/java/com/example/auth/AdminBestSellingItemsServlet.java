package com.example.auth;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;

@WebServlet("/admin/bestItems")
public class AdminBestSellingItemsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String sql =
            "SELECT I.Title, SUM(B.bid_amount) AS total " +
            "FROM Item I " +
            "JOIN Auction A ON I.item_id=A.item_id " +
            "JOIN Bid B ON A.auction_id=B.auction_id " +
            "GROUP BY I.Title ORDER BY total DESC";

        try (Connection cn = com.example.util.DBUtil.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            List<Map<String,Object>> list = new ArrayList<>();

            while (rs.next()) {
                Map<String,Object> m = new HashMap<>();
                m.put("title", rs.getString("Title"));
                m.put("total", rs.getInt("total"));
                list.add(m);
            }

            req.setAttribute("items", list);
            req.getRequestDispatcher("/adminBestItems.jsp").forward(req, resp);

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
