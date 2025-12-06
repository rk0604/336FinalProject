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

        // Read search / filter / sort parameters from the query string
        String q        = trimOrNull(req.getParameter("q"));        // keyword search
        String category = trimOrNull(req.getParameter("category")); // category name
        String sort     = trimOrNull(req.getParameter("sort"));     // sort option

        try {
            // Fetch active auctions with filters & sorting applied
            List<Map<String,Object>> auctions =
                    auctionDAO.getActiveAuctionsFiltered(q, category, sort);

            // Fetch all available categories for the dropdown
            List<String> categories = auctionDAO.getAllCategories();

            // Pass data + current filter state to JSP
            req.setAttribute("auctions", auctions);
            req.setAttribute("categories", categories);
            req.setAttribute("q", q == null ? "" : q);
            req.setAttribute("selectedCategory", category == null ? "" : category);
            req.setAttribute("sort", sort == null ? "" : sort);

            req.getRequestDispatcher("/BiddingPage.jsp").forward(req, resp);

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    private String trimOrNull(String s) {
        if (s == null) return null;
        String t = s.trim();
        return t.isEmpty() ? null : t;
    }
}
