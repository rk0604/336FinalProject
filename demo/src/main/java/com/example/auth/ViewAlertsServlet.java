package com.example.auth;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/myAlerts")
public class ViewAlertsServlet extends HttpServlet {

    private final AlertDAO alertDAO = new AlertDAO();
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            String email = (String) req.getSession().getAttribute("email");
            if (email == null) {
                resp.sendRedirect("login.jsp");
                return;
            }

            int userId = userDAO.getUserId(email);
            List<Map<String, Object>> alerts = alertDAO.getAlertsForUser(userId);

            req.setAttribute("alerts", alerts);
            // alerts.jsp is at the webapp root, not under WEB-INF
            req.getRequestDispatcher("/alerts.jsp").forward(req, resp);

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
