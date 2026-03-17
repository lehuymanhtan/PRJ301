package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import models.TierStatistic;
import services.AdminLoyaltyService;
import services.LoyaltyConfigService;
import services.LoyaltyReportService;

/**
 * Admin loyalty management at /admin/loyalty.
 *
 * GET  → show point rate config + tier statistics
 * POST action=updateRate    → update global point rate
 * POST action=adjustPoints  → manually add/subtract points for a user
 * POST action=changeTier    → manually set a user's tier
 */
@WebServlet(urlPatterns = {"/admin/loyalty"})
public class AdminLoyaltyServlet extends HttpServlet {

    private final LoyaltyConfigService configService = new LoyaltyConfigService();
    private final LoyaltyReportService reportService = new LoyaltyReportService();
    private final AdminLoyaltyService adminService   = new AdminLoyaltyService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int pointRate = configService.getPointRate();
        List<TierStatistic> stats = reportService.getTierStatistics();

        request.setAttribute("pointRate", pointRate);
        request.setAttribute("stats", stats);
        request.getRequestDispatcher("/admin/loyalty/loyalty.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("updateRate".equals(action)) {
            int rate = Integer.parseInt(request.getParameter("rate"));
            configService.updatePointRate(rate);
            response.sendRedirect(request.getContextPath() + "/admin/loyalty");

        } else if ("adjustPoints".equals(action)) {
            int userId = Integer.parseInt(request.getParameter("userId"));
            int points = Integer.parseInt(request.getParameter("points"));
            adminService.adjustPoints(userId, points);
            response.sendRedirect(request.getContextPath() + "/admin/users");

        } else if ("changeTier".equals(action)) {
            int userId = Integer.parseInt(request.getParameter("userId"));
            String tier = request.getParameter("tier");
            adminService.changeTier(userId, tier);
            response.sendRedirect(request.getContextPath() + "/admin/users");

        } else {
            response.sendRedirect(request.getContextPath() + "/admin/loyalty");
        }
    }
}
