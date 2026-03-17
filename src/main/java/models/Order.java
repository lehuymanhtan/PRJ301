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

    @Column(name = "shippingFullName", length = 100)
    private String shippingFullName;

    @Column(name = "shippingPhone", length = 15)
    private String shippingPhone;

    @Column(name = "shippingProvinceId")
    private Integer shippingProvinceId;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "shippingProvinceId", insertable = false, updatable = false)
    private Province shippingProvince;

    @Column(name = "shippingDistrict", length = 100)
    private String shippingDistrict;

    @Column(name = "shippingWard", length = 100)
    private String shippingWard;

    @Column(name = "shippingAddress", length = 255)
    private String shippingAddress;

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

    public String getShippingFullName() { return shippingFullName; }
    public void setShippingFullName(String shippingFullName) { this.shippingFullName = shippingFullName; }

    public String getShippingPhone() { return shippingPhone; }
    public void setShippingPhone(String shippingPhone) { this.shippingPhone = shippingPhone; }

    public Integer getShippingProvinceId() { return shippingProvinceId; }
    public void setShippingProvinceId(Integer shippingProvinceId) { this.shippingProvinceId = shippingProvinceId; }

    public Province getShippingProvince() { return shippingProvince; }
    public void setShippingProvince(Province shippingProvince) { this.shippingProvince = shippingProvince; }

    public String getShippingDistrict() { return shippingDistrict; }
    public void setShippingDistrict(String shippingDistrict) { this.shippingDistrict = shippingDistrict; }

    public String getShippingWard() { return shippingWard; }
    public void setShippingWard(String shippingWard) { this.shippingWard = shippingWard; }

    public String getShippingAddress() { return shippingAddress; }
    public void setShippingAddress(String shippingAddress) { this.shippingAddress = shippingAddress; }

    public boolean hasShippingAddress() {
        return shippingFullName != null && !shippingFullName.isEmpty();
    }

    public String getFormattedShippingAddress() {
        if (!hasShippingAddress()) return "";
        String provinceName = (shippingProvince != null) ? shippingProvince.getNameVi() : "";
        return shippingAddress + ", " + shippingWard + ", " + shippingDistrict + ", " + provinceName;
    }

    @Override
    public String toString() {
        return "Order{id=" + id + ", userId=" + userId
                + ", totalPrice=" + totalPrice + ", status=" + status
                + ", createdAt=" + createdAt + '}';
    }
}
