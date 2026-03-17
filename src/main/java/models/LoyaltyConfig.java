package models;

import jakarta.persistence.*;

@Entity
@Table(name = "LoyaltyConfig")
public class LoyaltyConfig {

    @Id
    private int id;

    private int pointRate;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getPointRate() { return pointRate; }
    public void setPointRate(int pointRate) { this.pointRate = pointRate; }
}
