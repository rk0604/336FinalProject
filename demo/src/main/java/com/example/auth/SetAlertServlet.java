package com.example.auth;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/setAlert")
public class SetAlertServlet extends HttpServlet {

    private final AlertDAO alertDAO = new AlertDAO();
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            String keyword = req.getParameter("keyword");
            Integer min = parse(req.getParameter("min_price"));
            Integer max = parse(req.getParameter("max_price"));

            String email = (String) req.getSession().getAttribute("email");
            int userId = userDAO.getUserId(email);

            alertDAO.createAlert(userId, keyword, min, max);

            req.setAttribute("message", "Alert created successfully!");
            req.getRequestDispatcher("/result.jsp").forward(req, resp);

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    private Integer parse(String x) {
        if (x == null || x.trim().isEmpty()) return null;
        return Integer.parseInt(x);
    }
}
