package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import models.ProphetForecast;
import services.ProphetForecastService;
import dao.ProphetForecastDAO;
import java.io.IOException;
import java.util.logging.Logger;

/**
 * Admin forecast display at /admin/forecast
 * Shows latest 3-month sales forecast with charts and prediction timestamp
 */
@WebServlet(urlPatterns = {"/admin/forecast"})
public class AdminForecastServlet extends HttpServlet {
    private static final Logger logger = Logger.getLogger(AdminForecastServlet.class.getName());
    private final ProphetForecastDAO forecastDAO = new ProphetForecastDAO();
    private final ProphetForecastService forecastService = new ProphetForecastService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Get latest completed forecast
            ProphetForecast latestForecast = forecastDAO.getLatestForecast();

            if (latestForecast != null && "completed".equals(latestForecast.status)) {
                // Verify output files still exist
                if (forecastService.verifyOutputFiles(latestForecast.convertToResult())) {
                    // Read images as base64 for embedding in HTML
                    try {
                        String forecastPlotBase64 = forecastService.readFileAsBase64(latestForecast.forecastPlotPath);
                        String monthlyBarBase64 = forecastService.readFileAsBase64(latestForecast.monthlyBarPath);
                        String componentsPlotBase64 = forecastService.readFileAsBase64(latestForecast.componentsPlotPath);

                        request.setAttribute("forecast", latestForecast);
                        request.setAttribute("forecastPlotBase64", forecastPlotBase64);
                        request.setAttribute("monthlyBarBase64", monthlyBarBase64);
                        request.setAttribute("componentsPlotBase64", componentsPlotBase64);
                        request.setAttribute("forecastAvailable", true);
                    } catch (Exception e) {
                        logger.warning("Error reading forecast images: " + e.getMessage());
                        request.setAttribute("forecastAvailable", false);
                        request.setAttribute("errorMessage", "Forecast files could not be loaded");
                    }
                } else {
                    request.setAttribute("forecastAvailable", false);
                    request.setAttribute("errorMessage", "Forecast files are missing or inaccessible");
                }
            } else {
                request.setAttribute("forecastAvailable", false);
                request.setAttribute("errorMessage", "No forecast available yet. Forecasts run daily at 2 AM");
            }

            request.getRequestDispatcher("/admin/forecast.jsp").forward(request, response);

        } catch (Exception e) {
            logger.severe("Error loading forecast: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error loading forecast: " + e.getMessage());
            request.getRequestDispatcher("/admin/forecast.jsp").forward(request, response);
        }
    }
}
