package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import models.User;
import services.UserService;
import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.List;

/**
 * Admin user management at /admin/users.
 * Supports full CRUD via the 'action' request parameter.
 *
 * GET  action=create  → show create form
 * GET  action=edit    → show edit form (requires id)
 * GET  action=delete  → delete user (requires id), redirect to list
 * GET  (default)      → list all users
 * POST action=create  → insert new user, redirect to list
 * POST action=edit    → update user, redirect to list
 */
@WebServlet(urlPatterns = {"/admin/users"})
public class AdminUserServlet extends HttpServlet {

    private final UserService userService = new UserService();

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
                deleteUser(request, response);
                break;
            default:
                listUsers(request, response);
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
                insertUser(request, response);
                break;
            case "edit":
                updateUser(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/admin/users");
                break;
        }
    }

    // ── Private helpers ─────────────────────────────────────────────────────

    private void listUsers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String q = request.getParameter("q");
        List<User> users = (q != null && !q.trim().isEmpty())
                ? userService.searchUserByName(q)
                : userService.getAllUsers();
        request.setAttribute("users", users);
        request.setAttribute("searchKeyword", q);
        request.getRequestDispatcher("/admin/users/list.jsp").forward(request, response);
    }

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/admin/users/form.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        User user = userService.findById(id);
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/admin/users?error=notfound");
            return;
        }
        request.setAttribute("user", user);
        request.getRequestDispatcher("/admin/users/form.jsp").forward(request, response);
    }

    private void insertUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String role     = request.getParameter("role");
        String name     = request.getParameter("name");
        String gender   = request.getParameter("gender");
        String dobStr   = request.getParameter("dateOfBirth");
        String phone    = request.getParameter("phone");
        String email    = request.getParameter("email");
        LocalDate dateOfBirth = parseDob(dobStr);
        if (dateOfBirth == null && dobStr != null && !dobStr.trim().isEmpty()) {
            request.setAttribute("error", "Invalid date of birth format.");
            request.getRequestDispatcher("/admin/users/form.jsp").forward(request, response);
            return;
        }
        try {
            userService.createUser(username, password, role, name, gender, dateOfBirth, phone, email);
            response.sendRedirect(request.getContextPath() + "/admin/users?success=created");
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("/admin/users/form.jsp").forward(request, response);
        }
    }

    private void updateUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String role     = request.getParameter("role");
        String name     = request.getParameter("name");
        String gender   = request.getParameter("gender");
        String dobStr   = request.getParameter("dateOfBirth");
        String phone    = request.getParameter("phone");
        String email    = request.getParameter("email");
        LocalDate dateOfBirth = parseDob(dobStr);
        if (dateOfBirth == null && dobStr != null && !dobStr.trim().isEmpty()) {
            request.setAttribute("error", "Invalid date of birth format.");
            String userIdParam = request.getParameter("userId");
            if (userIdParam != null) request.setAttribute("user", userService.findById(Integer.parseInt(userIdParam)));
            request.getRequestDispatcher("/admin/users/form.jsp").forward(request, response);
            return;
        }
        try {
            int userId = Integer.parseInt(request.getParameter("userId"));
            userService.updateUser(userId, username, password, role, name, gender, dateOfBirth, phone, email);
            response.sendRedirect(request.getContextPath() + "/admin/users?success=updated");
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/users?error=invalid");
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
            String userIdParam = request.getParameter("userId");
            if (userIdParam != null) request.setAttribute("user", userService.findById(Integer.parseInt(userIdParam)));
            request.getRequestDispatcher("/admin/users/form.jsp").forward(request, response);
        }
    }

    /** Returns null on blank input, null on parse error (caller checks). */
    private LocalDate parseDob(String dobStr) {
        if (dobStr == null || dobStr.trim().isEmpty()) return null;
        try {
            return LocalDate.parse(dobStr.trim());
        } catch (DateTimeParseException e) {
            return null;
        }
    }

    private void deleteUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            HttpSession session = request.getSession(false);
            User currentUser = (session != null) ? (User) session.getAttribute("user") : null;
            userService.deleteUser(id, currentUser != null ? currentUser.getUserId() : null);
            response.sendRedirect(request.getContextPath() + "/admin/users?success=deleted");
        } catch (IllegalArgumentException e) {
            // self-delete attempt or invalid id
            response.sendRedirect(request.getContextPath() + "/admin/users?error=" +
                    java.net.URLEncoder.encode(e.getMessage(), "UTF-8"));
        }
    }
}
