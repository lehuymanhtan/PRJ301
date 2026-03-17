package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import models.Province;
import services.AddressService;
import services.AddressServiceImpl;
import util.I18nUtil;

import java.io.IOException;
import java.util.List;

/**
 * Admin province management at /admin/provinces.
 *
 * GET  (default)        → list all provinces
 * GET  action=create    → show create form
 * GET  action=edit&id=X → show edit form
 * GET  action=delete&id=X → delete province
 * POST action=create    → save new province
 * POST action=edit      → update province
 */
@WebServlet(urlPatterns = {"/admin/provinces"})
public class AdminProvinceServlet extends HttpServlet {

    private final AddressService addressService = new AddressServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "";

        switch (action) {
            case "create": showCreateForm(request, response); break;
            case "edit":   showEditForm(request, response);   break;
            case "delete": deleteProvince(request, response); break;
            default:       listProvinces(request, response);  break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if ("edit".equals(action)) {
            updateProvince(request, response);
        } else {
            createProvince(request, response);
        }
    }

    // ── Handlers ─────────────────────────────────────────────────────────────

    private void listProvinces(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Province> provinces = addressService.getAllProvinces();
        request.setAttribute("provinces", provinces);
        request.getRequestDispatcher("/admin/provinces/list.jsp").forward(request, response);
    }

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/admin/provinces/form.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/provinces");
            return;
        }
        try {
            int id = Integer.parseInt(idParam);
            Province province = addressService.findProvinceById(id);
            if (province == null) {
                response.sendRedirect(request.getContextPath() + "/admin/provinces?error=notfound");
                return;
            }
            request.setAttribute("province", province);
            request.getRequestDispatcher("/admin/provinces/form.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/provinces");
        }
    }

    private void createProvince(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Province province = new Province();
        bindProvince(request, province);

        String err = addressService.createProvince(province);
        if (err != null) {
            request.setAttribute("error", I18nUtil.getMessage(request, err));
            request.setAttribute("province", province);
            request.getRequestDispatcher("/admin/provinces/form.jsp").forward(request, response);
            return;
        }
        response.sendRedirect(request.getContextPath() + "/admin/provinces?success=created");
    }

    private void updateProvince(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/provinces");
            return;
        }
        try {
            int id = Integer.parseInt(idParam);
            Province province = addressService.findProvinceById(id);
            if (province == null) {
                response.sendRedirect(request.getContextPath() + "/admin/provinces?error=notfound");
                return;
            }
            bindProvince(request, province);

            String err = addressService.updateProvince(province);
            if (err != null) {
                request.setAttribute("error", I18nUtil.getMessage(request, err));
                request.setAttribute("province", province);
                request.getRequestDispatcher("/admin/provinces/form.jsp").forward(request, response);
                return;
            }
            response.sendRedirect(request.getContextPath() + "/admin/provinces?success=updated");
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/provinces");
        }
    }

    private void deleteProvince(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam != null) {
            try {
                addressService.deleteProvince(Integer.parseInt(idParam));
            } catch (NumberFormatException ignored) {}
        }
        response.sendRedirect(request.getContextPath() + "/admin/provinces?success=deleted");
    }

    // ── Helpers ───────────────────────────────────────────────────────────────

    private void bindProvince(HttpServletRequest request, Province province) {
        String nameVi = request.getParameter("nameVi");
        String nameEn = request.getParameter("nameEn");
        province.setNameVi(nameVi != null ? nameVi.trim() : "");
        province.setNameEn(nameEn != null ? nameEn.trim() : "");
        province.setActive(!"false".equals(request.getParameter("isActive")));
    }
}
