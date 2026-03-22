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

    public long countByCategoryId(Integer categoryId) {
        return productDAO.countByCategoryId(categoryId);
    }

    public List<Product> findPageByCategoryId(Integer categoryId, int pageNumber, int pageSize) {
        return productDAO.findPageByCategoryId(categoryId, pageNumber, pageSize);
    }

    public long countByName(String keyword) {
        return productDAO.countByName(keyword);
    }

    public List<Product> searchByName(String keyword, int pageNumber, int pageSize) {
        return productDAO.searchByName(keyword, pageNumber, pageSize);
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
