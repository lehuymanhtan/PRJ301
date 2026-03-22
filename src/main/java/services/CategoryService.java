package services;

import dao.CategoryDAO;
import models.Category;
import java.util.List;

public class CategoryService {

    private final CategoryDAO categoryDAO = new CategoryDAO();

    public List<Category> findAll() {
        return categoryDAO.findAll();
    }

    public Category findById(Integer id) {
        return categoryDAO.findById(id);
    }

    public void create(Category c) {
        if (c.getName() == null || c.getName().trim().isEmpty()) {
            throw new IllegalArgumentException("Category name is required");
        }
        categoryDAO.insert(c);
    }

    public void update(Category c) {
        if (c.getName() == null || c.getName().trim().isEmpty()) {
            throw new IllegalArgumentException("Category name is required");
        }
        categoryDAO.update(c);
    }

    public void delete(Integer id) {
        categoryDAO.delete(id);
    }
}
