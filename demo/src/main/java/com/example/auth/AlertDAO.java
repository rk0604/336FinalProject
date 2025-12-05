package com.example.auth;

import com.example.util.DBUtil;
import java.sql.*;

public class AlertDAO {

    public void createAlert(int userId, String keyword, Integer minPrice, Integer maxPrice) throws Exception {
        String sql = "INSERT INTO Alert (user_id, key_word, min_price, max_price) VALUES (?,?,?,?)";

        try (Connection cn = DBUtil.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setString(2, keyword);
            ps.setObject(3, minPrice);
            ps.setObject(4, maxPrice);

            ps.executeUpdate();
        }
    }
}
