package services;

import models.LoyaltyConfig;
import util.JpaHelper;

public class LoyaltyConfigService {

    public int getPointRate() {
        LoyaltyConfig config = JpaHelper.query(em -> em.find(LoyaltyConfig.class, 1));
        return (config == null) ? 1 : config.getPointRate();
    }

    public void updatePointRate(int newRate) {
        JpaHelper.execute(em -> {
            LoyaltyConfig config = em.find(LoyaltyConfig.class, 1);
            if (config == null) {
                config = new LoyaltyConfig();
                config.setId(1);
            }
            config.setPointRate(newRate);
            em.merge(config);
        });
    }
}
