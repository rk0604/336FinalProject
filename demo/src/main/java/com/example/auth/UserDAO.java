package com.example.auth;

import com.example.util.DBUtil;
import java.sql.*;

public class UserDAO {
    public boolean authenticate(String email, String password) throws Exception {
        String sql = "SELECT 1 FROM `User` WHERE Email=? AND Password=? AND Is_active=TRUE LIMIT 1";
        try (Connection cn = DBUtil.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, password);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }
}
