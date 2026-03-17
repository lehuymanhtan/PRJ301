package models;

public class TierStatistic {

    private String tier;
    private Long total;

    public TierStatistic(String tier, Long total) {
        this.tier = tier;
        this.total = total;
    }

    public String getTier() { return tier; }
    public Long getTotal() { return total; }
}
