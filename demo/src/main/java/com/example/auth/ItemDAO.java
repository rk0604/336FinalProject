package com.example.auth;

import com.example.util.DBUtil;
import java.sql.*;

public class ItemDAO {

    public int createItem(int userId, int catId, String title, String desc,
                          String size, String brand, String color, String condition) throws Exception {

        String sql = "INSERT INTO Item (user_id, cat_id, Title, Description, Size, Brand, Color, Item_Condition) " +
                     "VALUES (?,?,?,?,?,?,?,?)";

        try (Connection cn = DBUtil.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, userId);
            ps.setInt(2, catId);
            ps.setString(3, title);
            ps.setString(4, desc);
            ps.setString(5, size);
            ps.setString(6, brand);
            ps.setString(7, color);
            ps.setString(8, condition);

            ps.executeUpdate();

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        throw new RuntimeException("Failed to create item");
    }
}
