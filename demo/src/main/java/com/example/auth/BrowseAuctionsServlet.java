package com.example.auth;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.*;

@WebServlet("/browseAuctions")
public class BrowseAuctionsServlet extends HttpServlet {

    private final AuctionDAO auctionDAO = new AuctionDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            List<Map<String,Object>> auctions = auctionDAO.getActiveAuctions();
            req.setAttribute("auctions", auctions);
            req.getRequestDispatcher("/BiddingPage.jsp").forward(req, resp);

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
