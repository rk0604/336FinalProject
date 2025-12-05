package com.example.auth;

import com.example.auth.UserDAO;

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

        String email = req.getParameter("email");
        String password = req.getParameter("password");

        try {
            // NEW METHOD (matches UserDAO)
            String role = dao.authenticateAndGetRole(email, password);

            if (role == null) {
                req.setAttribute("message", "Invalid email or password.");
                req.getRequestDispatcher("/result.jsp").forward(req, resp);
                return;
            }

            HttpSession session = req.getSession(true);
            session.setAttribute("email", email);
            session.setAttribute("role", role);

            switch (role.toLowerCase()) {
                case "seller":
                    resp.sendRedirect("sellerDashboard.jsp");
                    break;

                case "buyer":
                case "customer":   // Add this line
                    resp.sendRedirect("BiddingPage.jsp");
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
