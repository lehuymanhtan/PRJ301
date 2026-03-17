package models;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import services.ProphetForecastService;

/**
 * JPA Entity for storing Prophet forecast metadata
 */
@Entity
@Table(name = "ProphetForecasts")
public class ProphetForecast {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    public int id;

    @Column(name = "jobId", nullable = false, length = 100)
    public String jobId;

    @Column(name = "outputFolder", nullable = true, length = 500)
    public String outputFolder;

    @Column(name = "forecastPlotPath", nullable = true, length = 500)
    public String forecastPlotPath;

    @Column(name = "monthlyBarPath", nullable = true, length = 500)
    public String monthlyBarPath;

    @Column(name = "componentsPlotPath", nullable = true, length = 500)
    public String componentsPlotPath;

    @Column(name = "monthlyCSVPath", nullable = true, length = 500)
    public String monthlyCSVPath;

    @Column(name = "predictedAt", nullable = false)
    public LocalDateTime predictedAt;

    @Column(name = "status", nullable = false, length = 20)
    public String status; // completed, error

    @Column(name = "errorMessage", nullable = true, length = 1000)
    public String errorMessage;

    @Column(name = "createdAt", nullable = false, insertable = false, updatable = false, columnDefinition = "DATETIME2 DEFAULT GETDATE()")
    public LocalDateTime createdAt;

    public ProphetForecast() {}

    public ProphetForecast(String jobId, String outputFolder, LocalDateTime predictedAt, String status) {
        this.jobId = jobId;
        this.outputFolder = outputFolder;
        this.predictedAt = predictedAt;
        this.status = status;
    }

    /**
     * Convert to ForecastResult for service usage
     */
    public ProphetForecastService.ForecastResult convertToResult() {
        ProphetForecastService.ForecastResult result = new ProphetForecastService.ForecastResult();
        result.jobId = this.jobId;
        result.outputFolder = this.outputFolder;
        result.predictedAt = this.predictedAt;
        result.forecastPlotPath = this.forecastPlotPath;
        result.monthlyBarPath = this.monthlyBarPath;
        result.componentsPlotPath = this.componentsPlotPath;
        result.monthlyCSVPath = this.monthlyCSVPath;
        return result;
    }
}
