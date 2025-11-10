package com.example.auth;

// import jakarta.servlet.ServletException;
// import jakarta.servlet.annotation.WebServlet;
// import jakarta.servlet.http.*;
// C:\Users\Risha\Desktop\College materials\Rutgers Semester 7\336\Tomcat9\apache-tomcat-9.0.111 - catalina home 

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession s = req.getSession(false);
        if (s != null) s.invalidate();
        req.setAttribute("message", "You have been logged out.");
        req.getRequestDispatcher("/result.jsp").forward(req, resp);
    }
}
