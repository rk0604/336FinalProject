package com.example.util;

import java.io.InputStream;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.util.Properties;

public class DBUtil {
    private static String url;
    private static String user;
    private static String pass;
    private static String driver;

    static {
        Properties p = new Properties();

        // Load db.properties from classpath (src/main/resources)
        // NOTE: leading "/" is important
        try (InputStream in = DBUtil.class.getResourceAsStream("/db.properties")) {

            if (in == null) {
                throw new RuntimeException("db.properties not found in classpath (WEB-INF/classes)");
            }

            p.load(in);

            url    = p.getProperty("jdbc.url");
            user   = p.getProperty("jdbc.user");
            pass   = p.getProperty("jdbc.pass");
            driver = p.getProperty("jdbc.driver");

            if (url == null || user == null || pass == null || driver == null) {
                throw new RuntimeException(
                    "Missing required JDBC properties. " +
                    "Check db.properties for keys: jdbc.url, jdbc.user, jdbc.pass, jdbc.driver"
                );
            }

            Class.forName(driver);

        } catch (IOException e) {
            throw new RuntimeException("Failed to load db.properties", e);
        } catch (Exception e) {
            throw new RuntimeException("DBUtil init failed", e);
        }
    }

    public static Connection getConnection() throws Exception {
        return DriverManager.getConnection(url, user, pass);
    }
}
