package com.example.auth;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/askQuestion")
public class AskQuestionServlet extends HttpServlet {

    private final QuestionDAO questionDAO = new QuestionDAO();
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("email") == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        // Just forward to the JSP form
        req.getRequestDispatcher("/askQuestion.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("email") == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        try {
            String email = (String) session.getAttribute("email");
            int userId = userDAO.getUserId(email);

            String subject = req.getParameter("subject");
            String body    = req.getParameter("body");

            if (subject == null || subject.trim().isEmpty()
             || body == null || body.trim().isEmpty()) {
                req.setAttribute("message", "Subject and question text are required.");
                req.getRequestDispatcher("/result.jsp").forward(req, resp);
                return;
            }

            questionDAO.createQuestion(userId, subject.trim(), body.trim());

            req.setAttribute("message",
                    "Your question has been submitted to customer support.");
            req.getRequestDispatcher("/result.jsp").forward(req, resp);

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
