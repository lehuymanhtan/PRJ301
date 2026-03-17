package models;

import jakarta.persistence.*;
import java.io.Serializable;
import java.time.LocalDate;

@Entity
@Table(name = "Products")
public class Product implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(nullable = false, length = 100)
    private String name;

    @Column(name = "name_en", length = 100)
    private String nameEn;

    private double price;

    @Column(length = 500)
    private String description;

    @Column(name = "description_en", length = 500)
    private String descriptionEn;

    private int stock;

    private LocalDate importDate;

    @Column(length = 100)
    private String category;

    @Column(name = "category_en", length = 100)
    private String categoryEn;

    @ManyToOne
    @JoinColumn(name = "supplierId")
    private Supplier supplier;

    public Product() {
    }

    public Product(String name, double price, String description, int stock,
            LocalDate importDate, String category, Supplier supplier) {
        this.name = name;
        this.price = price;
        this.description = description;
        this.stock = stock;
        this.importDate = importDate;
        this.category = category;
        this.supplier = supplier;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getStock() {
        return stock;
    }

    public void setStock(int stock) {
        this.stock = stock;
    }

    public LocalDate getImportDate() {
        return importDate;
    }

    public void setImportDate(LocalDate importDate) {
        this.importDate = importDate;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getNameEn() {
        return nameEn;
    }

    public void setNameEn(String nameEn) {
        this.nameEn = nameEn;
    }

    public String getDescriptionEn() {
        return descriptionEn;
    }

    public void setDescriptionEn(String descriptionEn) {
        this.descriptionEn = descriptionEn;
    }

    public String getCategoryEn() {
        return categoryEn;
    }

    public void setCategoryEn(String categoryEn) {
        this.categoryEn = categoryEn;
    }

    public Supplier getSupplier() {
        return supplier;
    }

    public void setSupplier(Supplier supplier) {
        this.supplier = supplier;
    }

    /**
     * Get localized name based on language code. Falls back to Vietnamese if
     * English is not available.
     */
    public String getLocalizedName(String lang) {
        if ("en".equals(lang) && nameEn != null && !nameEn.isEmpty()) {
            return nameEn;
        }
        return name;
    }

    /**
     * Get localized description based on language code.
     */
    public String getLocalizedDescription(String lang) {
        if ("en".equals(lang) && descriptionEn != null && !descriptionEn.isEmpty()) {
            return descriptionEn;
        }
        return description;
    }

    /**
     * Get localized category based on language code.
     */
    public String getLocalizedCategory(String lang) {
        if ("en".equals(lang) && categoryEn != null && !categoryEn.isEmpty()) {
            return categoryEn;
        }
        return category;
    }
}
