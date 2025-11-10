package com.example.auth;

// import jakarta.servlet.ServletException;
// import jakarta.servlet.annotation.WebServlet;
// import jakarta.servlet.http.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private final UserDAO dao = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        boolean ok;

        try { ok = dao.authenticate(email, password); }
        catch (Exception e) { throw new ServletException(e); }

        if (ok) {
            HttpSession s = req.getSession(true);
            s.setAttribute("email", email);
            req.setAttribute("message", "Login successful. Welcome, " + email + "!");
        } else {
            req.setAttribute("message", "Invalid email or password.");
        }
        req.getRequestDispatcher("/result.jsp").forward(req, resp);
    }
}
