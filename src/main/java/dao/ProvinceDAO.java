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

    public Province findById(Integer id) {
        return JpaHelper.query(em -> em.find(Province.class, id));
    }
}
