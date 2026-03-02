package dao;

import models.Product;
import util.JpaHelper;
import java.util.List;

public class ProductDAO {

    public List<Product> findAll() {
        return JpaHelper.query(em ->
            em.createQuery("SELECT p FROM Product p LEFT JOIN FETCH p.supplier ORDER BY p.id", Product.class)
              .getResultList()
        );
    }

    public Product findById(Integer id) {
        return JpaHelper.query(em -> {
            Product p = em.find(Product.class, id);
            // init supplier lazily within the same session
            if (p != null && p.getSupplier() != null) {
                p.getSupplier().getId(); // touch to load
            }
            return p;
        });
    }

    public void insert(Product p) {
        JpaHelper.execute(em -> {
            if (p.getSupplier() != null && p.getSupplier().getId() != null) {
                p.setSupplier(em.getReference(models.Supplier.class, p.getSupplier().getId()));
            }
            em.persist(p);
        });
    }

    public void update(Product p) {
        JpaHelper.execute(em -> {
            if (p.getSupplier() != null && p.getSupplier().getId() != null) {
                p.setSupplier(em.getReference(models.Supplier.class, p.getSupplier().getId()));
            }
            em.merge(p);
        });
    }

    public void delete(Integer id) {
        JpaHelper.execute(em -> {
            Product p = em.find(Product.class, id);
            if (p != null) em.remove(p);
        });
    }
}
