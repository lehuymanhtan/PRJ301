package services;

import dao.SupplierDAO;
import models.Supplier;
import java.util.List;

public class SupplierService {

    private final SupplierDAO supplierDAO = new SupplierDAO();

    public List<Supplier> findAll() {
        return supplierDAO.findAll();
    }

    public long countAllSuppliers() {
        return supplierDAO.countAll();
    }

    public List<Supplier> getSuppliersPage(int pageNumber, int pageSize) {
        return supplierDAO.findPage(pageNumber, pageSize);
    }

    public Supplier findById(Integer id) {
        return supplierDAO.findById(id);
    }

    public void create(Supplier s) {
        if (s.getName() == null || s.getName().trim().isEmpty()) {
            throw new IllegalArgumentException("Supplier name is required");
        }
        supplierDAO.insert(s);
    }

    public void update(Supplier s) {
        if (s.getName() == null || s.getName().trim().isEmpty()) {
            throw new IllegalArgumentException("Supplier name is required");
        }
        supplierDAO.update(s);
    }

    public void delete(Integer id) {
        supplierDAO.delete(id);
    }
}
