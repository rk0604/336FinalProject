package com.example.auth;

import com.example.util.DBUtil;
import java.sql.*;

public class UserDAO {

    // AUTHENTICATE + RETURN ROLE
    public String authenticateAndGetRole(String email, String password) throws Exception {
        String sql = "SELECT Role FROM User WHERE Email=? AND Password=? AND Is_active=TRUE LIMIT 1";

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

    // GET USER ID BY EMAIL  (THIS FIXES YOUR COMPILATION ERRORS)
    public Integer getUserId(String email) throws Exception {
        String sql = "SELECT user_id FROM User WHERE Email=? LIMIT 1";

        try (Connection cn = DBUtil.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setString(1, email);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("user_id");
                } else {
                    return null;
                }
            }
        }
    }
}
