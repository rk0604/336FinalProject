package com.example.auth;

import com.example.util.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class BidDAO {

    // Get highest bid amount for an auction
    public Integer getHighestBid(int auctionId) throws Exception {
        String sql = "SELECT MAX(bid_amount) AS maxBid FROM Bid WHERE auction_id=?";
        try (
            Connection cn = DBUtil.getConnection();
            PreparedStatement ps = cn.prepareStatement(sql)
        ) {
            ps.setInt(1, auctionId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int value = rs.getInt("maxBid");
                    if (rs.wasNull()) {
                        return null; // no bids
                    }
                    return value;
                }
                return null;
            }
        }
    }

    // Get highest bidder user_id for an auction
    public Integer getHighestBidderId(int auctionId) throws Exception {
        String sql =
            "SELECT user_id " +
            "FROM Bid " +
            "WHERE auction_id=? " +
            "ORDER BY bid_amount DESC, bid_time ASC " +
            "LIMIT 1";

        try (
            Connection cn = DBUtil.getConnection();
            PreparedStatement ps = cn.prepareStatement(sql)
        ) {
            ps.setInt(1, auctionId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("user_id");
                }
                return null;
            }
        }
    }

    // Distinct bidders on an auction, excluding a given user
    public List<Integer> getDistinctBiddersExcept(int auctionId, int excludeUserId) throws Exception {
        String sql = "SELECT DISTINCT user_id FROM Bid WHERE auction_id=? AND user_id<>?";
        List<Integer> list = new ArrayList<>();

        try (
            Connection cn = DBUtil.getConnection();
            PreparedStatement ps = cn.prepareStatement(sql)
        ) {
            ps.setInt(1, auctionId);
            ps.setInt(2, excludeUserId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(rs.getInt("user_id"));
                }
            }
        }
        return list;
    }

    // Place manual bid
    public int placeBid(int auctionId, int userId, int bidAmount) throws Exception {
        String sql = "INSERT INTO Bid (auction_id, user_id, bid_amount, Bid_time) VALUES (?,?,?, NOW())";

        try (
            Connection cn = DBUtil.getConnection();
            PreparedStatement ps = cn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)
        ) {
            ps.setInt(1, auctionId);
            ps.setInt(2, userId);
            ps.setInt(3, bidAmount);

            ps.executeUpdate();

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
            return -1;
        }
    }

    // Get bid history
    public List<Map<String, Object>> getBidHistory(int auctionId) throws Exception {
        String sql =
            "SELECT B.bid_amount, B.bid_time, U.Email " +
            "FROM Bid B JOIN User U ON B.user_id = U.user_id " +
            "WHERE B.auction_id=? " +
            "ORDER BY B.bid_amount DESC";

        List<Map<String, Object>> list = new ArrayList<>();

        try (
            Connection cn = DBUtil.getConnection();
            PreparedStatement ps = cn.prepareStatement(sql)
        ) {
            ps.setInt(1, auctionId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> m = new HashMap<>();
                    m.put("bid_amount", rs.getInt("bid_amount"));
                    m.put("bid_time", rs.getTimestamp("bid_time"));
                    m.put("email", rs.getString("Email"));
                    list.add(m);
                }
            }
        }
        return list;
    }
}
