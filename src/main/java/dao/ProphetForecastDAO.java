package dao;

import models.ProphetForecast;
import util.JpaHelper;
import java.util.List;

/**
 * DAO for ProphetForecast entity
 */
public class ProphetForecastDAO {

    public void save(ProphetForecast forecast) {
        JpaHelper.execute(em -> em.persist(forecast));
    }

    /**
     * Get the most recent completed forecast
     */
    public ProphetForecast getLatestForecast() {
        return JpaHelper.query(em ->
            em.createQuery(
                    "SELECT p FROM ProphetForecast p WHERE p.status = 'completed' ORDER BY p.predictedAt DESC",
                    ProphetForecast.class)
                    .setMaxResults(1)
                    .getResultList()
                    .stream()
                    .findFirst()
                    .orElse(null)
        );
    }

    /**
     * Get all forecasts, ordered by most recent first
     */
    public List<ProphetForecast> getAllForecasts() {
        return JpaHelper.query(em ->
            em.createQuery(
                    "SELECT p FROM ProphetForecast p ORDER BY p.predictedAt DESC",
                    ProphetForecast.class)
                    .getResultList()
        );
    }

    /**
     * Get completed forecasts only
     */
    public List<ProphetForecast> getCompletedForecasts() {
        return JpaHelper.query(em ->
            em.createQuery(
                    "SELECT p FROM ProphetForecast p WHERE p.status = 'completed' ORDER BY p.predictedAt DESC",
                    ProphetForecast.class)
                    .getResultList()
        );
    }
}
