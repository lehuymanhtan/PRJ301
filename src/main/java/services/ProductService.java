package services;

import dao.ProductDAO;
import models.Product;
import models.Supplier;
import java.util.List;

public class ProductService {

    private final ProductDAO productDAO = new ProductDAO();

    public List<Product> findAll() {
        return productDAO.findAll();
    }

    public long countAll() {
        return productDAO.countAll();
    }

    public List<Product> findPage(int pageNumber, int pageSize) {
        return productDAO.findPage(pageNumber, pageSize);
    }

    public Product findById(Integer id) {
        return productDAO.findById(id);
    }

    public void create(Product p) {
        if (p.getName() == null || p.getName().trim().isEmpty()) {
            throw new IllegalArgumentException("Product name is required");
        }
        if (p.getPrice() < 0) {
            throw new IllegalArgumentException("Price must be non-negative");
        }
        productDAO.insert(p);
    }

    public void update(Product p) {
        if (p.getName() == null || p.getName().trim().isEmpty()) {
            throw new IllegalArgumentException("Product name is required");
        }
        if (p.getPrice() < 0) {
            throw new IllegalArgumentException("Price must be non-negative");
        }
        productDAO.update(p);
    }

    public void delete(Integer id) {
        productDAO.delete(id);
    }
}
