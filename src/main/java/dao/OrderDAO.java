package dao;

import models.DailyIncome;
import models.Order;
import models.OrderDetail;
import util.JpaHelper;
import java.sql.Date;
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
