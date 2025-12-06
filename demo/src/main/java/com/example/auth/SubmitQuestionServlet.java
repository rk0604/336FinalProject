package com.example.auth;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/submitQuestion")
public class SubmitQuestionServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        // Make sure there is a logged in user
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            res.sendRedirect("login.jsp");
            return;
        }

        int userId;
        Object userIdObj = session.getAttribute("user_id");
        if (userIdObj instanceof Integer) {
            userId = (Integer) userIdObj;
        } else {
            userId = Integer.parseInt(userIdObj.toString());
        }

        String subject = req.getParameter("subject");
        String message = req.getParameter("message");

        if (subject == null) subject = "";
        if (message == null) message = "";

        subject = subject.trim();
        message = message.trim();

        if (!subject.isEmpty() && !message.isEmpty()) {
            CustomerRepDAO dao = new CustomerRepDAO();
            dao.insertQuestion(userId, subject, message);
        }

        // After submitting, send user back to their dashboard
        res.sendRedirect("buyerDashboard.jsp");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        // Optional: redirect GET to the form page
        res.sendRedirect("submitQuestion.jsp");
    }
}
