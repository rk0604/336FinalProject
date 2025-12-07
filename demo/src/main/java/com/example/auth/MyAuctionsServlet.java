package com.example.auth;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/myAuctions")
public class MyAuctionsServlet extends HttpServlet {

    private final AuctionDAO auctionDAO = new AuctionDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("email") == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        String role = (String) session.getAttribute("role");
        Integer userId = (Integer) session.getAttribute("userId");

        if (role == null || userId == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        try {
            List<Map<String, Object>> auctions;

            String r = role.toLowerCase();
            if ("seller".equals(r)) {
                auctions = auctionDAO.getAuctionsForSeller(userId);
                req.setAttribute("mode", "seller");
            } else {
                // buyer / customer / anything else uses buyer view
                auctions = auctionDAO.getAuctionsForBuyer(userId);
                req.setAttribute("mode", "buyer");
            }

            req.setAttribute("auctions", auctions);
            req.getRequestDispatcher("/myAuctions.jsp").forward(req, resp);

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
