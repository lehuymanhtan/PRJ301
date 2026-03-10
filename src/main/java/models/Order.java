package models;

import jakarta.persistence.*;
import java.io.Serializable;
import java.time.LocalDate;

@Entity
@Table(name = "Orders")
public class Order implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(name = "userId")
    private Integer userId;

    @Column(name = "totalPrice", nullable = false)
    private double totalPrice;

    @Column(name = "status", length = 20, nullable = false)
    private String status;  // Pending, Processing, Shipped, Delivered, Completed, Cancelled, Refunded

    @Column(name = "createdAt", nullable = false)
    private LocalDate createdAt;

    public Order() {}

    public Order(Integer userId, double totalPrice, String status) {
        this.userId     = userId;
        this.totalPrice = totalPrice;
        this.status     = status;
        this.createdAt  = LocalDate.now();
    }

    public Integer getId()            { return id; }
    public void setId(Integer id)     { this.id = id; }

    public Integer getUserId()              { return userId; }
    public void setUserId(Integer userId)   { this.userId = userId; }

    public double getTotalPrice()                 { return totalPrice; }
    public void setTotalPrice(double totalPrice)  { this.totalPrice = totalPrice; }

    public String getStatus()                { return status; }
    public void setStatus(String status)     { this.status = status; }

    public LocalDate getCreatedAt()                   { return createdAt; }
    public void setCreatedAt(LocalDate createdAt)     { this.createdAt = createdAt; }

    @Override
    public String toString() {
        return "Order{id=" + id + ", userId=" + userId
                + ", totalPrice=" + totalPrice + ", status=" + status
                + ", createdAt=" + createdAt + '}';
    }
}
