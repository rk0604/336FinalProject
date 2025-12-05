package com.example.auth;

import com.example.util.DBUtil;
import java.sql.*;

public class AutoBidDAO {

    // Create or update auto-bid
    public void setAutoBid(int userId, int auctionId, int maxAmount) throws Exception {
        String sql =
            "INSERT INTO Auto_Bid (user_id, auction_id, max_bid_amount) " +
            "VALUES (?,?,?) " +
            "ON DUPLICATE KEY UPDATE max_bid_amount=?";

        try (Connection cn = DBUtil.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setInt(2, auctionId);
            ps.setInt(3, maxAmount);
            ps.setInt(4, maxAmount);

            ps.executeUpdate();
        }
    }

    // Get max auto-bid amount
    public Integer getMaxAutoBid(int userId, int auctionId) throws Exception {
        String sql = "SELECT max_bid_amount FROM Auto_Bid WHERE user_id=? AND auction_id=?";

        try (Connection cn = DBUtil.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setInt(2, auctionId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt("max_bid_amount");
                return null;
            }
        }
    }
}
