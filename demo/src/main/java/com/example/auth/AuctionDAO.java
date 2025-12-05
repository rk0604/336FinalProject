package com.example.auth;

import com.example.util.DBUtil;
import java.sql.*;
import java.util.*;

public class AuctionDAO {

    // Create auction for item_id
    public int createAuction(int itemId, int userId, Timestamp start, Timestamp end,
                             int startPrice, int reservePrice) throws Exception {

        String sql = "INSERT INTO Auction (item_id, user_id, start_time, end_time, start_price, reserve_price, status) " +
                     "VALUES (?,?,?,?,?,?, 'active')";

        try (Connection cn = DBUtil.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, itemId);
            ps.setInt(2, userId);
            ps.setTimestamp(3, start);
            ps.setTimestamp(4, end);
            ps.setInt(5, startPrice);
            ps.setInt(6, reservePrice);

            ps.executeUpdate();

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        throw new RuntimeException("Failed to create auction");
    }

    // Load all active auctions for browsing
    public List<Map<String, Object>> getActiveAuctions() throws Exception {
        String sql =
            "SELECT A.auction_id, A.start_price, A.reserve_price, A.end_time, " +
            "I.item_id, I.Title, I.Description, I.Size, I.Brand, I.Color, I.Condition, " +
            "C.name AS category " +
            "FROM Auction A " +
            "JOIN Item I ON A.item_id = I.item_id " +
            "JOIN Category C ON I.cat_id = C.cat_id " +
            "WHERE A.status='active' " +
            "ORDER BY A.end_time ASC";

        List<Map<String,Object>> list = new ArrayList<>();

        try (Connection cn = DBUtil.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Map<String,Object> m = new HashMap<>();
                m.put("auction_id", rs.getInt("auction_id"));
                m.put("item_id", rs.getInt("item_id"));
                m.put("title", rs.getString("Title"));
                m.put("description", rs.getString("Description"));
                m.put("size", rs.getString("Size"));
                m.put("brand", rs.getString("Brand"));
                m.put("color", rs.getString("Color"));
                m.put("condition", rs.getString("Condition"));
                m.put("category", rs.getString("category"));
                m.put("start_price", rs.getInt("start_price"));
                m.put("reserve_price", rs.getInt("reserve_price"));
                m.put("end_time", rs.getTimestamp("end_time"));
                list.add(m);
            }
        }
        return list;
    }
}
