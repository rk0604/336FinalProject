package com.example.auth;

import com.example.util.DBUtil;
import java.sql.*;
import java.util.*;

public class CustomerRepDAO {

    // ------------------------------------------------------------
    // 1. USER QUESTIONS
    // ------------------------------------------------------------

    public List<Map<String, Object>> getAllQuestions() {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT Q.*, U.Email FROM Customer_Question Q JOIN User U ON Q.user_id = U.user_id ORDER BY Q.qid DESC";

        try (
            Connection cn = DBUtil.getConnection();
            PreparedStatement ps = cn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery()
        ) {
            while (rs.next()) {
                Map<String, Object> m = new HashMap<>();
                m.put("qid", rs.getInt("qid"));
                m.put("email", rs.getString("Email"));
                m.put("subject", rs.getString("subject"));
                m.put("message", rs.getString("message"));
                m.put("status", rs.getString("status"));
                m.put("answer", rs.getString("answer"));
                list.add(m);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Fetch single question
    public Map<String, Object> getQuestionById(int qid) {
        Map<String, Object> m = null;
        String sql = "SELECT Q.*, U.Email FROM Customer_Question Q JOIN User U ON Q.user_id = U.user_id WHERE Q.qid=?";

        try (
            Connection cn = DBUtil.getConnection();
            PreparedStatement ps = cn.prepareStatement(sql)
        ) {
            ps.setInt(1, qid);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                m = new HashMap<>();
                m.put("qid", rs.getInt("qid"));
                m.put("email", rs.getString("Email"));
                m.put("subject", rs.getString("subject"));
                m.put("message", rs.getString("message"));
                m.put("status", rs.getString("status"));
                m.put("answer", rs.getString("answer"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return m;
    }

    // Insert new user question
    public void insertQuestion(int userId, String subject, String message) {
        String sql = "INSERT INTO Customer_Question (user_id, subject, message, status) VALUES (?, ?, ?, 'Open')";

        try (
            Connection cn = DBUtil.getConnection();
            PreparedStatement ps = cn.prepareStatement(sql)
        ) {
            ps.setInt(1, userId);
            ps.setString(2, subject);
            ps.setString(3, message);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Resolve question and save answer
    public void replyToQuestion(int qid, String answer) {
        String sql = "UPDATE Customer_Question SET answer=?, status='Resolved' WHERE qid=?";

        try (
            Connection cn = DBUtil.getConnection();
            PreparedStatement ps = cn.prepareStatement(sql)
        ) {
            ps.setString(1, answer);
            ps.setInt(2, qid);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ------------------------------------------------------------
    // 2. MANAGE USERS
    // ------------------------------------------------------------

    public List<Map<String, Object>> getAllUsers() {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT * FROM User";

        try (
            Connection cn = DBUtil.getConnection();
            PreparedStatement ps = cn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery()
        ) {
            while (rs.next()) {
                Map<String, Object> m = new HashMap<>();
                m.put("user_id", rs.getInt("user_id"));
                m.put("email", rs.getString("Email"));
                m.put("role", rs.getString("Role"));
                list.add(m);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public void deleteUser(int userId) {
        try (Connection cn = DBUtil.getConnection()) {

            cn.createStatement().executeUpdate("DELETE FROM Bid WHERE user_id=" + userId);
            cn.createStatement().executeUpdate("DELETE FROM Auction WHERE user_id=" + userId);
            cn.createStatement().executeUpdate("DELETE FROM Item WHERE user_id=" + userId);

            PreparedStatement ps = cn.prepareStatement("DELETE FROM User WHERE user_id=?");
            ps.setInt(1, userId);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * Create a new customer representative account.
     */
    public void createCustomerRep(int adminUserId,
                                  String email,
                                  String password,
                                  String region,
                                  java.sql.Date hireDate) throws Exception {

        String findAdminSql =
                "SELECT admin_id FROM Admin WHERE user_id = ?";

        String insertUserSql =
                "INSERT INTO User (Email, Password, Role, Is_active) " +
                "VALUES (?,?, 'rep', TRUE)";

        String insertRepSql =
                "INSERT INTO Customer_Rep (Region, hire_date, user_id, admin_id) " +
                "VALUES (?,?,?,?)";

        String updateAdminCountSql =
                "UPDATE Admin SET created_reps_count = created_reps_count + 1 " +
                "WHERE admin_id = ?";

        try (Connection cn = DBUtil.getConnection()) {
            cn.setAutoCommit(false);

            int adminId;

            // 1) resolve admin_id from admin user_id
            try (PreparedStatement ps = cn.prepareStatement(findAdminSql)) {
                ps.setInt(1, adminUserId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (!rs.next()) {
                        throw new RuntimeException("No Admin record found for user_id=" + adminUserId);
                    }
                    adminId = rs.getInt("admin_id");
                }
            }

            // 2) create the rep's User record
            int newUserId;
            try (PreparedStatement ps = cn.prepareStatement(insertUserSql, Statement.RETURN_GENERATED_KEYS)) {
                ps.setString(1, email);
                ps.setString(2, password); // plain text for project; could be hashed
                ps.executeUpdate();

                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (!rs.next()) {
                        throw new RuntimeException("Failed to create rep user");
                    }
                    newUserId = rs.getInt(1);
                }
            }

            // 3) create the Customer_Rep record
            try (PreparedStatement ps = cn.prepareStatement(insertRepSql)) {
                ps.setString(1, region);
                ps.setDate(2, hireDate);
                ps.setInt(3, newUserId);
                ps.setInt(4, adminId);
                ps.executeUpdate();
            }

            // 4) increment admin's created_reps_count
            try (PreparedStatement ps = cn.prepareStatement(updateAdminCountSql)) {
                ps.setInt(1, adminId);
                ps.executeUpdate();
            }

            cn.commit();
        }
    }

    // ------------------------------------------------------------
    // 3. REMOVE BIDS
    // ------------------------------------------------------------

    public List<Map<String, Object>> getAllBids() {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT B.*, U.Email FROM Bid B JOIN User U ON B.user_id = U.user_id ORDER BY B.Bid_time DESC";

        try (
            Connection cn = DBUtil.getConnection();
            PreparedStatement ps = cn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery()
        ) {
            while (rs.next()) {
                Map<String, Object> m = new HashMap<>();
                m.put("bid_id", rs.getInt("bid_id"));
                m.put("auction_id", rs.getInt("auction_id"));
                m.put("email", rs.getString("Email"));
                m.put("amount", rs.getInt("Bid_amount"));
                m.put("time", rs.getTimestamp("Bid_time"));
                list.add(m);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public void deleteBid(int bidId) {
        try (
            Connection cn = DBUtil.getConnection();
            PreparedStatement ps = cn.prepareStatement("DELETE FROM Bid WHERE bid_id=?")
        ) {
            ps.setInt(1, bidId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ------------------------------------------------------------
    // 4. REMOVE AUCTIONS
    // ------------------------------------------------------------

    public List<Map<String, Object>> getAllAuctions() {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql =
            "SELECT A.auction_id, A.status, A.start_price, I.Title, I.Item_Condition, U.Email " +
            "FROM Auction A " +
            "JOIN Item I ON A.item_id = I.item_id " +
            "JOIN User U ON A.user_id = U.user_id";

        try (
            Connection cn = DBUtil.getConnection();
            PreparedStatement ps = cn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery()
        ) {
            while (rs.next()) {
                Map<String, Object> m = new HashMap<>();
                m.put("auction_id", rs.getInt("auction_id"));
                m.put("title", rs.getString("Title"));
                m.put("condition", rs.getString("Item_Condition"));
                m.put("seller", rs.getString("Email"));
                m.put("price", rs.getInt("start_price"));
                m.put("status", rs.getString("status"));
                list.add(m);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public void deleteAuction(int auctionId) {
        try (Connection cn = DBUtil.getConnection()) {

            cn.createStatement().executeUpdate("DELETE FROM Bid WHERE auction_id=" + auctionId);

            PreparedStatement ps = cn.prepareStatement("DELETE FROM Auction WHERE auction_id=?");
            ps.setInt(1, auctionId);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}
