package services;

import java.util.List;
import models.TierStatistic;
import util.JpaHelper;

public class LoyaltyReportService {

    public List<TierStatistic> getTierStatistics() {
        return JpaHelper.query(em
                -> em.createQuery(
                        "SELECT new models.TierStatistic(u.membershipTier, COUNT(u)) "
                        + "FROM User u WHERE u.role = 'user' GROUP BY u.membershipTier",
                        TierStatistic.class)
                        .getResultList()
        );
    }
}
