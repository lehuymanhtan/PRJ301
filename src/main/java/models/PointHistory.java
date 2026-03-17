package models;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "PointHistory")
public class PointHistory {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    private Integer userId;

    private Integer orderId;

    private Double amount;

    private Integer pointsEarned;

    @Column(name = "type")
    private String type; // EARN | USE | REFUND | Adjust

    private LocalDateTime createdAt;

    public PointHistory() {}

    public PointHistory(Integer userId, Integer orderId, Double amount, Integer pointsEarned, String type) {
        this.userId = userId;
        this.orderId = orderId;
        this.amount = amount;
        this.pointsEarned = pointsEarned;
        this.type = type;
        this.createdAt = LocalDateTime.now();
    }

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public Integer getUserId() { return userId; }
    public void setUserId(Integer userId) { this.userId = userId; }

    public Integer getOrderId() { return orderId; }
    public void setOrderId(Integer orderId) { this.orderId = orderId; }

    public Double getAmount() { return amount; }
    public void setAmount(Double amount) { this.amount = amount; }

    public Integer getPointsEarned() { return pointsEarned; }
    public void setPointsEarned(Integer pointsEarned) { this.pointsEarned = pointsEarned; }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
