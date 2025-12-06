package com.example.auth;

import com.example.util.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class AuctionDAO {

    // Create auction for item_id
    public int createAuction(int itemId, int userId, Timestamp start, Timestamp end,
                             int startPrice, int reservePrice) throws Exception {

        String sql =
            "INSERT INTO Auction " +
            "(item_id, user_id, start_time, end_time, start_price, reserve_price, status) " +
            "VALUES (?,?,?,?,?,?, 'active')";

        try (
            Connection cn = DBUtil.getConnection();
            PreparedStatement ps = cn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)
        ) {
            ps.setInt(1, itemId);
            ps.setInt(2, userId);
            ps.setTimestamp(3, start);
            ps.setTimestamp(4, end);
            ps.setInt(5, startPrice);
            ps.setInt(6, reservePrice);

            ps.executeUpdate();

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        throw new RuntimeException("Failed to create auction");
    }

    // Close all auctions whose end_time has passed and status is still 'active'
    public void closeExpiredAuctions() throws Exception {
        String selectSql =
            "SELECT auction_id, reserve_price " +
            "FROM Auction " +
            "WHERE status='active' AND end_time <= NOW()";

        try (
            Connection cn = DBUtil.getConnection();
            PreparedStatement selectPs = cn.prepareStatement(selectSql);
            ResultSet rs = selectPs.executeQuery()
        ) {
            BidDAO bidDao = new BidDAO();
            AlertDAO alertDao = new AlertDAO();

            while (rs.next()) {
                int auctionId = rs.getInt("auction_id");
                int reservePrice = rs.getInt("reserve_price");

                Integer highestBid = bidDao.getHighestBid(auctionId);

                if (highestBid == null) {
                    // No bids at all
                    try (PreparedStatement upd = cn.prepareStatement(
                        "UPDATE Auction SET status='closed_no_bids' WHERE auction_id=?")) {
                        upd.setInt(1, auctionId);
                        upd.executeUpdate();
                    }
                } else if (highestBid < reservePrice) {
                    // Reserve higher than last bid -> no winner
                    try (PreparedStatement upd = cn.prepareStatement(
                        "UPDATE Auction SET status='closed_reserve_not_met', final_price=? WHERE auction_id=?")) {
                        upd.setInt(1, highestBid);
                        upd.setInt(2, auctionId);
                        upd.executeUpdate();
                    }
                } else {
                    // Reserve met or exceeded -> highest bidder is winner
                    Integer winnerId = bidDao.getHighestBidderId(auctionId);

                    try (PreparedStatement upd = cn.prepareStatement(
                        "UPDATE Auction SET status='closed_sold', winner_user_id=?, final_price=? WHERE auction_id=?")) {
                        upd.setInt(1, winnerId);
                        upd.setInt(2, highestBid);
                        upd.setInt(3, auctionId);
                        upd.executeUpdate();
                    }

                    // Alert the winner that they won
                    if (winnerId != null) {
                        alertDao.createSimpleAlert(winnerId, "AuctionWon");
                    }
                }
            }
        }
    }

    // Backwards-compatible: used if someone still calls this with no filters
    public List<Map<String, Object>> getActiveAuctions() throws Exception {
        return getActiveAuctionsFiltered(null, null, null);
    }

    /**
     * Load all active auctions for browsing with optional keyword, category filter and sort.
     *
     * @param keyword  text to match against title / description / brand (nullable)
     * @param category exact category name from Category table (nullable)
     * @param sort     one of: "endingSoon", "priceAsc", "priceDesc", "title"; nullable
     */
    public List<Map<String, Object>> getActiveAuctionsFiltered(
            String keyword, String category, String sort) throws Exception {

        // Always close expired auctions before listing
        closeExpiredAuctions();

        StringBuilder sql = new StringBuilder(
            "SELECT A.auction_id, A.start_price, A.reserve_price, A.end_time, " +
            "       I.item_id, I.Title, I.Description, I.Size, I.Brand, I.Color, I.Item_Condition, " +
            "       C.name AS category " +
            "FROM Auction A " +
            "JOIN Item I ON A.item_id = I.item_id " +
            "JOIN Category C ON I.cat_id = C.cat_id " +
            "WHERE A.status='active' "
        );

        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.isEmpty()) {
            sql.append("AND (I.Title LIKE ? OR I.Description LIKE ? OR I.Brand LIKE ?) ");
            String pattern = "%" + keyword + "%";
            params.add(pattern);
            params.add(pattern);
            params.add(pattern);
        }

        if (category != null && !category.isEmpty() && !"all".equalsIgnoreCase(category)) {
            sql.append("AND C.name = ? ");
            params.add(category);
        }

        // Sorting
        String orderBy;
        if ("priceAsc".equalsIgnoreCase(sort)) {
            orderBy = "A.start_price ASC";
        } else if ("priceDesc".equalsIgnoreCase(sort)) {
            orderBy = "A.start_price DESC";
        } else if ("title".equalsIgnoreCase(sort)) {
            orderBy = "I.Title ASC";
        } else {
            // default: ending soon first
            orderBy = "A.end_time ASC";
        }
        sql.append("ORDER BY ").append(orderBy);

        List<Map<String, Object>> list = new ArrayList<>();

        try (
            Connection cn = DBUtil.getConnection();
            PreparedStatement ps = cn.prepareStatement(sql.toString())
        ) {
            // Bind parameters in order
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> m = new HashMap<>();
                    m.put("auction_id", rs.getInt("auction_id"));
                    m.put("item_id", rs.getInt("item_id"));
                    m.put("title", rs.getString("Title"));
                    m.put("description", rs.getString("Description"));
                    m.put("size", rs.getString("Size"));
                    m.put("brand", rs.getString("Brand"));
                    m.put("color", rs.getString("Color"));
                    m.put("condition", rs.getString("Item_Condition"));
                    m.put("category", rs.getString("category"));
                    m.put("start_price", rs.getInt("start_price"));
                    m.put("reserve_price", rs.getInt("reserve_price"));
                    m.put("end_time", rs.getTimestamp("end_time"));
                    list.add(m);
                }
            }
        }
        return list;
    }

    // For populating the category dropdown on the browse page
    public List<String> getAllCategories() throws Exception {
        String sql = "SELECT name FROM Category ORDER BY name ASC";
        List<String> categories = new ArrayList<>();

        try (
            Connection cn = DBUtil.getConnection();
            PreparedStatement ps = cn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery()
        ) {
            while (rs.next()) {
                categories.add(rs.getString("name"));
            }
        }
        return categories;
    }
}
