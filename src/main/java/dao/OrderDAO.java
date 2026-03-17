package dao;

import models.DailyIncome;
import models.MonthlyIncome;
import models.Order;
import models.OrderDetail;
import models.YearlyIncome;
import util.JpaHelper;
import java.sql.Date;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO {

    // ── Queries ──────────────────────────────────────────────────────────

    public List<Order> findAll() {
        return JpaHelper.query(em ->
            em.createQuery(
                "SELECT o FROM Order o WHERE o.status <> 'Deleted' ORDER BY o.id DESC",
                Order.class
            ).getResultList()
        );
    }

    public List<Order> findByUserId(Integer userId) {
        return JpaHelper.query(em ->
            em.createQuery(
                "SELECT o FROM Order o WHERE o.userId = :uid AND o.status <> 'Deleted' ORDER BY o.id DESC",
                Order.class
            ).setParameter("uid", userId).getResultList()
        );
    }

    public long countAll() {
        return JpaHelper.query(em ->
            em.createQuery(
                "SELECT COUNT(o) FROM Order o WHERE o.status <> 'Deleted'",
                Long.class
            ).getSingleResult()
        );
    }

    public List<Order> findPage(int pageNumber, int pageSize) {
        int offset = (pageNumber - 1) * pageSize;
        return JpaHelper.query(em ->
            em.createQuery(
                "SELECT o FROM Order o WHERE o.status <> 'Deleted' ORDER BY o.id DESC",
                Order.class
            ).setFirstResult(offset)
             .setMaxResults(pageSize)
             .getResultList()
        );
    }

    public Order findById(Integer id) {
        return JpaHelper.query(em ->
            em.createQuery(
                "SELECT o FROM Order o WHERE o.id = :id AND o.status <> 'Deleted'",
                Order.class
            ).setParameter("id", id).getResultStream().findFirst().orElse(null)
        );
    }

    public List<OrderDetail> findDetailsByOrderId(Integer orderId) {
        return JpaHelper.query(em ->
            em.createQuery(
                "SELECT d FROM OrderDetail d WHERE d.orderId = :oid ORDER BY d.id",
                OrderDetail.class
            ).setParameter("oid", orderId).getResultList()
        );
    }

    /**
     * Returns daily income rows from the vw_DailyIncome view,
     * ordered by date descending (most recent first).
     */
    @SuppressWarnings("unchecked")
    public List<DailyIncome> getDailyIncome() {
        return JpaHelper.query(em -> {
            List<Object[]> rows = em.createNativeQuery(
                "SELECT incomeDate, completedIncome, pendingIncome " +
                "FROM vw_DailyIncome " +
                "ORDER BY incomeDate DESC"
            ).getResultList();
            List<DailyIncome> result = new ArrayList<>(rows.size());
            for (Object[] row : rows) {
                java.time.LocalDate date = ((Date) row[0]).toLocalDate();
                double completed = row[1] == null ? 0.0 : ((Number) row[1]).doubleValue();
                double pending   = row[2] == null ? 0.0 : ((Number) row[2]).doubleValue();
                result.add(new DailyIncome(date, completed, pending));
            }
            return result;
        });
    }

    /**
     * Returns daily income rows for the last {@code days} days (inclusive today),
     * ordered by date ascending.
     */
    @SuppressWarnings("unchecked")
    public List<DailyIncome> getDailyIncomeRange(int days) {
        LocalDate from = LocalDate.now().minusDays(days - 1);
        return JpaHelper.query(em -> {
            List<Object[]> rows = em.createNativeQuery(
                "SELECT incomeDate, completedIncome, pendingIncome " +
                "FROM vw_DailyIncome " +
                "WHERE incomeDate >= :fromDate " +
                "ORDER BY incomeDate ASC"
            ).setParameter("fromDate", Date.valueOf(from))
             .getResultList();
            List<DailyIncome> result = new ArrayList<>(rows.size());
            for (Object[] row : rows) {
                LocalDate date   = ((Date) row[0]).toLocalDate();
                double completed = row[1] == null ? 0.0 : ((Number) row[1]).doubleValue();
                double pending   = row[2] == null ? 0.0 : ((Number) row[2]).doubleValue();
                result.add(new DailyIncome(date, completed, pending));
            }
            return result;
        });
    }

    /**
     * Returns income grouped by month for the last {@code months} calendar months
     * (starting from the 1st of the month {@code months-1} months ago), ordered ascending.
     */
    @SuppressWarnings("unchecked")
    public List<MonthlyIncome> getMonthlyIncome(int months) {
        LocalDate from = LocalDate.now().withDayOfMonth(1).minusMonths(months - 1);
        return JpaHelper.query(em -> {
            List<Object[]> rows = em.createNativeQuery(
                "SELECT YEAR(createdAt), MONTH(createdAt), " +
                "SUM(CASE WHEN status = 'Completed' THEN totalPrice ELSE 0 END), " +
                "SUM(CASE WHEN status IN ('Pending','Processing','Shipped','Delivered') THEN totalPrice ELSE 0 END) " +
                "FROM Orders " +
                "WHERE status NOT IN ('Cancelled','Deleted') AND createdAt >= :fromDate " +
                "GROUP BY YEAR(createdAt), MONTH(createdAt) " +
                "ORDER BY YEAR(createdAt) ASC, MONTH(createdAt) ASC"
            ).setParameter("fromDate", Date.valueOf(from))
             .getResultList();
            List<MonthlyIncome> result = new ArrayList<>(rows.size());
            for (Object[] row : rows) {
                int year     = ((Number) row[0]).intValue();
                int month    = ((Number) row[1]).intValue();
                double comp  = row[2] == null ? 0.0 : ((Number) row[2]).doubleValue();
                double pend  = row[3] == null ? 0.0 : ((Number) row[3]).doubleValue();
                result.add(new MonthlyIncome(year, month, comp, pend));
            }
            return result;
        });
    }

    /**
     * Returns income grouped by year for the last {@code years} calendar years
     * (starting from Jan 1 of the year {@code years-1} years ago), ordered ascending.
     */
    @SuppressWarnings("unchecked")
    public List<YearlyIncome> getYearlyIncome(int years) {
        LocalDate from = LocalDate.of(LocalDate.now().getYear() - (years - 1), 1, 1);
        return JpaHelper.query(em -> {
            List<Object[]> rows = em.createNativeQuery(
                "SELECT YEAR(createdAt), " +
                "SUM(CASE WHEN status = 'Completed' THEN totalPrice ELSE 0 END), " +
                "SUM(CASE WHEN status IN ('Pending','Processing','Shipped','Delivered') THEN totalPrice ELSE 0 END) " +
                "FROM Orders " +
                "WHERE status NOT IN ('Cancelled','Deleted') AND createdAt >= :fromDate " +
                "GROUP BY YEAR(createdAt) " +
                "ORDER BY YEAR(createdAt) ASC"
            ).setParameter("fromDate", Date.valueOf(from))
             .getResultList();
            List<YearlyIncome> result = new ArrayList<>(rows.size());
            for (Object[] row : rows) {
                int year    = ((Number) row[0]).intValue();
                double comp = row[1] == null ? 0.0 : ((Number) row[1]).doubleValue();
                double pend = row[2] == null ? 0.0 : ((Number) row[2]).doubleValue();
                result.add(new YearlyIncome(year, comp, pend));
            }
            return result;
        });
    }

    // ── Mutations ─────────────────────────────────────────────────────────

    /**
     * Persists a new Order and returns its generated id.
     * After calling this, {@code order.getId()} is populated.
     */
    public Integer insert(Order order) {
        JpaHelper.execute(em -> em.persist(order));
        return order.getId();
    }

    public void insertDetail(OrderDetail detail) {
        JpaHelper.execute(em -> em.persist(detail));
    }

    public void update(Order order) {
        JpaHelper.execute(em -> em.merge(order));
    }

    /** Soft-deletes: sets status to 'Deleted'. */
    public void delete(Integer id) {
        JpaHelper.execute(em -> {
            Order o = em.find(Order.class, id);
            if (o != null) {
                o.setStatus("Deleted");
                em.merge(o);
            }
        });
    }
}
