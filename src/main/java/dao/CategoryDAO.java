package dao;

import models.Category;
import util.JpaHelper;
import java.util.List;

public class CategoryDAO {

    public List<Category> findAll() {
        return JpaHelper.query(em ->
            em.createQuery("SELECT c FROM Category c ORDER BY c.name", Category.class)
              .getResultList()
        );
    }

    public Category findById(Integer id) {
        return JpaHelper.query(em -> em.find(Category.class, id));
    }

    public void insert(Category c) {
        JpaHelper.execute(em -> em.persist(c));
    }

    public void update(Category c) {
        JpaHelper.execute(em -> em.merge(c));
    }

    public void delete(Integer id) {
        JpaHelper.execute(em -> {
            Category c = em.find(Category.class, id);
            if (c != null) em.remove(c);
        });
    }
}
