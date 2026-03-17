package services;

import java.time.LocalDateTime;
import models.PointHistory;
import models.User;
import util.JpaHelper;

public class AdminLoyaltyService {

    public void adjustPoints(int userId, int points) {
        JpaHelper.execute(em -> {
            User user = em.find(User.class, userId);
            if (user == null) throw new RuntimeException("User not found");

            int newPoints = Math.max(0, user.getPoints() + points);
            user.setPoints(newPoints);

            // Recalculate tier after manual adjustment
            if      (newPoints >= 200000) user.setMembershipTier("Diamond");
            else if (newPoints >= 100000) user.setMembershipTier("Platinum");
            else if (newPoints >= 50000)  user.setMembershipTier("Gold");
            else if (newPoints >= 20000)  user.setMembershipTier("Silver");
            else if (newPoints >= 10000)  user.setMembershipTier("Bronze");
            else                          user.setMembershipTier("Regular");

            em.merge(user);

            PointHistory history = new PointHistory();
            history.setUserId(userId);
            history.setOrderId(null);
            history.setAmount(0.0);
            history.setPointsEarned(points);
            history.setType("Adjust");
            history.setCreatedAt(LocalDateTime.now());
            em.persist(history);
        });
    }

    public void changeTier(int userId, String tier) {
        JpaHelper.execute(em -> {
            User user = em.find(User.class, userId);
            if (user == null) throw new RuntimeException("User not found");
            user.setMembershipTier(tier);
            em.merge(user);
        });
    }
}
