package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import models.DailyIncome;
import models.MonthlyIncome;
import models.YearlyIncome;
import services.OrderService;
import services.OrderServiceImpl;
import java.io.IOException;
import java.util.List;

/**
 * Income report page at /admin/income.
 * Accepts query params: dayFilter, monthFilter, yearFilter.
 * Only values in the allowed sets are accepted; others fall back to defaults.
 */
@WebServlet(urlPatterns = {"/admin/income"})
public class AdminIncomeServlet extends HttpServlet {

    private final OrderService orderService = new OrderServiceImpl();

    private static final int[] ALLOWED_DAY_FILTERS   = {7, 14, 30};
    private static final int[] ALLOWED_MONTH_FILTERS = {1, 2, 3, 6, 12};
    private static final int[] ALLOWED_YEAR_FILTERS  = {1, 2, 3, 5};

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int dayFilter   = parseAllowed(request.getParameter("dayFilter"),   7,  ALLOWED_DAY_FILTERS);
        int monthFilter = parseAllowed(request.getParameter("monthFilter"), 3,  ALLOWED_MONTH_FILTERS);
        int yearFilter  = parseAllowed(request.getParameter("yearFilter"),  3,  ALLOWED_YEAR_FILTERS);

        List<DailyIncome>   dayData   = orderService.getDailyIncomeRange(dayFilter);
        List<MonthlyIncome> monthData = orderService.getMonthlyIncome(monthFilter);
        List<YearlyIncome>  yearData  = orderService.getYearlyIncome(yearFilter);

        request.setAttribute("dayFilter",   dayFilter);
        request.setAttribute("monthFilter", monthFilter);
        request.setAttribute("yearFilter",  yearFilter);
        request.setAttribute("dayData",     dayData);
        request.setAttribute("monthData",   monthData);
        request.setAttribute("yearData",    yearData);

        request.getRequestDispatcher("/admin/income.jsp").forward(request, response);
    }

    /** Returns {@code value} only if it is in {@code allowed}; otherwise {@code defaultVal}. */
    private int parseAllowed(String param, int defaultVal, int[] allowed) {
        if (param == null) return defaultVal;
        try {
            int v = Integer.parseInt(param.trim());
            for (int a : allowed) {
                if (a == v) return v;
            }
        } catch (NumberFormatException ignored) {}
        return defaultVal;
    }
}
