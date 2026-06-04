package group36.listener;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import java.util.TimeZone;

@WebListener
public class AppInitListener implements ServletContextListener {
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        // Set JVM timezone to Vietnam to ensure consistent dates
        TimeZone.setDefault(TimeZone.getTimeZone("Asia/Ho_Chi_Minh"));
        System.out.println("[AppInitListener] JVM TimeZone initialized to Asia/Ho_Chi_Minh");
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        // Nothing to do
    }
}
