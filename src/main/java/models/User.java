package models;

import jakarta.persistence.*;
import org.hibernate.annotations.Check;
import java.io.Serializable;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "Users")
@Check(constraints = "gender IN ('male', 'female', 'other')")
public class User implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "userId")
    private Integer userId;

    @Column(name = "username", nullable = false, unique = true, length = 50)
    private String username;

    @Column(name = "password", nullable = false, length = 50)
    private String password;

    @Column(name = "role", nullable = false, length = 10)
    private String role; // "admin" or "user"

    @Column(name = "name", nullable = false, length = 100)
    private String name;

    @Column(name = "gender", nullable = false, length = 10)
    private String gender; // "male", "female", "other"

    @Column(name = "dateOfBirth", nullable = false)
    private LocalDate dateOfBirth;

    @Column(name = "phone", length = 20)
    private String phone; // optional

    @Column(name = "email", nullable = false, unique = true, length = 100)
    private String email;

    @Column(name = "isVerified", nullable = false)
    private boolean isVerified = false;

    @Column(name = "verificationCode", length = 10)
    private String verificationCode;

    @Column(name = "verificationToken", length = 100)
    private String verificationToken;

    @Column(name = "verificationExpiry")
    private LocalDateTime verificationExpiry;

    @Column(name = "points", nullable = false)
    private int points = 0;

    @Column(name = "membershipTier", nullable = false, length = 20)
    private String membershipTier = "Regular";

    @Column(name = "lastPurchaseDate")
    private LocalDateTime lastPurchaseDate;

    @Column(name = "pointResetDate")
    private LocalDateTime pointResetDate;

    @Column(name = "resetToken", length = 100)
    private String resetToken;

    @Column(name = "resetTokenExpiry")
    private LocalDateTime resetTokenExpiry;

    public User() {}

    public User(String username, String password, String role) {
        this.username = username;
        this.password = password;
        this.role = role;
    }

    public User(String username, String password, String role,
                String name, String gender, LocalDate dateOfBirth,
                String phone, String email) {
        this.username = username;
        this.password = password;
        this.role = role;
        this.name = name;
        this.gender = gender;
        this.dateOfBirth = dateOfBirth;
        this.phone = phone;
        this.email = email;
    }

    public Integer getUserId() { return userId; }
    public void setUserId(Integer userId) { this.userId = userId; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }

    public LocalDate getDateOfBirth() { return dateOfBirth; }
    public void setDateOfBirth(LocalDate dateOfBirth) { this.dateOfBirth = dateOfBirth; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public boolean isVerified() { return isVerified; }
    public void setVerified(boolean verified) { isVerified = verified; }

    public String getVerificationCode() { return verificationCode; }
    public void setVerificationCode(String verificationCode) { this.verificationCode = verificationCode; }

    public String getVerificationToken() { return verificationToken; }
    public void setVerificationToken(String verificationToken) { this.verificationToken = verificationToken; }

    public LocalDateTime getVerificationExpiry() { return verificationExpiry; }
    public void setVerificationExpiry(LocalDateTime verificationExpiry) { this.verificationExpiry = verificationExpiry; }

    public int getPoints() { return points; }
    public void setPoints(int points) { this.points = points; }

    public String getMembershipTier() { return membershipTier; }
    public void setMembershipTier(String membershipTier) { this.membershipTier = membershipTier; }

    public LocalDateTime getLastPurchaseDate() { return lastPurchaseDate; }
    public void setLastPurchaseDate(LocalDateTime lastPurchaseDate) { this.lastPurchaseDate = lastPurchaseDate; }

    public LocalDateTime getPointResetDate() { return pointResetDate; }
    public void setPointResetDate(LocalDateTime pointResetDate) { this.pointResetDate = pointResetDate; }

    public String getResetToken() { return resetToken; }
    public void setResetToken(String resetToken) { this.resetToken = resetToken; }

    public LocalDateTime getResetTokenExpiry() { return resetTokenExpiry; }
    public void setResetTokenExpiry(LocalDateTime resetTokenExpiry) { this.resetTokenExpiry = resetTokenExpiry; }

    @Override
    public String toString() {
        return "User{userId=" + userId + ", username='" + username + "', name='" + name + "', role='" + role + "'}";
    }
}
