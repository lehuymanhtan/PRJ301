package dao;

import models.Supplier;
import util.JpaHelper;
import java.util.List;

public class SupplierDAO {

    public List<Supplier> findAll() {
        return JpaHelper.query(em ->
            em.createQuery("SELECT s FROM Supplier s ORDER BY s.id", Supplier.class)
              .getResultList()
        );
    }

    public long countAll() {
        return JpaHelper.query(em ->
            em.createQuery("SELECT COUNT(s) FROM Supplier s", Long.class)
              .getSingleResult()
        );
    }

    public List<Supplier> findPage(int pageNumber, int pageSize) {
        int offset = (pageNumber - 1) * pageSize;
        return JpaHelper.query(em ->
            em.createQuery("SELECT s FROM Supplier s ORDER BY s.id DESC", Supplier.class)
              .setFirstResult(offset)
              .setMaxResults(pageSize)
              .getResultList()
        );
    }

    public Supplier findById(Integer id) {
        return JpaHelper.query(em -> em.find(Supplier.class, id));
    }

    public void insert(Supplier s) {
        JpaHelper.execute(em -> em.persist(s));
    }

    public void update(Supplier s) {
        JpaHelper.execute(em -> em.merge(s));
    }

    public void delete(Integer id) {
        JpaHelper.execute(em -> {
            Supplier s = em.find(Supplier.class, id);
            if (s != null) em.remove(s);
        });
    }
}
