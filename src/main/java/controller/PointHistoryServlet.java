package controller;

import dao.PointHistoryDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import models.PointHistory;
import models.User;

/**
 * User's own point history at /points.
 */
@WebServlet(urlPatterns = {"/points"})
public class PointHistoryServlet extends HttpServlet {

    private final PointHistoryDAO dao = new PointHistoryDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        List<PointHistory> list = dao.findByUserId(user.getUserId());
        request.setAttribute("pointHistory", list);
        request.getRequestDispatcher("/users/point-history.jsp").forward(request, response);
    }
}
