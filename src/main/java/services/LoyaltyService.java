package services;

import dao.PointHistoryDAO;
import java.time.LocalDateTime;
import java.util.List;
import models.PointHistory;
import models.User;
import util.JpaHelper;

public class LoyaltyService {

    private final PointHistoryDAO pointHistoryDAO = new PointHistoryDAO();

    public void addPoints(int userId, int orderId, double amount) {
        int rate = new LoyaltyConfigService().getPointRate();
        int points = (int) (amount / 1000) * rate;

        JpaHelper.execute(em -> {
            User user = em.find(User.class, userId);
            if (user == null) return;

            if (user.getPointResetDate() == null) {
                user.setPointResetDate(LocalDateTime.now());
            }
            user.setPoints(user.getPoints() + points);
            user.setLastPurchaseDate(LocalDateTime.now());
            updateTier(user);
            em.merge(user);

            em.persist(new PointHistory(userId, orderId, amount, points, "EARN"));
        });
    }

    public void usePoints(int userId, int orderId, int points) {
        if (points <= 0) return;

        JpaHelper.execute(em -> {
            User user = em.find(User.class, userId);
            if (user == null) return;

            int newPoints = Math.max(0, user.getPoints() - points);
            user.setPoints(newPoints);
            updateTier(user);
            em.merge(user);

            em.persist(new PointHistory(userId, orderId, 0.0, -points, "USE"));
        });
    }

    public void refundPoints(int userId, int orderId) {
        JpaHelper.execute(em -> {
            User user = em.find(User.class, userId);
            if (user == null) return;

            List<PointHistory> histories = em.createQuery(
                    "SELECT p FROM PointHistory p WHERE p.orderId = :oid",
                    PointHistory.class)
                    .setParameter("oid", orderId)
                    .getResultList();

            int totalRefund = 0;
            for (PointHistory h : histories) {
                totalRefund += -h.getPointsEarned();
            }

            if (totalRefund == 0) return;

            user.setPoints(user.getPoints() + totalRefund);
            updateTier(user);
            em.merge(user);

            em.persist(new PointHistory(userId, orderId, 0.0, totalRefund, "REFUND"));
        });
    }

    public List<PointHistory> getPointHistoryByUser(int userId) {
        return pointHistoryDAO.findByUserId(userId);
    }

    private void updateTier(User user) {
        int p = user.getPoints();
        if      (p >= 200000) user.setMembershipTier("Diamond");
        else if (p >= 100000) user.setMembershipTier("Platinum");
        else if (p >= 50000)  user.setMembershipTier("Gold");
        else if (p >= 20000)  user.setMembershipTier("Silver");
        else if (p >= 10000)  user.setMembershipTier("Bronze");
        else                  user.setMembershipTier("Regular");
    }
}
