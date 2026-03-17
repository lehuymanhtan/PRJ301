package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import util.QuartzSchedulerInitializer;
import java.io.IOException;
import java.util.logging.Logger;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.util.HashMap;
import java.util.Map;

/**
 * Endpoint to manually trigger the daily forecast job
 * POST /admin/forecast/trigger
 */
@WebServlet(urlPatterns = {"/admin/forecast/trigger"})
public class ForecastTriggerServlet extends HttpServlet {
    private static final Logger logger = Logger.getLogger(ForecastTriggerServlet.class.getName());
    private static final ObjectMapper mapper = new ObjectMapper();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");

        try {
            // Trigger the forecast job
            QuartzSchedulerInitializer.triggerForecastNow();

            // Return success response
            Map<String, Object> result = new HashMap<>();
            result.put("success", true);
            result.put("message", "Forecast job triggered successfully. Check back in a few minutes for results.");
            result.put("timestamp", System.currentTimeMillis());

            response.setStatus(HttpServletResponse.SC_OK);
            response.getWriter().write(mapper.writeValueAsString(result));

            logger.info("Forecast manually triggered via admin dashboard");

        } catch (Exception e) {
            logger.severe("Failed to trigger forecast: " + e.getMessage());

            // Return error response
            Map<String, Object> result = new HashMap<>();
            result.put("success", false);
            result.put("message", "Error triggering forecast: " + e.getMessage());
            result.put("timestamp", System.currentTimeMillis());

            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write(mapper.writeValueAsString(result));
        }
    }
}
