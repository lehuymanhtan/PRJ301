package dao;

import models.RefundRequest;
import util.JpaHelper;
import java.util.List;

public class RefundDAO {

    public List<RefundRequest> findAll() {
        return JpaHelper.query(em ->
            em.createQuery(
                "SELECT r FROM RefundRequest r ORDER BY r.createdAt DESC",
                RefundRequest.class
            ).getResultList()
        );
    }

    public long countAll() {
        return JpaHelper.query(em ->
            em.createQuery("SELECT COUNT(r) FROM RefundRequest r", Long.class)
              .getSingleResult()
        );
    }

    public List<RefundRequest> findPage(int pageNumber, int pageSize) {
        int offset = (pageNumber - 1) * pageSize;
        return JpaHelper.query(em ->
            em.createQuery("SELECT r FROM RefundRequest r ORDER BY r.createdAt DESC", RefundRequest.class)
              .setFirstResult(offset)
              .setMaxResults(pageSize)
              .getResultList()
        );
    }

    public RefundRequest findById(Integer id) {
        return JpaHelper.query(em ->
            em.createQuery(
                "SELECT r FROM RefundRequest r WHERE r.id = :id",
                RefundRequest.class
            ).setParameter("id", id).getResultStream().findFirst().orElse(null)
        );
    }

    /** Returns the single refund request for an order, or null if none exists. */
    public RefundRequest findByOrderId(Integer orderId) {
        return JpaHelper.query(em ->
            em.createQuery(
                "SELECT r FROM RefundRequest r WHERE r.orderId = :oid",
                RefundRequest.class
            ).setParameter("oid", orderId).getResultStream().findFirst().orElse(null)
        );
    }

    public List<RefundRequest> findByUserId(Integer userId) {
        return JpaHelper.query(em ->
            em.createQuery(
                "SELECT r FROM RefundRequest r WHERE r.userId = :uid ORDER BY r.createdAt DESC",
                RefundRequest.class
            ).setParameter("uid", userId).getResultList()
        );
    }

    public Integer insert(RefundRequest refund) {
        JpaHelper.execute(em -> em.persist(refund));
        return refund.getId();
    }

    public void update(RefundRequest refund) {
        JpaHelper.execute(em -> em.merge(refund));
    }
}
