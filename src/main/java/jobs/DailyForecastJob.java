package jobs;

import java.util.logging.Level;
import java.util.logging.Logger;
import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import services.ProphetForecastService;
import dao.ProphetForecastDAO;
import models.ProphetForecast;
import java.time.LocalDateTime;

/**
 * Quartz Job that runs daily at 2 AM
 * Executes the full forecast cycle: extract data, retrain, predict
 * Stores forecast metadata in database
 */
public class DailyForecastJob implements Job {
    private static final Logger logger = Logger.getLogger(DailyForecastJob.class.getName());

    @Override
    public void execute(JobExecutionContext context) throws JobExecutionException {
        try {
            logger.info("=== DailyForecastJob started at " + LocalDateTime.now());

            ProphetForecastService forecastService = new ProphetForecastService();

            // Execute full forecast cycle (3-month forecast)
            // If no new data: retrain is skipped, predict uses existing model
            ProphetForecastService.ForecastResult result = forecastService.executeFullForecastCycle(3);

            // Verify output files exist
            if (!forecastService.verifyOutputFiles(result)) {
                throw new Exception("Output files missing or inaccessible");
            }

            // Store forecast metadata in DB
            ProphetForecastDAO dao = new ProphetForecastDAO();
            ProphetForecast forecast = new ProphetForecast();
            forecast.jobId = result.jobId;
            forecast.outputFolder = result.outputFolder;
            forecast.forecastPlotPath = result.forecastPlotPath;
            forecast.monthlyBarPath = result.monthlyBarPath;
            forecast.componentsPlotPath = result.componentsPlotPath;
            forecast.monthlyCSVPath = result.monthlyCSVPath;
            forecast.predictedAt = result.predictedAt;
            forecast.status = "completed";

            dao.save(forecast);

            logger.info("=== DailyForecastJob completed successfully. JobId: " + result.jobId);

        } catch (Exception e) {
            logger.log(Level.SEVERE, "DailyForecastJob failed", e);

            // Store error in database
            try {
                ProphetForecastDAO dao = new ProphetForecastDAO();
                ProphetForecast forecast = new ProphetForecast();
                forecast.jobId = "ERROR_" + System.currentTimeMillis();
                forecast.predictedAt = LocalDateTime.now();
                forecast.status = "error";
                forecast.errorMessage = e.getMessage();
                dao.save(forecast);
            } catch (Exception dbError) {
                logger.log(Level.SEVERE, "Failed to store error in database", dbError);
            }

            throw new JobExecutionException("DailyForecastJob failed: " + e.getMessage(), e);
        }
    }
}
