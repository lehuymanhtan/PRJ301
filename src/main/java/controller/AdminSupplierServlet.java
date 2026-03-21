package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import models.Supplier;
import services.SupplierService;
import java.io.IOException;
import java.util.List;

/**
 * Admin supplier management at /admin/suppliers.
 *
 * GET  action=create  → show create form
 * GET  action=edit    → show edit form (requires id)
 * GET  action=delete  → delete supplier (requires id), redirect to list
 * GET  (default)      → list all suppliers
 * POST action=create  → insert new supplier, redirect to list
 * POST action=edit    → update supplier, redirect to list
 */
@WebServlet(urlPatterns = {"/admin/suppliers"})
public class AdminSupplierServlet extends HttpServlet {

    private final SupplierService supplierService = new SupplierService();
    private static final int PAGE_SIZE = 25;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "";

        switch (action) {
            case "create":
                showCreateForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteSupplier(request, response);
                break;
            default:
                listSuppliers(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "";

        switch (action) {
            case "create":
                insertSupplier(request, response);
                break;
            case "edit":
                updateSupplier(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/admin/suppliers");
                break;
        }
    }

    // ── Private helpers ─────────────────────────────────────────────────────

    private void listSuppliers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int pageNumber = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.isEmpty()) {
            try {
                pageNumber = Integer.parseInt(pageParam);
                if (pageNumber < 1) pageNumber = 1;
            } catch (NumberFormatException e) {
                pageNumber = 1;
            }
        }

        long totalCount = supplierService.countAllSuppliers();
        long totalPages = (totalCount + PAGE_SIZE - 1) / PAGE_SIZE;
        if (pageNumber > totalPages && totalPages > 0) pageNumber = (int) totalPages;

        List<Supplier> suppliers = supplierService.getSuppliersPage(pageNumber, PAGE_SIZE);

        request.setAttribute("suppliers", suppliers);
        request.setAttribute("pageNumber", pageNumber);
        request.setAttribute("pageSize", PAGE_SIZE);
        request.setAttribute("totalCount", totalCount);
        request.setAttribute("totalPages", totalPages);
        request.getRequestDispatcher("/admin/suppliers/list.jsp").forward(request, response);
    }

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/admin/suppliers/form.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Supplier supplier = supplierService.findById(id);
        if (supplier == null) {
            response.sendRedirect(request.getContextPath() + "/admin/suppliers?error=notfound");
            return;
        }
        request.setAttribute("supplier", supplier);
        request.getRequestDispatcher("/admin/suppliers/form.jsp").forward(request, response);
    }

    private void insertSupplier(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            Supplier s = buildFromRequest(request, new Supplier());
            s.setStatus(true);
            supplierService.create(s);
            response.sendRedirect(request.getContextPath() + "/admin/suppliers?success=created");
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("/admin/suppliers/form.jsp").forward(request, response);
        }
    }

    private void updateSupplier(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Supplier s = supplierService.findById(id);
            if (s == null) {
                response.sendRedirect(request.getContextPath() + "/admin/suppliers?error=notfound");
                return;
            }
            buildFromRequest(request, s);
            String statusParam = request.getParameter("status");
            s.setStatus("true".equals(statusParam));
            supplierService.update(s);
            response.sendRedirect(request.getContextPath() + "/admin/suppliers?success=updated");
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("/admin/suppliers/form.jsp").forward(request, response);
        }
    }

    private void deleteSupplier(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        supplierService.delete(id);
        response.sendRedirect(request.getContextPath() + "/admin/suppliers?success=deleted");
    }

    private Supplier buildFromRequest(HttpServletRequest request, Supplier s) {
        s.setName(request.getParameter("name").trim());
        s.setPhone(request.getParameter("phone"));
        s.setEmail(request.getParameter("email"));
        s.setAddress(request.getParameter("address"));
        return s;
    }
}
