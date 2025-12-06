package com.example.auth;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private final UserDAO dao = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String email    = req.getParameter("email");
        String password = req.getParameter("password");

        try {
            // Authenticate the user and get their role
            String role = dao.authenticateAndGetRole(email, password);

            if (role == null) {
                req.setAttribute("message", "Invalid email or password.");
                req.getRequestDispatcher("/result.jsp").forward(req, resp);
                return;
            }

            // Look up the user's numeric ID so admin servlets can use it
            int userId = dao.getUserId(email);

            HttpSession session = req.getSession(true);
            session.setAttribute("email", email);
            session.setAttribute("role", role);
            session.setAttribute("userId", userId); // <-- needed by AdminCreateRepServlet

            String r = role.toLowerCase();

            switch (r) {
                case "seller":
                    resp.sendRedirect("loadCategories");  // loads sellerDashboard with categories
                    break;

                case "buyer":
                case "customer":
                    resp.sendRedirect("browseAuctions");  // loads BiddingPage with auctions
                    break;

                case "admin":
                    resp.sendRedirect("adminDashboard.jsp");
                    break;

                case "rep":
                case "customer_rep":
                case "customer rep":
                    resp.sendRedirect("customerRepDashboard.jsp");
                    break;

                default:
                    req.setAttribute("message", "Unknown role: " + role);
                    req.getRequestDispatcher("/result.jsp").forward(req, resp);
            }

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
