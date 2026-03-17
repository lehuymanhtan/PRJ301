package dao;

import models.User;
import util.JpaHelper;
import jakarta.persistence.NoResultException;
import java.util.List;

public class UserDAO {

    public User login(String username, String password) {
        return JpaHelper.query(em -> {
            try {
                return em.createQuery(
                    "SELECT u FROM User u WHERE u.username = :username AND u.password = :password",
                    User.class)
                    .setParameter("username", username)
                    .setParameter("password", password)
                    .getSingleResult();
            } catch (NoResultException e) {
                return null;
            }
        });
    }

    public List<User> getAllUsers() {
        return JpaHelper.query(em ->
            em.createQuery("SELECT u FROM User u ORDER BY u.userId", User.class)
              .getResultList()
        );
    }

    public List<User> searchUserByName(String keyword) {
        return JpaHelper.query(em ->
            em.createQuery(
                "SELECT u FROM User u WHERE LOWER(u.username) LIKE LOWER(:keyword) ORDER BY u.userId",
                User.class)
              .setParameter("keyword", "%" + keyword + "%")
              .getResultList()
        );
    }

    public User findById(Integer userId) {
        return JpaHelper.query(em -> em.find(User.class, userId));
    }

    public User findByUsername(String username) {
        return JpaHelper.query(em -> {
            try {
                return em.createQuery(
                    "SELECT u FROM User u WHERE u.username = :username", User.class)
                    .setParameter("username", username)
                    .getSingleResult();
            } catch (NoResultException e) {
                return null;
            }
        });
    }

    public User findByEmail(String email) {
        return JpaHelper.query(em -> {
            try {
                return em.createQuery(
                    "SELECT u FROM User u WHERE u.email = :email", User.class)
                    .setParameter("email", email)
                    .getSingleResult();
            } catch (jakarta.persistence.NoResultException e) {
                return null;
            }
        });
    }

    public User findByVerificationToken(String token) {
        return JpaHelper.query(em -> {
            try {
                return em.createQuery(
                    "SELECT u FROM User u WHERE u.verificationToken = :token", User.class)
                    .setParameter("token", token)
                    .getSingleResult();
            } catch (jakarta.persistence.NoResultException e) {
                return null;
            }
        });
    }

    public void insertUser(User user) {
        JpaHelper.execute(em -> em.persist(user));
    }

    public void updateUser(User user) {
        JpaHelper.execute(em -> em.merge(user));
    }

    public void deleteUser(Integer userId) {
        JpaHelper.execute(em -> {
            // Nullify userId on the user's orders to preserve order history
            // (userId is now nullable so this satisfies the FK constraint).
            em.createQuery("UPDATE Order o SET o.userId = NULL WHERE o.userId = :uid")
              .setParameter("uid", userId)
              .executeUpdate();

            User user = em.find(User.class, userId);
            if (user != null) em.remove(user);
        });
    }
}
