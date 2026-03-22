package dao;

import models.Product;
import util.JpaHelper;
import java.util.List;

public class ProductDAO {

    public List<Product> findAll() {
        return JpaHelper.query(em ->
            em.createQuery("SELECT p FROM Product p LEFT JOIN FETCH p.supplier LEFT JOIN FETCH p.category ORDER BY p.id", Product.class)
              .getResultList()
        );
    }

    public long countAll() {
        return JpaHelper.query(em ->
            em.createQuery("SELECT COUNT(p) FROM Product p", Long.class)
              .getSingleResult()
        );
    }

    public List<Product> findPage(int pageNumber, int pageSize) {
        int offset = (pageNumber - 1) * pageSize;
        return JpaHelper.query(em ->
            em.createQuery("SELECT p FROM Product p LEFT JOIN FETCH p.supplier LEFT JOIN FETCH p.category ORDER BY p.id", Product.class)
              .setFirstResult(offset)
              .setMaxResults(pageSize)
              .getResultList()
        );
    }

    public long countByCategoryId(Integer categoryId) {
        return JpaHelper.query(em ->
            em.createQuery("SELECT COUNT(p) FROM Product p WHERE p.category.id = :categoryId", Long.class)
              .setParameter("categoryId", categoryId)
              .getSingleResult()
        );
    }

    public List<Product> findPageByCategoryId(Integer categoryId, int pageNumber, int pageSize) {
        int offset = (pageNumber - 1) * pageSize;
        return JpaHelper.query(em ->
            em.createQuery("SELECT p FROM Product p LEFT JOIN FETCH p.supplier LEFT JOIN FETCH p.category WHERE p.category.id = :categoryId ORDER BY p.id", Product.class)
              .setParameter("categoryId", categoryId)
              .setFirstResult(offset)
              .setMaxResults(pageSize)
              .getResultList()
        );
    }

    public long countByName(String keyword) {
        return JpaHelper.query(em ->
            em.createQuery("SELECT COUNT(p) FROM Product p WHERE LOWER(p.name) LIKE LOWER(:kw)", Long.class)
              .setParameter("kw", "%" + keyword + "%")
              .getSingleResult()
        );
    }

    public List<Product> searchByName(String keyword, int pageNumber, int pageSize) {
        int offset = (pageNumber - 1) * pageSize;
        return JpaHelper.query(em ->
            em.createQuery("SELECT p FROM Product p LEFT JOIN FETCH p.supplier LEFT JOIN FETCH p.category WHERE LOWER(p.name) LIKE LOWER(:kw) ORDER BY p.id", Product.class)
              .setParameter("kw", "%" + keyword + "%")
              .setFirstResult(offset)
              .setMaxResults(pageSize)
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
            if (p.getCategory() != null && p.getCategory().getId() != null) {
                p.setCategory(em.getReference(models.Category.class, p.getCategory().getId()));
            }
            em.persist(p);
        });
    }

    public void update(Product p) {
        JpaHelper.execute(em -> {
            if (p.getSupplier() != null && p.getSupplier().getId() != null) {
                p.setSupplier(em.getReference(models.Supplier.class, p.getSupplier().getId()));
            }
            if (p.getCategory() != null && p.getCategory().getId() != null) {
                p.setCategory(em.getReference(models.Category.class, p.getCategory().getId()));
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
