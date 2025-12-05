package com.example.auth;

import com.example.util.DBUtil;
import java.sql.*;

public class UserDAO {

    // Returns role (seller, buyer, admin, rep) OR null if invalid login
    public String authenticateAndGetRole(String email, String password) throws Exception {
        String sql = "SELECT Role FROM `User` WHERE Email=? AND Password=? AND Is_active=TRUE LIMIT 1";

        try (Connection cn = DBUtil.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setString(1, email);
            ps.setString(2, password);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("Role");
                }
                return null;
            }
        }
    }
}
