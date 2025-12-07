package com.example.auth;

import com.example.util.DBUtil;
import java.sql.Connection;
import java.sql.PreparedStatement;

public class QuestionDAO {

    /**
     * Creates a new customer-service question from a buyer / customer.
     *
     * Expected DB table (adjust if your schema differs):
     *
     * CREATE TABLE Question (
     *   question_id INT AUTO_INCREMENT PRIMARY KEY,
     *   user_id     INT NOT NULL,
     *   subject     VARCHAR(255) NOT NULL,
     *   body        TEXT NOT NULL,
     *   status      VARCHAR(20) NOT NULL DEFAULT 'open',
     *   created_at  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
     *   answered_at TIMESTAMP NULL,
     *   FOREIGN KEY (user_id) REFERENCES User(user_id)
     * );
     */
    public void createQuestion(int userId, String subject, String body) throws Exception {
        String sql =
            "INSERT INTO customer_question (user_id, subject, message, status) " +
            "VALUES (?, ?, ?, 'open')";

        try (
            Connection cn = DBUtil.getConnection();
            PreparedStatement ps = cn.prepareStatement(sql)
        ) {
            ps.setInt(1, userId);
            ps.setString(2, subject);
            ps.setString(3, body);
            ps.executeUpdate();
        }
    }
}
