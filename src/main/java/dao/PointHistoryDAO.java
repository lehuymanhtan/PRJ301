package dao;

import java.util.List;
import models.PointHistory;
import util.JpaHelper;

public class PointHistoryDAO {

    public void insert(PointHistory history) {
        JpaHelper.execute(em -> em.persist(history));
    }

    public List<PointHistory> findByUserId(int userId) {
        return JpaHelper.query(em
                -> em.createQuery(
                        "SELECT p FROM PointHistory p WHERE p.userId = :uid ORDER BY p.createdAt DESC",
                        PointHistory.class)
                        .setParameter("uid", userId)
                        .getResultList()
        );
    }

    public long countByUserId(int userId) {
        return JpaHelper.query(em ->
            em.createQuery("SELECT COUNT(p) FROM PointHistory p WHERE p.userId = :uid", Long.class)
              .setParameter("uid", userId)
              .getSingleResult()
        );
    }

    public List<PointHistory> findPageByUserId(int userId, int pageNumber, int pageSize) {
        int offset = (pageNumber - 1) * pageSize;
        return JpaHelper.query(em ->
            em.createQuery(
                "SELECT p FROM PointHistory p WHERE p.userId = :uid ORDER BY p.createdAt DESC",
                PointHistory.class)
              .setParameter("uid", userId)
              .setFirstResult(offset)
              .setMaxResults(pageSize)
              .getResultList()
        );
    }
}
