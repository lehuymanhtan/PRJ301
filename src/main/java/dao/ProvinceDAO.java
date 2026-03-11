package dao;

import models.Province;
import util.JpaHelper;
import java.util.List;

public class ProvinceDAO {

    public List<Province> findAllActive() {
        return JpaHelper.query(em ->
            em.createQuery("SELECT p FROM Province p WHERE p.isActive = true ORDER BY p.nameVi", Province.class)
              .getResultList()
        );
    }

    public List<Province> findAll() {
        return JpaHelper.query(em ->
            em.createQuery("SELECT p FROM Province p ORDER BY p.nameVi", Province.class)
              .getResultList()
        );
    }

    public Province findById(int id) {
        return JpaHelper.query(em -> em.find(Province.class, id));
    }

    public void insert(Province province) {
        JpaHelper.execute(em -> em.persist(province));
    }

    public void update(Province province) {
        JpaHelper.execute(em -> em.merge(province));
    }

    public void delete(int id) {
        JpaHelper.execute(em -> {
            Province p = em.find(Province.class, id);
            if (p != null) em.remove(p);
        });
    }
}
