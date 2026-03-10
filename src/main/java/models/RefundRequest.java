package models;

import jakarta.persistence.*;
import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * Represents a refund request submitted by a user for a delivered order.
 * Statuses: Pending → WaitForReturn → Verifying → Done
 *                   → Rejected
 *           Pending → Cancelled (by user)
 */
@Entity
@Table(name = "RefundRequests")
public class RefundRequest implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(name = "orderId", nullable = false)
    private Integer orderId;

    @Column(name = "userId", nullable = false)
    private Integer userId;

    @Column(name = "reason", nullable = false, length = 100)
    private String reason;

    @Column(name = "description", length = 1000)
    private String description;

    /**
     * Possible values:
     *   Pending       – just submitted, awaiting admin review
     *   WaitForReturn – admin approved; user must return the goods
     *   Verifying     – admin received the return and is inspecting
     *   Done          – refund completed
     *   Rejected      – admin rejected the request
     *   Cancelled     – user cancelled the request
     */
    @Column(name = "status", nullable = false, length = 30)
    private String status;

    /** Address where the user should ship the goods back (set by admin). */
    @Column(name = "returnAddress", length = 500)
    private String returnAddress;

    @Column(name = "createdAt", nullable = false)
    private LocalDateTime createdAt;

    public RefundRequest() {}

    public RefundRequest(Integer orderId, Integer userId, String reason, String description) {
        this.orderId     = orderId;
        this.userId      = userId;
        this.reason      = reason;
        this.description = description;
        this.status      = "Pending";
        this.createdAt   = LocalDateTime.now();
    }

    public Integer getId()                     { return id; }
    public void setId(Integer id)              { this.id = id; }

    public Integer getOrderId()                { return orderId; }
    public void setOrderId(Integer orderId)    { this.orderId = orderId; }

    public Integer getUserId()                 { return userId; }
    public void setUserId(Integer userId)      { this.userId = userId; }

    public String getReason()                  { return reason; }
    public void setReason(String reason)       { this.reason = reason; }

    public String getDescription()               { return description; }
    public void setDescription(String desc)      { this.description = desc; }

    public String getStatus()                  { return status; }
    public void setStatus(String status)       { this.status = status; }

    public String getReturnAddress()                    { return returnAddress; }
    public void setReturnAddress(String returnAddress)  { this.returnAddress = returnAddress; }

    public LocalDateTime getCreatedAt()                { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt)  { this.createdAt = createdAt; }

    @Override
    public String toString() {
        return "RefundRequest{id=" + id + ", orderId=" + orderId
                + ", userId=" + userId + ", status=" + status + '}';
    }
}
