package models;

import jakarta.persistence.*;
import java.io.Serializable;

@Entity
@Table(name = "OrderDetails")
public class OrderDetail implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(name = "orderId", nullable = false)
    private Integer orderId;

    @Column(name = "productId")
    private Integer productId;

    /** Snapshot of the product name at the time of purchase. */
    @Column(name = "productName", nullable = false, length = 100)
    private String productName;

    @Column(nullable = false)
    private int quantity;

    /** Unit price at the time of purchase. */
    @Column(nullable = false)
    private double price;

    public OrderDetail() {}

    public OrderDetail(Integer orderId, Integer productId, String productName,
                       int quantity, double price) {
        this.orderId     = orderId;
        this.productId   = productId;
        this.productName = productName;
        this.quantity    = quantity;
        this.price       = price;
    }

    public Integer getId()           { return id; }
    public void setId(Integer id)    { this.id = id; }

    public Integer getOrderId()              { return orderId; }
    public void setOrderId(Integer orderId)  { this.orderId = orderId; }

    public Integer getProductId()               { return productId; }
    public void setProductId(Integer productId) { this.productId = productId; }

    public String getProductName()                   { return productName; }
    public void setProductName(String productName)   { this.productName = productName; }

    public int getQuantity()              { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public double getPrice()           { return price; }
    public void setPrice(double price) { this.price = price; }

    public double getSubtotal() {
        return price * quantity;
    }
}
