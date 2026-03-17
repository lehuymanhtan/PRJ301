package dao;

import jakarta.persistence.NoResultException;
import models.UserAddress;
import util.JpaHelper;
import java.util.List;

public class AddressDAO {

    public List<UserAddress> findByUserId(Integer userId) {
        return JpaHelper.query(em ->
            em.createQuery(
                "SELECT a FROM UserAddress a WHERE a.userId = :userId ORDER BY a.isDefault DESC, a.id DESC",
                UserAddress.class)
              .setParameter("userId", userId)
              .getResultList()
        );
    }

    public UserAddress findById(Integer id) {
        return JpaHelper.query(em -> em.find(UserAddress.class, id));
    }

    public UserAddress findDefaultByUserId(Integer userId) {
        return JpaHelper.query(em -> {
            try {
                return em.createQuery(
                    "SELECT a FROM UserAddress a WHERE a.userId = :userId AND a.isDefault = true",
                    UserAddress.class)
                  .setParameter("userId", userId)
                  .getSingleResult();
            } catch (NoResultException e) {
                return null;
            }
        });
    }

    public long countByUserId(Integer userId) {
        return JpaHelper.query(em ->
            em.createQuery(
                "SELECT COUNT(a) FROM UserAddress a WHERE a.userId = :userId", Long.class)
              .setParameter("userId", userId)
              .getSingleResult()
        );
    }

    public void insert(UserAddress address) {
        JpaHelper.execute(em -> em.persist(address));
    }

    public void update(UserAddress address) {
        JpaHelper.execute(em -> em.merge(address));
    }

    public void delete(Integer id) {
        JpaHelper.execute(em -> {
            UserAddress address = em.find(UserAddress.class, id);
            if (address != null) em.remove(address);
        });
    }

    public void clearDefault(Integer userId) {
        JpaHelper.execute(em ->
            em.createQuery("UPDATE UserAddress a SET a.isDefault = false WHERE a.userId = :userId")
              .setParameter("userId", userId)
              .executeUpdate()
        );
    }
}
