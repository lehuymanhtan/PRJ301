package util;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import java.util.logging.Logger;

/**
 * Initializes Quartz scheduler and Prophet server on application startup
 */
@WebListener
public class AppStartupListener implements ServletContextListener {
    private static final Logger logger = Logger.getLogger(AppStartupListener.class.getName());

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        try {
            logger.info("========== Application Startup ==========");

            // Initialize Quartz scheduler for daily forecasts
            QuartzSchedulerInitializer.initializeScheduler();

            logger.info("========== Application Ready ==========");
        } catch (Exception e) {
            logger.severe("Error during application startup: " + e.getMessage());
            e.printStackTrace();
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        logger.info("========== Application Shutdown ==========");

        // Shutdown Quartz scheduler
        QuartzSchedulerInitializer.shutdownScheduler();

        logger.info("========== Application Stopped ==========");
    }
}
