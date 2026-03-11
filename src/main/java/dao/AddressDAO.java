package dao;

import models.UserAddress;
import util.JpaHelper;
import java.util.List;

public class AddressDAO {

    public List<UserAddress> findByUserId(int userId) {
        return JpaHelper.query(em ->
            em.createQuery(
                "SELECT a FROM UserAddress a WHERE a.userId = :uid ORDER BY a.isDefault DESC, a.createdAt DESC",
                UserAddress.class)
              .setParameter("uid", userId)
              .getResultList()
        );
    }

    public UserAddress findById(int id) {
        return JpaHelper.query(em -> em.find(UserAddress.class, id));
    }

    public UserAddress findDefaultByUserId(int userId) {
        List<UserAddress> result = JpaHelper.query(em ->
            em.createQuery(
                "SELECT a FROM UserAddress a WHERE a.userId = :uid AND a.isDefault = true",
                UserAddress.class)
              .setParameter("uid", userId)
              .setMaxResults(1)
              .getResultList()
        );
        return result.isEmpty() ? null : result.get(0);
    }

    public long countByUserId(int userId) {
        return JpaHelper.query(em ->
            em.createQuery("SELECT COUNT(a) FROM UserAddress a WHERE a.userId = :uid", Long.class)
              .setParameter("uid", userId)
              .getSingleResult()
        );
    }

    public void insert(UserAddress address) {
        JpaHelper.execute(em -> em.persist(address));
    }

    public void update(UserAddress address) {
        JpaHelper.execute(em -> em.merge(address));
    }

    public void delete(int id) {
        JpaHelper.execute(em -> {
            UserAddress a = em.find(UserAddress.class, id);
            if (a != null) em.remove(a);
        });
    }

    /** Sets isDefault = false for all addresses belonging to the user. */
    public void clearDefault(int userId) {
        JpaHelper.execute(em ->
            em.createQuery("UPDATE UserAddress a SET a.isDefault = false WHERE a.userId = :uid")
              .setParameter("uid", userId)
              .executeUpdate()
        );
    }
}
