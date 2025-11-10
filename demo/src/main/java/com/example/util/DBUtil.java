package com.example.util;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.util.Properties;

public class DBUtil {
    private static String url, user, pass, driver;

    static {
        try {
            Properties p = new Properties();
            InputStream in = DBUtil.class.getClassLoader().getResourceAsStream("db.properties");
            p.load(in);
            url = p.getProperty("jdbc.url");
            user = p.getProperty("jdbc.user");
            pass = p.getProperty("jdbc.pass");
            driver = p.getProperty("jdbc.driver");
            Class.forName(driver);
        } catch (Exception e) {
            throw new RuntimeException("DBUtil init failed", e);
        }
    }

    public static Connection getConnection() throws Exception {
        return DriverManager.getConnection(url, user, pass);
    }
}
