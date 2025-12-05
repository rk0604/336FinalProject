package com.example.auth;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.*;

@WebServlet("/loadCategories")
public class LoadCategoriesServlet extends HttpServlet {

    private final CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            List<Map<String,Object>> categories = categoryDAO.getAllCategories();
            req.setAttribute("categories", categories);

            req.getRequestDispatcher("/sellerDashboard.jsp").forward(req, resp);

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
