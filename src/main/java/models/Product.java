package models;

import jakarta.persistence.*;
import java.io.Serializable;
import java.time.LocalDate;

@Entity
@Table(name = "Products")
public class Product implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(nullable = false, length = 100)
    private String name;

    private double price;

    @Column(length = 500)
    private String description;

    private int stock;

    private LocalDate importDate;

    @Column(length = 100)
    private String category;

    @ManyToOne
    @JoinColumn(name = "supplierId")
    private Supplier supplier;

    @Column(name = "image_path")
    private String imagePath;

    public Product() {}

    public Product(String name, double price, String description, int stock,
                   LocalDate importDate, String category, Supplier supplier, String imagePath) {
        this.name = name;
        this.price = price;
        this.description = description;
        this.stock = stock;
        this.importDate = importDate;
        this.category = category;
        this.supplier = supplier;
        this.imagePath = imagePath;
    }

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public int getStock() { return stock; }
    public void setStock(int stock) { this.stock = stock; }

    public LocalDate getImportDate() { return importDate; }
    public void setImportDate(LocalDate importDate) { this.importDate = importDate; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public Supplier getSupplier() { return supplier; }
    public void setSupplier(Supplier supplier) { this.supplier = supplier; }

    public String getImagePath() { return imagePath; }
    public void setImagePath(String imagePath) { this.imagePath = imagePath; }
}
