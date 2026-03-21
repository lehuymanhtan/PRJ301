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
    private static final int PAGE_SIZE = 25;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int pageNumber = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.isEmpty()) {
            try {
                pageNumber = Integer.parseInt(pageParam);
                if (pageNumber < 1) pageNumber = 1;
            } catch (NumberFormatException e) {
                pageNumber = 1;
            }
        }

        long totalCount = dao.countByUserId(user.getUserId());
        long totalPages = (totalCount + PAGE_SIZE - 1) / PAGE_SIZE;
        if (pageNumber > totalPages && totalPages > 0) pageNumber = (int) totalPages;

        List<PointHistory> list = dao.findPageByUserId(user.getUserId(), pageNumber, PAGE_SIZE);

        request.setAttribute("pointHistory", list);
        request.setAttribute("pageNumber", pageNumber);
        request.setAttribute("pageSize", PAGE_SIZE);
        request.setAttribute("totalCount", totalCount);
        request.setAttribute("totalPages", totalPages);
        request.getRequestDispatcher("/users/point-history.jsp").forward(request, response);
    }
}
