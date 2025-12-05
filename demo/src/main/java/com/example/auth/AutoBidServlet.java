package com.example.auth;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/setAutoBid")
public class AutoBidServlet extends HttpServlet {

    private final AutoBidDAO autoBidDAO = new AutoBidDAO();
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            int auctionId = Integer.parseInt(req.getParameter("auction_id"));
            int maxAmount = Integer.parseInt(req.getParameter("max_bid_amount"));

            String email = (String) req.getSession().getAttribute("email");
            int userId = userDAO.getUserId(email);

            autoBidDAO.setAutoBid(userId, auctionId, maxAmount);

            req.setAttribute("message", "Auto-bid set successfully!");
            req.getRequestDispatcher("/result.jsp").forward(req, resp);

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
