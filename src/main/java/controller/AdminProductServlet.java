package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import models.Product;
import models.Supplier;
import models.Category;
import services.ProductService;
import services.SupplierService;
import services.CategoryService;
import jakarta.servlet.annotation.MultipartConfig;
import java.io.File;
import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.List;

/**
 * Admin product management at /admin/products.
 *
 * GET action=create → show create form
 * GET action=edit → show edit form (requires id)
 * GET action=delete → delete product (requires id), redirect to list
 * GET (default) → list all products
 * POST action=create → insert new product, redirect to list
 * POST action=edit → update product, redirect to list
 */
@WebServlet(urlPatterns = { "/admin/products" })
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  // 2 MB
    maxFileSize = 1024 * 1024 * 10,       // 10 MB
    maxRequestSize = 1024 * 1024 * 50     // 50 MB
)
public class AdminProductServlet extends HttpServlet {

    private final ProductService productService = new ProductService();
    private final SupplierService supplierService = new SupplierService();
    private final CategoryService categoryService = new CategoryService();
    private static final int PAGE_SIZE = 25;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null)
            action = "";

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
        if (action == null)
            action = "";

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
        int pageNumber = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.isEmpty()) {
            try {
                pageNumber = Integer.parseInt(pageParam);
                if (pageNumber < 1)
                    pageNumber = 1;
            } catch (NumberFormatException e) {
                pageNumber = 1;
            }
        }

        String keyword = request.getParameter("keyword");
        long totalCount;
        List<Product> products;

        if (keyword != null && !keyword.trim().isEmpty()) {
            keyword = keyword.trim();
            totalCount = productService.countByName(keyword);
            long totalPages = (totalCount + PAGE_SIZE - 1) / PAGE_SIZE;
            if (pageNumber > totalPages && totalPages > 0) {
                pageNumber = (int) totalPages;
            }
            products = productService.searchByName(keyword, pageNumber, PAGE_SIZE);
            request.setAttribute("keyword", keyword);
        } else {
            totalCount = productService.countAll();
            long totalPages = (totalCount + PAGE_SIZE - 1) / PAGE_SIZE;
            if (pageNumber > totalPages && totalPages > 0) {
                pageNumber = (int) totalPages;
            }
            products = productService.findPage(pageNumber, PAGE_SIZE);
        }

        long totalPages = (totalCount + PAGE_SIZE - 1) / PAGE_SIZE;

        request.setAttribute("products", products);
        request.setAttribute("pageNumber", pageNumber);
        request.setAttribute("pageSize", PAGE_SIZE);
        request.setAttribute("totalCount", totalCount);
        request.setAttribute("totalPages", totalPages);
        request.getRequestDispatcher("/admin/products/list.jsp").forward(request, response);
    }

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("suppliers", supplierService.findAll());
        request.setAttribute("categories", categoryService.findAll());
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
        request.setAttribute("categories", categoryService.findAll());
        request.getRequestDispatcher("/admin/products/form.jsp").forward(request, response);
    }

    private void insertProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            Product p = buildFromRequest(request, new Product());
            productService.create(p);
            
            processImageUpload(request, p);
            
            response.sendRedirect(request.getContextPath() + "/admin/products?success=created");
        } catch (IllegalArgumentException | DateTimeParseException e) {
            request.setAttribute("error", e.getMessage());
            request.setAttribute("suppliers", supplierService.findAll());
            request.setAttribute("categories", categoryService.findAll());
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
            
            processImageUpload(request, p);
            
            response.sendRedirect(request.getContextPath() + "/admin/products?success=updated");
        } catch (IllegalArgumentException | DateTimeParseException e) {
            request.setAttribute("error", e.getMessage());
            request.setAttribute("suppliers", supplierService.findAll());
            request.setAttribute("categories", categoryService.findAll());
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

        String categoryIdStr = request.getParameter("categoryId");
        if (categoryIdStr != null && !categoryIdStr.isEmpty()) {
            Category category = new Category();
            category.setId(Integer.parseInt(categoryIdStr));
            p.setCategory(category);
        } else {
            p.setCategory(null);
        }

        String supplierIdStr = request.getParameter("supplierId");
        if (supplierIdStr != null && !supplierIdStr.isEmpty()) {
            Supplier supplier = new Supplier();
            supplier.setId(Integer.parseInt(supplierIdStr));
            p.setSupplier(supplier);
        } else {
            p.setSupplier(null);
        }

        return p;
    }

    private void processImageUpload(HttpServletRequest request, Product p) throws IOException, ServletException {
        Part filePart = request.getPart("image");
        if (filePart != null && filePart.getSize() > 0) {
            String submittedFileName = filePart.getSubmittedFileName();
            String ext = "";
            if (submittedFileName != null && submittedFileName.lastIndexOf('.') > 0) {
                ext = submittedFileName.substring(submittedFileName.lastIndexOf('.'));
            }
            String fileName = p.getId() + ext;
            String uploadPath = request.getServletContext().getRealPath("/assets/img/products");
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdirs();
            
            filePart.write(uploadPath + File.separator + fileName);
            p.setImagePath("assets/img/products/" + fileName);
            productService.update(p);
        }
    }
}
