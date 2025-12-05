package com.example.auth;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/placeBid")
public class PlaceBidServlet extends HttpServlet {

    private final BidDAO bidDAO = new BidDAO();
    private final AuctionDAO auctionDAO = new AuctionDAO();
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            int auctionId = Integer.parseInt(req.getParameter("auction_id"));
            int bidAmount = Integer.parseInt(req.getParameter("bid_amount"));

            // User ID from session
            String email = (String) req.getSession().getAttribute("email");
            int userId = userDAO.getUserId(email);

            // Check highest bid
            Integer currentHigh = bidDAO.getHighestBid(auctionId);
            if (currentHigh == null) currentHigh = 0;

            if (bidAmount <= currentHigh) {
                req.setAttribute("message", "Your bid must be higher than the current highest bid.");
                req.getRequestDispatcher("/result.jsp").forward(req, resp);
                return;
            }

            bidDAO.placeBid(auctionId, userId, bidAmount);
            resp.sendRedirect("browseAuctions");

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
