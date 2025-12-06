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
}
