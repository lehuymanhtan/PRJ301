package services;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.io.*;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.util.*;
import java.util.logging.Logger;
import org.apache.hc.client5.http.classic.methods.HttpPost;
import org.apache.hc.client5.http.entity.mime.InputStreamBody;
import org.apache.hc.client5.http.entity.mime.MultipartEntityBuilder;
import org.apache.hc.client5.http.impl.classic.CloseableHttpClient;
import org.apache.hc.client5.http.impl.classic.HttpClients;
import org.apache.hc.core5.http.HttpEntity;

/**
 * Client to communicate with Prophet FastAPI server running on localhost:8000
 */
public class ProphetClient {
    private static final String BASE_URL = "http://localhost:8000";
    private static final ObjectMapper mapper = new ObjectMapper();
    private static final Logger logger = Logger.getLogger(ProphetClient.class.getName());
    private final HttpClient httpClient;

    public ProphetClient() {
        this.httpClient = HttpClient.newBuilder()
                // Uvicorn on plain HTTP expects HTTP/1.1; forcing avoids intermittent
                // malformed-request issues when clients attempt HTTP/2 negotiation.
                .version(HttpClient.Version.HTTP_1_1)
                .connectTimeout(java.time.Duration.ofSeconds(10))
                .build();
    }

    /**
     * DTO for job status response
     */
    public static class JobStatus {
        public String job_id;
        public String type;
        public String status; // pending, running, done, error
        public String message;
        public JsonNode result;

        public boolean isDone() {
            return "done".equals(status);
        }

        public boolean isError() {
            return "error".equals(status);
        }

        public String getOutputFolder() {
            if (result != null && result.has("output_folder")) {
                return result.get("output_folder").asText();
            }
            return null;
        }
    }

    /**
     * Check if Prophet server is running and get last trained date
     * @return last_trained_date as String (ISO format) or null if not available
     */
    public String getLastTrainedDate() {
        try {
            var request = HttpRequest.newBuilder()
                    .uri(URI.create(BASE_URL + "/model/info"))
                    .GET()
                    .build();
            var response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());
            if (response.statusCode() == 200) {
                JsonNode json = mapper.readTree(response.body());
                if (json.has("last_trained_date")) {
                    return json.get("last_trained_date").asText();
                }
            }
            return null;
        } catch (Exception e) {
            return null;
        }
    }

    /**
     * Check if Prophet server is running
     */
    public boolean isServerRunning() {
        try {
            var request = HttpRequest.newBuilder()
                    .uri(URI.create(BASE_URL + "/model/info"))
                    .GET()
                    .build();
            var response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());
            return response.statusCode() == 200;
        } catch (Exception e) {
            return false;
        }
    }

    /**
     * Submit retrain job with CSV data using Apache HttpClient for proper multipart upload
     * Uses in-memory ByteArrayInputStream to avoid file I/O issues
     * @param csvContent CSV content (date,revenue format, no header)
     * @return job_id
     */
    public String submitRetrainJob(String csvContent) throws IOException {
        logger.info("[Prophet] CSV Content to send: " + csvContent.length() + " bytes");
        logger.info("[Prophet] CSV Content (first 200 chars): " + csvContent.substring(0, Math.min(200, csvContent.length())));

        // Convert CSV content to bytes
        byte[] csvBytes = csvContent.getBytes(StandardCharsets.UTF_8);

        // Use Apache HttpClient for proper multipart upload with in-memory stream
        try (CloseableHttpClient httpClient = HttpClients.createDefault()) {
            HttpPost httpPost = new HttpPost(BASE_URL + "/retrain");

            // Build multipart entity using input stream (no file I/O needed)
            MultipartEntityBuilder builder = MultipartEntityBuilder.create();
            builder.addPart("file", new InputStreamBody(
                    new ByteArrayInputStream(csvBytes),
                    org.apache.hc.core5.http.ContentType.TEXT_PLAIN,
                    "sales_data.csv"
            ));
            HttpEntity entity = builder.build();

            httpPost.setEntity(entity);

            logger.info("[Prophet] Sending retrain request to " + BASE_URL + "/retrain");

            // Execute request
            var response = httpClient.execute(httpPost, httpResponse -> {
                String body = new String(httpResponse.getEntity().getContent().readAllBytes(), StandardCharsets.UTF_8);
                int statusCode = httpResponse.getCode();
                logger.info("[Prophet] Retrain response status: " + statusCode);

                if (statusCode != 202) {
                    logger.severe("[Prophet] Retrain failed: " + body);
                    throw new IOException("Failed to submit retrain job: " + statusCode + " - " + body);
                }

                JsonNode responseJson = mapper.readTree(body);
                String jobId = responseJson.get("job_id").asText();
                logger.info("[Prophet] Retrain job submitted with ID: " + jobId);
                return jobId;
            });

            return response;
        }
    }

    /**
     * Submit predict job (generate 3-month forecast)
     * @return job_id
     */
    public String submitPredictJob(int months) throws IOException, InterruptedException {
        String requestBody = mapper.writeValueAsString(Map.of("months", months));

        var request = HttpRequest.newBuilder()
                .uri(URI.create(BASE_URL + "/predict"))
                .header("Content-Type", "application/json")
                .header("Accept", "application/json")
                .POST(HttpRequest.BodyPublishers.ofString(requestBody))
                .build();

        logger.info("[Prophet] Sending predict request to " + BASE_URL + "/predict with months=" + months);
        var response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());
        logger.info("[Prophet] Predict response status: " + response.statusCode());

        if (response.statusCode() != 202) {
            throw new IOException("Failed to submit predict job: " + response.statusCode() + " - " + response.body());
        }

        JsonNode responseJson = mapper.readTree(response.body());
        return responseJson.get("job_id").asText();
    }

    /**
     * Get job status by job_id
     */
    public JobStatus getJobStatus(String jobId) throws IOException, InterruptedException {
        var request = HttpRequest.newBuilder()
                .uri(URI.create(BASE_URL + "/jobs/" + jobId))
                .GET()
                .build();

        var response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());

        if (response.statusCode() != 200) {
            throw new IOException("Failed to get job status: " + response.statusCode());
        }

        return mapper.readValue(response.body(), JobStatus.class);
    }
}
