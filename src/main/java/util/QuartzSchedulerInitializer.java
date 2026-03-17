package util;

import jobs.DailyForecastJob;
import org.quartz.*;
import org.quartz.impl.StdSchedulerFactory;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Initializes Quartz scheduler for daily forecast job
 * Runs daily at 2 AM
 */
public class QuartzSchedulerInitializer {
    private static final Logger logger = Logger.getLogger(QuartzSchedulerInitializer.class.getName());
    private static Scheduler scheduler;
    private static boolean initialized = false;

    /**
     * Initialize the Quartz scheduler with the DailyForecastJob
     * Should be called once during application startup
     */
    public static synchronized void initializeScheduler() {
        if (initialized) {
            logger.info("Quartz scheduler already initialized");
            return;
        }

        try {
            // Create scheduler factory and scheduler
            SchedulerFactory schedulerFactory = new StdSchedulerFactory();
            scheduler = schedulerFactory.getScheduler();

            // Create job detail
            JobDetail job = JobBuilder.newJob(DailyForecastJob.class)
                    .withIdentity("dailyForecastJob", "forecasts")
                    .build();

            // Create trigger: runs daily at 2 AM
            Trigger trigger = TriggerBuilder.newTrigger()
                    .withIdentity("dailyForecastTrigger", "forecasts")
                    .startNow()
                    .withSchedule(CronScheduleBuilder.dailyAtHourAndMinute(2, 0))
                    .build();

            // Schedule the job
            scheduler.scheduleJob(job, trigger);

            // Start scheduler
            scheduler.start();

            initialized = true;
            logger.info("Quartz scheduler initialized successfully. DailyForecastJob scheduled for 2 AM daily");

        } catch (SchedulerException e) {
            logger.log(Level.SEVERE, "Failed to initialize Quartz scheduler", e);
        }
    }

    /**
     * Shutdown the scheduler (should be called during application shutdown)
     */
    public static synchronized void shutdownScheduler() {
        if (scheduler != null) {
            try {
                scheduler.shutdown();
                logger.info("Quartz scheduler shut down successfully");
            } catch (SchedulerException e) {
                logger.log(Level.SEVERE, "Error shutting down scheduler", e);
            }
        }
    }

    /**
     * Manually trigger the forecast job immediately (for testing/debugging)
     */
    public static void triggerForecastNow() throws SchedulerException {
        if (scheduler == null) {
            throw new SchedulerException("Scheduler not initialized");
        }

        JobKey jobKey = new JobKey("dailyForecastJob", "forecasts");
        scheduler.triggerJob(jobKey);
        logger.info("DailyForecastJob triggered manually");
    }

    /**
     * Check if scheduler is running
     */
    public static boolean isSchedulerRunning() {
        try {
            return scheduler != null && scheduler.isStarted() && !scheduler.isShutdown();
        } catch (SchedulerException e) {
            return false;
        }
    }
}
