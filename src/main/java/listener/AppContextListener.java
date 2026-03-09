package listener;

import io.github.cdimascio.dotenv.Dotenv;
import util.JpaHelper;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

/**
 * Loads configuration from WEB-INF/.env at startup,
 * then closes the JPA EntityManagerFactory on shutdown.
 */
@WebListener
public class AppContextListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        // Load .env from WEB-INF and publish values as System properties
        String webInfPath = sce.getServletContext().getRealPath("/WEB-INF");
        if (webInfPath != null) {
            try {
                Dotenv dotenv = Dotenv.configure()
                        .directory(webInfPath)
                        .filename(".env")
                        .ignoreIfMissing()
                        .load();
                String apiKey = dotenv.get("RESEND_API_KEY", "");
                System.setProperty("RESEND_API_KEY", apiKey);
                System.out.println("AppContextListener: .env loaded from " + webInfPath);
            } catch (Exception e) {
                System.err.println("AppContextListener: failed to load .env - " + e.getMessage());
            }
        }
        System.out.println("Application started. JPA EntityManagerFactory initialized.");
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        JpaHelper.close();
        System.out.println("Application stopped. JPA EntityManagerFactory closed.");
    }
}
