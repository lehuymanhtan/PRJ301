package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import models.Category;
import services.CategoryService;
import java.io.IOException;

@WebServlet(urlPatterns = { "/admin/categories" })
public class AdminCategoryServlet extends HttpServlet {

    private final CategoryService categoryService = new CategoryService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        if (action == null) action = "";

        switch (action) {
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteCategory(request, response);
                break;
            default:
                listCategories(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
            
        String action = request.getParameter("action");
        if (action == null) action = "";

        try {
            Category category = new Category();
            category.setName(request.getParameter("name").trim());
            category.setDescription(request.getParameter("description"));

            if ("edit".equals(action)) {
                category.setId(Integer.parseInt(request.getParameter("id")));
                categoryService.update(category);
                response.sendRedirect(request.getContextPath() + "/admin/categories?success=updated");
            } else {
                categoryService.create(category);
                response.sendRedirect(request.getContextPath() + "/admin/categories?success=created");
            }
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("/admin/categories/form.jsp").forward(request, response);
        }
    }

    private void listCategories(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("categories", categoryService.findAll());
        request.getRequestDispatcher("/admin/categories/list.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr != null && !idStr.isEmpty()) {
            Category category = categoryService.findById(Integer.parseInt(idStr));
            if (category != null) {
                request.setAttribute("category", category);
            }
        }
        request.getRequestDispatcher("/admin/categories/form.jsp").forward(request, response);
    }

    private void deleteCategory(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            categoryService.delete(id);
            response.sendRedirect(request.getContextPath() + "/admin/categories?success=deleted");
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/admin/categories?error=delete_failed");
        }
    }
}
