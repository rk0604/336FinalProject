package com.example.auth;

import com.example.util.DBUtil;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class AutoBidDAO {

    // Simple holder for an auto-bidder
    public static class AutoBidEntry {
        private final int userId;
        private final int maxBidAmount;

        public AutoBidEntry(int userId, int maxBidAmount) {
            this.userId = userId;
            this.maxBidAmount = maxBidAmount;
        }

        public int getUserId() {
            return userId;
        }

        public int getMaxBidAmount() {
            return maxBidAmount;
        }
    }

    // Create or update auto-bid
    public void setAutoBid(int userId, int auctionId, int maxAmount) throws Exception {
        String sql =
            "INSERT INTO Auto_Bid (user_id, auction_id, max_bid_amount, created_at) " +
            "VALUES (?,?,?, NOW()) " +
            "ON DUPLICATE KEY UPDATE max_bid_amount=?";

        try (
            Connection cn = DBUtil.getConnection();
            PreparedStatement ps = cn.prepareStatement(sql)
        ) {
            ps.setInt(1, userId);
            ps.setInt(2, auctionId);
            ps.setInt(3, maxAmount);
            // For ON DUPLICATE KEY UPDATE max_bid_amount=?
            ps.setInt(4, maxAmount);
            ps.executeUpdate();
        }
    }

    // Get max auto-bid amount for a single user and auction
    public Integer getMaxAutoBid(int userId, int auctionId) throws Exception {
        String sql = "SELECT max_bid_amount FROM Auto_Bid WHERE user_id=? AND auction_id=?";

        try (
            Connection cn = DBUtil.getConnection();
            PreparedStatement ps = cn.prepareStatement(sql)
        ) {
            ps.setInt(1, userId);
            ps.setInt(2, auctionId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("max_bid_amount");
                }
                return null;
            }
        }
    }

    // All auto-bidders on an auction whose max is below the given amount
    public List<Integer> getUsersWithMaxBelow(int auctionId, int amount) throws Exception {
        String sql = "SELECT user_id FROM Auto_Bid WHERE auction_id=? AND max_bid_amount < ?";
        List<Integer> list = new ArrayList<>();

        try (
            Connection cn = DBUtil.getConnection();
            PreparedStatement ps = cn.prepareStatement(sql)
        ) {
            ps.setInt(1, auctionId);
            ps.setInt(2, amount);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(rs.getInt("user_id"));
                }
            }
        }
        return list;
    }

    // Find the best auto-bidder to counter a manual bid:
    // highest max_bid_amount > currentBid, excluding the user who just bid.
    public AutoBidEntry findBestAutoBidder(int auctionId, int currentBid, int excludeUserId) throws Exception {
        String sql =
            "SELECT user_id, max_bid_amount " +
            "FROM Auto_Bid " +
            "WHERE auction_id=? AND user_id<>? AND max_bid_amount > ? " +
            "ORDER BY max_bid_amount DESC " +
            "LIMIT 1";

        try (
            Connection cn = DBUtil.getConnection();
            PreparedStatement ps = cn.prepareStatement(sql)
        ) {
            ps.setInt(1, auctionId);
            ps.setInt(2, excludeUserId);
            ps.setInt(3, currentBid);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int userId = rs.getInt("user_id");
                    int max = rs.getInt("max_bid_amount");
                    return new AutoBidEntry(userId, max);
                }
                return null;
            }
        }
    }
}
