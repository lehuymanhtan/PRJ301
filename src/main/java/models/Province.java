package models;

import jakarta.persistence.*;
import java.io.Serializable;

@Entity
@Table(name = "Provinces")
public class Province implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(name = "nameVi", nullable = false, length = 100)
    private String nameVi;

    @Column(name = "nameEn", nullable = false, length = 100)
    private String nameEn;

    @Column(name = "isActive", nullable = false)
    private boolean isActive = true;

    public Province() {}

    public Province(String nameVi, String nameEn) {
        this.nameVi = nameVi;
        this.nameEn = nameEn;
        this.isActive = true;
    }

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public String getNameVi() { return nameVi; }
    public void setNameVi(String nameVi) { this.nameVi = nameVi; }

    public String getNameEn() { return nameEn; }
    public void setNameEn(String nameEn) { this.nameEn = nameEn; }

    public boolean isActive() { return isActive; }
    public void setActive(boolean active) { this.isActive = active; }

    @Override
    public String toString() {
        return "Province{id=" + id + ", nameVi=" + nameVi + ", nameEn=" + nameEn + "}";
    }
}
