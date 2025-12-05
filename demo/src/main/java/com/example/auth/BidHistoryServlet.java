package com.example.auth;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.*;

@WebServlet("/bidHistory")
public class BidHistoryServlet extends HttpServlet {

    private final BidDAO bidDAO = new BidDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            int auctionId = Integer.parseInt(req.getParameter("auction_id"));

            List<Map<String,Object>> history = bidDAO.getBidHistory(auctionId);
            req.setAttribute("history", history);
            req.getRequestDispatcher("/bidHistory.jsp").forward(req, resp);

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
