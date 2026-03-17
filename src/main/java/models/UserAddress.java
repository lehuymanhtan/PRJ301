package models;

import jakarta.persistence.*;
import java.io.Serializable;
import java.time.LocalDate;

@Entity
@Table(name = "UserAddresses")
public class UserAddress implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(name = "userId", nullable = false)
    private Integer userId;

    @Column(name = "fullName", nullable = false, length = 100)
    private String fullName;

    @Column(name = "phone", nullable = false, length = 15)
    private String phone;

    @Column(name = "provinceId", nullable = false)
    private Integer provinceId;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "provinceId", nullable = false, insertable = false, updatable = false)
    private Province province;

    @Column(name = "district", nullable = false, length = 100)
    private String district;

    @Column(name = "ward", nullable = false, length = 100)
    private String ward;

    @Column(name = "addressDetail", nullable = false, length = 255)
    private String addressDetail;

    @Column(name = "isDefault", nullable = false)
    private boolean isDefault = false;

    @Column(name = "createdAt", nullable = false)
    private LocalDate createdAt;

    public UserAddress() {
        this.createdAt = LocalDate.now();
    }

    public Integer getId()                  { return id; }
    public void setId(Integer id)           { this.id = id; }

    public Integer getUserId()              { return userId; }
    public void setUserId(Integer userId)   { this.userId = userId; }

    public String getFullName()                 { return fullName; }
    public void setFullName(String fullName)    { this.fullName = fullName; }

    public String getPhone()                { return phone; }
    public void setPhone(String phone)      { this.phone = phone; }

    public Integer getProvinceId()                  { return provinceId; }
    public void setProvinceId(Integer provinceId)   { this.provinceId = provinceId; }

    public Province getProvince()               { return province; }
    public void setProvince(Province province)  { this.province = province; }

    public String getDistrict()                 { return district; }
    public void setDistrict(String district)    { this.district = district; }

    public String getWard()                 { return ward; }
    public void setWard(String ward)        { this.ward = ward; }

    public String getAddressDetail()                    { return addressDetail; }
    public void setAddressDetail(String addressDetail)  { this.addressDetail = addressDetail; }

    public boolean isDefault()                  { return isDefault; }
    public void setDefault(boolean isDefault)   { this.isDefault = isDefault; }

    public LocalDate getCreatedAt()                     { return createdAt; }
    public void setCreatedAt(LocalDate createdAt)       { this.createdAt = createdAt; }

    /**
     * Returns a single-line formatted address string in the given language.
     */
    public String getFormattedAddress(String lang) {
        String provinceName = (province != null) ? province.getLocalizedName(lang) : "";
        return addressDetail + ", " + ward + ", " + district + ", " + provinceName;
    }
}
