package com.example.auth;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Timestamp;

@WebServlet("/createAuction")
public class CreateAuctionServlet extends HttpServlet {

    private final ItemDAO itemDAO = new ItemDAO();
    private final AuctionDAO auctionDAO = new AuctionDAO();
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            String email = (String) req.getSession().getAttribute("email");
            int userId   = userDAO.getUserId(email);

            // Item fields
            String title      = req.getParameter("title");
            String desc       = req.getParameter("description");
            int category      = Integer.parseInt(req.getParameter("category"));
            String size       = req.getParameter("size");
            String brand      = req.getParameter("brand");
            String color      = req.getParameter("color");
            String condition  = req.getParameter("condition");

            // Auction fields (datetime-local -> 'YYYY-MM-DDTHH:MM')
            String startRaw   = req.getParameter("start_time");
            String endRaw     = req.getParameter("end_time");
            int startPrice    = Integer.parseInt(req.getParameter("start_price"));
            int reserve       = Integer.parseInt(req.getParameter("reserve_price"));

            Timestamp start = parseDateTime(startRaw);
            Timestamp end   = parseDateTime(endRaw);

            int itemId = itemDAO.createItem(userId, category, title, desc, size, brand, color, condition);
            auctionDAO.createAuction(itemId, userId, start, end, startPrice, reserve);

            req.setAttribute("message", "Auction created successfully!");
            req.getRequestDispatcher("/result.jsp").forward(req, resp);

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    private Timestamp parseDateTime(String s) {
        if (s == null || s.trim().isEmpty()) {
            throw new IllegalArgumentException("Missing date/time");
        }
        // HTML datetime-local: "YYYY-MM-DDTHH:MM"
        s = s.replace("T", " ");
        if (s.length() == 16) {
            s = s + ":00";  // add seconds if not present
        }
        return Timestamp.valueOf(s);
    }
}
