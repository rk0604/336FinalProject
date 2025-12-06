package com.example.auth;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;

@WebServlet("/admin/totalEarnings")
public class AdminTotalEarningsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Per-auction P/L:
        // revenue  = highest bid (0 if no bids)
        // profit   = revenue - start_price (0 if no bids)
        String sql =
                "SELECT A.auction_id, I.Title, A.start_price, " +
                "       MAX(B.bid_amount) AS highest_bid, " +
                "       CASE WHEN MAX(B.bid_amount) IS NULL THEN 0 " +
                "            ELSE MAX(B.bid_amount) END AS revenue, " +
                "       CASE WHEN MAX(B.bid_amount) IS NULL THEN 0 " +
                "            ELSE MAX(B.bid_amount) - A.start_price END AS profit " +
                "FROM Auction A " +
                "JOIN Item I ON A.item_id = I.item_id " +
                "LEFT JOIN Bid B ON A.auction_id = B.auction_id " +
                "GROUP BY A.auction_id, I.Title, A.start_price " +
                "ORDER BY A.auction_id";

        try (Connection cn = com.example.util.DBUtil.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            List<Map<String, Object>> rows = new ArrayList<>();
            int totalRevenue = 0;
            int totalProfit = 0;

            while (rs.next()) {
                int auctionId   = rs.getInt("auction_id");
                String title    = rs.getString("Title");
                int startPrice  = rs.getInt("start_price");
                int highestBid  = rs.getInt("highest_bid");   // 0 if NULL
                int revenue     = rs.getInt("revenue");       // 0 if NULL
                int profit      = rs.getInt("profit");        // 0 if NULL

                Map<String, Object> row = new HashMap<>();
                row.put("auctionId", auctionId);
                row.put("title", title);
                row.put("startPrice", startPrice);
                row.put("highestBid", highestBid);
                row.put("revenue", revenue);
                row.put("profit", profit);

                totalRevenue += revenue;
                totalProfit += profit;

                rows.add(row);
            }

            req.setAttribute("earningsRows", rows);
            req.setAttribute("totalRevenue", totalRevenue);
            req.setAttribute("totalProfit", totalProfit);

            req.getRequestDispatcher("/adminTotalEarnings.jsp").forward(req, resp);

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
