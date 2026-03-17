package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import models.PointHistory;
import services.LoyaltyService;

/**
 * Admin view of any user's point history at /admin/point-history?userId=N.
 */
@WebServlet(urlPatterns = {"/admin/point-history"})
public class AdminPointHistoryServlet extends HttpServlet {

    private final LoyaltyService loyaltyService = new LoyaltyService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String userParam = request.getParameter("userId");
        if (userParam == null) {
            response.sendRedirect(request.getContextPath() + "/admin/users");
            return;
        }

        int userId = Integer.parseInt(userParam);
        List<PointHistory> histories = loyaltyService.getPointHistoryByUser(userId);

        request.setAttribute("histories", histories);
        request.setAttribute("targetUserId", userId);
        request.getRequestDispatcher("/admin/users/point-history.jsp").forward(request, response);
    }
}
