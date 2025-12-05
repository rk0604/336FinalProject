package com.example.auth;

import com.example.util.DBUtil;
import java.sql.*;
import java.util.*;

public class CategoryDAO {

    public List<Map<String, Object>> getAllCategories() throws Exception {
        String sql = "SELECT cat_id, name FROM Category ORDER BY name";
        List<Map<String, Object>> list = new ArrayList<>();

        try (Connection cn = DBUtil.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Map<String, Object> m = new HashMap<>();
                m.put("cat_id", rs.getInt("cat_id"));
                m.put("name", rs.getString("name"));
                list.add(m);
            }
        }
        return list;
    }
}
