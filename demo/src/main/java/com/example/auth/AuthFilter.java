package com.example.auth;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.*;
import java.io.IOException;

@WebFilter("/*")
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response,
                         FilterChain chain) throws IOException, ServletException {

        HttpServletRequest req  = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        String uri = req.getRequestURI();
        String ctx = req.getContextPath();

        // Public resources (no login needed)
        boolean isLoginPage  = uri.equals(ctx + "/login.jsp") || uri.equals(ctx + "/");
        boolean isLoginReq   = uri.equals(ctx + "/login");
        boolean isStatic     = uri.startsWith(ctx + "/resources/")
                            || uri.endsWith(".css") || uri.endsWith(".js")
                            || uri.endsWith(".png") || uri.endsWith(".jpg")
                            || uri.endsWith(".jpeg") || uri.endsWith(".gif");

        if (isLoginPage || isLoginReq || isStatic) {
            chain.doFilter(request, response);
            return;
        }

        HttpSession session = req.getSession(false);
        String email = (session == null) ? null : (String) session.getAttribute("email");

        if (email == null) {
            res.sendRedirect(ctx + "/login.jsp");
            return;
        }

        chain.doFilter(request, response);
    }
}
