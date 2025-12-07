package com.example.auth;

import com.example.util.DBUtil;
import java.sql.*;          // Connection, PreparedStatement, ResultSet
import java.util.*;        // List, Map, ArrayList, HashMap

public class AlertDAO {

    // Used by SetAlertServlet and for simple alerts
    public void createAlert(int userId, String keyword, Integer minPrice, Integer maxPrice) throws Exception {
        String sql = "INSERT INTO Alert (user_id, key_word, min_price, max_price) VALUES (?,?,?,?)";

        try (
            Connection cn = DBUtil.getConnection();
            PreparedStatement ps = cn.prepareStatement(sql)
        ) {
            ps.setInt(1, userId);
            ps.setString(2, keyword);
            ps.setObject(3, minPrice);
            ps.setObject(4, maxPrice);
            ps.executeUpdate();
        }
    }

    public void createSimpleAlert(int userId, String keyword) throws Exception {
        createAlert(userId, keyword, null, null);
    }

    public List<Map<String, Object>> getAlertsForUser(int userId) throws Exception {
        String sql =
            "SELECT alert_id, key_word, min_price, max_price " +
            "FROM Alert WHERE user_id=? ORDER BY alert_id DESC";

        List<Map<String, Object>> list = new ArrayList<>();

        try (
            Connection cn = DBUtil.getConnection();
            PreparedStatement ps = cn.prepareStatement(sql)
        ) {
            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> m = new HashMap<>();
                    m.put("alert_id", rs.getInt("alert_id"));
                    m.put("key_word", rs.getString("key_word"));
                    m.put("min_price", rs.getObject("min_price"));
                    m.put("max_price", rs.getObject("max_price"));
                    list.add(m);
                }
            }
        }
        return list;
    }

    /**
     * When a new auction is created, call this to notify users whose saved alerts
     * match the new item (keyword + optional min/max price).
     *
     * We treat alerts with keywords "Outbid", "AutoBidLimitExceeded", "AuctionWon"
     * as system alerts and ignore them for matching.
     */
    public void notifyItemAlertsForAuction(int auctionId) throws Exception {
        String sql =
            "SELECT DISTINCT A.user_id, I.Title " +
            "FROM Auction AU " +
            "JOIN Item I ON AU.item_id = I.item_id " +
            "JOIN Alert A ON " +
            "  (I.Title       LIKE CONCAT('%', A.key_word, '%') " +
            "    OR I.Description LIKE CONCAT('%', A.key_word, '%') " +
            "    OR I.Brand       LIKE CONCAT('%', A.key_word, '%')) " +
            "  AND (A.min_price IS NULL OR AU.start_price >= A.min_price) " +
            "  AND (A.max_price IS NULL OR AU.start_price <= A.max_price) " +
            "WHERE AU.auction_id = ? " +
            "  AND A.key_word NOT IN ('Outbid','AutoBidLimitExceeded','AuctionWon')";

        try (
            Connection cn = DBUtil.getConnection();
            PreparedStatement ps = cn.prepareStatement(sql)
        ) {
            ps.setInt(1, auctionId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    int userId = rs.getInt("user_id");
                    String title = rs.getString("Title");

                    // Insert a notification alert row for this user.
                    // The message they see in My Alerts will look like:
                    // "ItemAvailable: Nintendo Switch"
                    createAlert(userId, "ItemAvailable: " + title, null, null);
                }
            }
        }
    }
}
