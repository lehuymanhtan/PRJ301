package controller;

import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.Product;
import models.Supplier;
import services.ProductService;
import services.SupplierService;

/**
 * Admin product management at /admin/products.
 *
 * GET action=create → show create form GET action=edit → show edit form
 * (requires id) GET action=delete → delete product (requires id), redirect to
 * list GET (default) → list all products POST action=create → insert new
 * product, redirect to list POST action=edit → update product, redirect to list
 */
@WebServlet(urlPatterns = {"/admin/products"})
public class AdminProductServlet extends HttpServlet {

    private final ProductService productService = new ProductService();
    private final SupplierService supplierService = new SupplierService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) {
            action = "";
        }

        switch (action) {
            case "create":
                showCreateForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteProduct(request, response);
                break;
            default:
                listProducts(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) {
            action = "";
        }

        switch (action) {
            case "create":
                insertProduct(request, response);
                break;
            case "edit":
                updateProduct(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/admin/products");
                break;
        }
    }

    // ── Private helpers ─────────────────────────────────────────────────────
    private void listProducts(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Product> products = productService.findAll();
        request.setAttribute("products", products);
        request.getRequestDispatcher("/admin/products/list.jsp").forward(request, response);
    }

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("suppliers", supplierService.findAll());
        request.getRequestDispatcher("/admin/products/form.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Product product = productService.findById(id);
        if (product == null) {
            response.sendRedirect(request.getContextPath() + "/admin/products?error=notfound");
            return;
        }
        request.setAttribute("product", product);
        request.setAttribute("suppliers", supplierService.findAll());
        request.getRequestDispatcher("/admin/products/form.jsp").forward(request, response);
    }

    private void insertProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            Product p = buildFromRequest(request, new Product());
            productService.create(p);
            response.sendRedirect(request.getContextPath() + "/admin/products?success=created");
        } catch (IllegalArgumentException | DateTimeParseException e) {
            request.setAttribute("error", e.getMessage());
            request.setAttribute("suppliers", supplierService.findAll());
            request.getRequestDispatcher("/admin/products/form.jsp").forward(request, response);
        }
    }

    private void updateProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Product p = productService.findById(id);
            if (p == null) {
                response.sendRedirect(request.getContextPath() + "/admin/products?error=notfound");
                return;
            }
            buildFromRequest(request, p);
            productService.update(p);
            response.sendRedirect(request.getContextPath() + "/admin/products?success=updated");
        } catch (IllegalArgumentException | DateTimeParseException e) {
            request.setAttribute("error", e.getMessage());
            request.setAttribute("suppliers", supplierService.findAll());
            request.getRequestDispatcher("/admin/products/form.jsp").forward(request, response);
        }
    }

    private void deleteProduct(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        productService.delete(id);
        response.sendRedirect(request.getContextPath() + "/admin/products?success=deleted");
    }

    private Product buildFromRequest(HttpServletRequest request, Product p) {
        p.setName(request.getParameter("name").trim());
        p.setPrice(Double.parseDouble(request.getParameter("price")));
        p.setDescription(request.getParameter("description"));
        p.setStock(Integer.parseInt(request.getParameter("stock")));

        String importDateStr = request.getParameter("importDate");
        if (importDateStr != null && !importDateStr.isEmpty()) {
            LocalDate importDate = LocalDate.parse(importDateStr);
            if (importDate.isAfter(LocalDate.now())) {
                throw new IllegalArgumentException("Import date cannot be in the future");
            }
            p.setImportDate(importDate);
        }

        p.setCategory(request.getParameter("category"));

        String supplierIdStr = request.getParameter("supplierId");
        if (supplierIdStr != null && !supplierIdStr.isEmpty()) {
            Supplier supplier = new Supplier();
            supplier.setId(Integer.valueOf(supplierIdStr));
            p.setSupplier(supplier);
        } else {
            p.setSupplier(null);
        }

        return p;
    }
}
