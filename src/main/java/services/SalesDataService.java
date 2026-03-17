package services;

import util.JpaHelper;
import java.time.LocalDate;
import java.util.*;

public class SalesDataService {

    /**
     * DailyRevenue DTO for daily income data
     */
    public static class DailyRevenue {
        public LocalDate date;
        public long totalRevenue; // in VND

        public DailyRevenue(LocalDate date, long totalRevenue) {
            this.date = date;
            this.totalRevenue = totalRevenue;
        }

        @Override
        public String toString() {
            return date + "," + totalRevenue;
        }
    }

    /**
     * Extract daily revenue from vw_DailyIncome view
     * Combines completed income + pending income
     * Returns list sorted by date ascending
     */
    public List<DailyRevenue> getDailyRevenueData() {
        return getDailyRevenueData(null);
    }

    /**
     * Extract daily revenue from vw_DailyIncome view after a specific date
     * @param afterDate if not null, only return data after this date
     * Returns list sorted by date ascending
     */
    public List<DailyRevenue> getDailyRevenueData(LocalDate afterDate) {
        return JpaHelper.query(em -> {
            String query = "SELECT incomeDate, completedIncome, pendingIncome " +
                          "FROM vw_DailyIncome " +
                          "ORDER BY incomeDate ASC";
            var results = em.createNativeQuery(query)
                    .getResultList();

            List<DailyRevenue> revenues = new ArrayList<>();
            for (Object result : results) {
                Object[] row = (Object[]) result;
                java.sql.Date sqlDate = (java.sql.Date) row[0];
                LocalDate date = sqlDate.toLocalDate();

                // Skip data before afterDate if specified
                if (afterDate != null && !date.isAfter(afterDate)) {
                    continue;
                }

                Double completed = row[1] != null ? ((Number) row[1]).doubleValue() : 0;
                Double pending = row[2] != null ? ((Number) row[2]).doubleValue() : 0;
                long total = (long) (completed + pending);

                revenues.add(new DailyRevenue(date, total));
            }
            return revenues;
        });
    }

    /**
     * Export daily revenue as CSV string for Prophet retrain endpoint
     * Format: date,revenue (no header)
     */
    public String exportAsCSV(List<DailyRevenue> revenues) {
        StringBuilder csv = new StringBuilder();
        for (DailyRevenue rev : revenues) {
            csv.append(rev.date).append(",").append(rev.totalRevenue).append("\n");
        }
        return csv.toString();
    }
}
