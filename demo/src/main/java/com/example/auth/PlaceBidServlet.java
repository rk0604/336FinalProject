package com.example.auth;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/placeBid")
public class PlaceBidServlet extends HttpServlet {

    private final BidDAO bidDAO = new BidDAO();
    private final AuctionDAO auctionDAO = new AuctionDAO();
    private final UserDAO userDAO = new UserDAO();
    private final AutoBidDAO autoBidDAO = new AutoBidDAO();
    private final AlertDAO alertDAO = new AlertDAO();

    // Minimum increment between bids (adjust if your assignment says otherwise)
    private static final int MIN_INCREMENT = 25;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            int auctionId = Integer.parseInt(req.getParameter("auction_id"));
            int bidAmount = Integer.parseInt(req.getParameter("bid_amount"));

            // User ID from session
            String email = (String) req.getSession().getAttribute("email");
            int userId = userDAO.getUserId(email);

            // Check highest bid BEFORE this bid
            Integer currentHigh = bidDAO.getHighestBid(auctionId);
            if (currentHigh == null) {
                currentHigh = 0;
            }

            if (bidAmount <= currentHigh) {
                req.setAttribute("message", "Your bid must be higher than the current highest bid.");
                req.getRequestDispatcher("/result.jsp").forward(req, resp);
                return;
            }

            // 1) Place the new manual bid
            bidDAO.placeBid(auctionId, userId, bidAmount);

            // 2) Check if any auto-bidder should respond
            AutoBidDAO.AutoBidEntry auto = autoBidDAO.findBestAutoBidder(auctionId, bidAmount, userId);
            if (auto != null) {
                int autoUserId = auto.getUserId();
                int maxAuto = auto.getMaxBidAmount();

                int autoBidAmount = bidAmount + MIN_INCREMENT;
                if (autoBidAmount > maxAuto) {
                    autoBidAmount = maxAuto;
                }

                // Only place the auto-bid if it actually beats the manual bid
                if (autoBidAmount > bidAmount) {
                    bidDAO.placeBid(auctionId, autoUserId, autoBidAmount);
                }
            }

            // 3) After manual + possible auto-bid, determine final highest bidder and amount
            Integer finalHighAmount = bidDAO.getHighestBid(auctionId);
            if (finalHighAmount == null) {
                finalHighAmount = 0;
            }
            Integer finalHighBidderId = bidDAO.getHighestBidderId(auctionId);

            // Alert all other bidders that they have been outbid
            if (finalHighBidderId != null) {
                List<Integer> otherBidders = bidDAO.getDistinctBiddersExcept(auctionId, finalHighBidderId);
                for (int otherUserId : otherBidders) {
                    alertDAO.createSimpleAlert(otherUserId, "Outbid");
                }
            }

            // Alert auto-bidders whose max has been exceeded
            List<Integer> autoBidUsers = autoBidDAO.getUsersWithMaxBelow(auctionId, finalHighAmount);
            for (int autoUserId : autoBidUsers) {
                alertDAO.createSimpleAlert(autoUserId, "AutoBidLimitExceeded");
            }

            resp.sendRedirect("browseAuctions");

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
