package com.example.auth;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.*;
import java.io.IOException;

@WebFilter("/*")
public class RoleFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response,
                         FilterChain chain) throws IOException, ServletException {

        HttpServletRequest req  = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        String uri = req.getRequestURI();
        String ctx = req.getContextPath();

        HttpSession session = req.getSession(false);
        String role = (session == null) ? null : (String) session.getAttribute("role");

        // If no role (not logged in yet), let AuthFilter handle it instead
        if (role == null) {
            chain.doFilter(request, response);
            return;
        }

        String lowerRole = role.toLowerCase();

        // Admin-only paths
        if (uri.startsWith(ctx + "/admin/")) {
            if (!"admin".equals(lowerRole)) {
                res.sendError(HttpServletResponse.SC_FORBIDDEN, "Admin access only.");
                return;
            }
        }

        // Seller-only paths
        if (uri.endsWith("sellerDashboard.jsp")
                || uri.endsWith("/createAuction")
                || uri.endsWith("/loadCategories")) {

            if (!"seller".equals(lowerRole)) {
                res.sendError(HttpServletResponse.SC_FORBIDDEN, "Seller access only.");
                return;
            }
        }

        // Buyer/customer-only paths
        if (uri.endsWith("BiddingPage.jsp")
                || uri.endsWith("/browseAuctions")
                || uri.endsWith("/placeBid")
                || uri.endsWith("/setAutoBid")
                || uri.endsWith("/bidHistory")
                || uri.endsWith("/setAlert")) {

            if (!("buyer".equals(lowerRole) || "customer".equals(lowerRole))) {
                res.sendError(HttpServletResponse.SC_FORBIDDEN, "Buyer access only.");
                return;
            }
        }

        chain.doFilter(request, response);
    }
}
