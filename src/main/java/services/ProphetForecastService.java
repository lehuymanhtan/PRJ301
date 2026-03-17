package services;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;


/**
 * High-level orchestration service for Prophet forecasting
 * Coordinates data extraction, model retraining, and predictions
 */
public class ProphetForecastService {
    private final SalesDataService salesDataService = new SalesDataService();
    private final ProphetClient prophetClient = new ProphetClient();
    private static final String MODEL_BASE_PATH = "model";
    private static final int POLL_TIMEOUT_MS = 300000; // 5 minutes
    private static final int POLL_INTERVAL_MS = 2000;   // 2 seconds

    /**
     * DTO for forecast result
     */
    public static class ForecastResult {
        public String jobId;
        public String outputFolder;
        public LocalDateTime predictedAt;
        public String forecastPlotPath;
        public String monthlyBarPath;
        public String componentsPlotPath;
        public String monthlyCSVPath;

        @Override
        public String toString() {
            return "ForecastResult{" +
                    "jobId='" + jobId + '\'' +
                    ", outputFolder='" + outputFolder + '\'' +
                    ", predictedAt=" + predictedAt +
                    '}';
        }
    }

    /**
     * Execute daily forecast cycle:
     * 1. Check if Prophet server is running
     * 2. Get last trained date from server
     * 3. Extract daily revenue AFTER last trained date
     * 4. If new data exists, submit retrain job and wait for completion
     * 5. If no new data, skip retrain (use existing model)
     * 6. Always submit predict job
     * 7. Wait for predict completion
     * Returns ForecastResult with paths to output files
     */
    public ForecastResult executeFullForecastCycle(int forecastMonths) throws Exception {
        System.out.println("[Prophet] Starting forecast cycle...");

        // Step 1: Check server
        if (!prophetClient.isServerRunning()) {
            throw new Exception("Prophet server is not running on http://localhost:8000");
        }
        System.out.println("[Prophet] Server is running");

        // Step 2: Get last trained date from server
        String lastTrainedDateStr = prophetClient.getLastTrainedDate();
        LocalDate afterDate = null;
        if (lastTrainedDateStr != null && !lastTrainedDateStr.isEmpty()) {
            try {
                // Parse date format (e.g., "2026-03-17")
                afterDate = LocalDate.parse(lastTrainedDateStr);
                System.out.println("[Prophet] Last trained date: " + lastTrainedDateStr + " (will fetch data after: " + afterDate + ")");
            } catch (Exception e) {
                System.out.println("[Prophet] Could not parse last_trained_date, fetching all data: " + e.getMessage());
            }
        } else {
            System.out.println("[Prophet] No last_trained_date from server, fetching all data");
        }

        // Step 3: Extract daily revenue AFTER last trained date
        List<SalesDataService.DailyRevenue> revenues = salesDataService.getDailyRevenueData(afterDate);

        // Step 4: Submit retrain job only if new data exists and is not blank
        String csvContent = null;
        if (!revenues.isEmpty()) {
            csvContent = salesDataService.exportAsCSV(revenues);
            // Check if CSV is actually not blank/whitespace
            if (csvContent == null || csvContent.trim().isEmpty()) {
                System.out.println("[Prophet] CSV content is blank. Skipping retrain, using existing model for prediction.");
            } else {
                System.out.println("[Prophet] Extracted " + revenues.size() + " days of NEW revenue data");
                System.out.println("[Prophet] CSV content length: " + csvContent.length() + " bytes");
                System.out.println("[Prophet] CSV first entry: " + (revenues.isEmpty() ? "EMPTY" : revenues.get(0).date + "," + revenues.get(0).totalRevenue));
                String retrainJobId = prophetClient.submitRetrainJob(csvContent);
                System.out.println("[Prophet] Submitted retrain job: " + retrainJobId);

                // Step 5: Wait for retrain completion
                ProphetClient.JobStatus retrainStatus = waitForJobCompletion(retrainJobId, "retrain");
                if (retrainStatus.isError()) {
                    throw new Exception("Retrain job failed: " + retrainStatus.message);
                }
                System.out.println("[Prophet] Retrain completed successfully");
            }
        } else {
            System.out.println("[Prophet] No new revenue data available (since last training). Skipping retrain, using existing model for prediction.");
        }

        // Step 6: Submit predict job (always, with or without retrain)
        String predictJobId = prophetClient.submitPredictJob(forecastMonths);
        System.out.println("[Prophet] Submitted predict job: " + predictJobId);

        // Step 7: Wait for predict completion
        ProphetClient.JobStatus predictStatus = waitForJobCompletion(predictJobId, "predict");
        if (predictStatus.isError()) {
            throw new Exception("Predict job failed: " + predictStatus.message);
        }
        System.out.println("[Prophet] Predict completed successfully");

        // Step 8: Build result
        ForecastResult result = new ForecastResult();
        result.jobId = predictJobId;
        result.outputFolder = predictStatus.getOutputFolder();
        result.predictedAt = LocalDateTime.now();

        // Locate output files
        if (result.outputFolder != null) {
            Path outputPath = Paths.get(result.outputFolder);
            result.forecastPlotPath = outputPath.resolve("forecast_plot.png").toString();
            result.monthlyBarPath = outputPath.resolve("monthly_bar.png").toString();
            result.componentsPlotPath = outputPath.resolve("components_plot.png").toString();
            result.monthlyCSVPath = outputPath.resolve("forecast_monthly.csv").toString();
        }

        System.out.println("[Prophet] Forecast cycle completed: " + result);
        return result;
    }

    /**
     * Poll job status until completion or timeout
     */
    private ProphetClient.JobStatus waitForJobCompletion(String jobId, String jobType)
            throws IOException, InterruptedException {
        long startTime = System.currentTimeMillis();

        while (true) {
            ProphetClient.JobStatus status = prophetClient.getJobStatus(jobId);

            if (status.isDone() || status.isError()) {
                return status;
            }

            // Check timeout
            long elapsed = System.currentTimeMillis() - startTime;
            if (elapsed > POLL_TIMEOUT_MS) {
                throw new IOException("Job " + jobId + " timed out after 5 minutes");
            }

            System.out.println("[Prophet] " + jobType + " job " + jobId + " status: " + status.status);
            Thread.sleep(POLL_INTERVAL_MS);
        }
    }

    /**
     * Check if output files exist and are accessible
     */
    public boolean verifyOutputFiles(ForecastResult result) {
        if (result.forecastPlotPath == null) {
            return false;
        }

        return new File(result.forecastPlotPath).exists() &&
               new File(result.monthlyBarPath).exists() &&
               new File(result.componentsPlotPath).exists() &&
               new File(result.monthlyCSVPath).exists();
    }

    /**
     * Read file content as base64 for embedding in HTML (images)
     */
    public String readFileAsBase64(String filePath) throws IOException {
        byte[] fileContent = Files.readAllBytes(Paths.get(filePath));
        return java.util.Base64.getEncoder().encodeToString(fileContent);
    }
}
