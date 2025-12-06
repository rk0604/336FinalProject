package com.example.auth;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Date;

@WebServlet("/admin/createRep")
public class AdminCreateRepServlet extends HttpServlet {

    private final CustomerRepDAO customerRepDAO = new CustomerRepDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Just show the form JSP
        req.getRequestDispatcher("/adminCreateRep.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String email   = req.getParameter("email");
        String pwd     = req.getParameter("password");
        String region  = req.getParameter("region");
        String hireStr = req.getParameter("hire_date");

        // Assume login stores admin's user_id in session as "userId"
        Integer adminUserId = (Integer) req.getSession().getAttribute("userId");

        if (adminUserId == null) {
            req.setAttribute("error", "Admin session not found. Please log in again.");
            req.getRequestDispatcher("/adminCreateRep.jsp").forward(req, resp);
            return;
        }

        try {
            Date hireDate;
            if (hireStr == null || hireStr.trim().isEmpty()) {
                // default to today if not provided
                hireDate = new Date(System.currentTimeMillis());
            } else {
                hireDate = Date.valueOf(hireStr); // expects yyyy-mm-dd
            }

            customerRepDAO.createCustomerRep(adminUserId, email, pwd, region, hireDate);

            req.setAttribute("success",
                    "Customer representative account created successfully for " + email + ".");

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Failed to create customer rep: " + e.getMessage());
        }

        // Show the same form again with success / error message
        req.getRequestDispatcher("/adminCreateRep.jsp").forward(req, resp);
    }
}
