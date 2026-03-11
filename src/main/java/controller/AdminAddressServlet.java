package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import models.Province;
import models.User;
import models.UserAddress;
import services.AddressService;
import services.AddressServiceImpl;
import services.UserService;
import util.I18nUtil;

import java.io.IOException;
import java.util.List;

/**
 * Admin management of user addresses at /admin/addresses.
 *
 * GET  ?userId=X              → list addresses for a specific user
 * GET  action=edit&id=X       → show edit form for an address
 * GET  action=setDefault&id=X&userId=X → set an address as default
 * POST action=edit            → update address
 */
@WebServlet(urlPatterns = {"/admin/addresses"})
public class AdminAddressServlet extends HttpServlet {

    private final AddressService addressService = new AddressServiceImpl();
    private final UserService    userService    = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "";

        switch (action) {
            case "edit":       showEditForm(request, response); break;
            case "setDefault": setDefault(request, response);  break;
            default:           listAddresses(request, response); break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        updateAddress(request, response);
    }

    // ── Handlers ─────────────────────────────────────────────────────────────

    private void listAddresses(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String userIdParam = request.getParameter("userId");
        if (userIdParam == null || userIdParam.isEmpty()) {
            // No userId → redirect to user list so admin picks a user
            response.sendRedirect(request.getContextPath() + "/admin/users");
            return;
        }
        try {
            int userId = Integer.parseInt(userIdParam);
            User targetUser = userService.findById(userId);
            if (targetUser == null) {
                response.sendRedirect(request.getContextPath() + "/admin/users?error=notfound");
                return;
            }
            List<UserAddress> addresses = addressService.getAddressesByUserId(userId);
            request.setAttribute("targetUser", targetUser);
            request.setAttribute("addresses", addresses);
            request.setAttribute("lang", I18nUtil.getCurrentLanguage(request));
            request.getRequestDispatcher("/admin/addresses/list.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/users");
        }
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null) {
            response.sendRedirect(request.getContextPath() + "/admin/users");
            return;
        }
        try {
            int id = Integer.parseInt(idParam);
            UserAddress address = addressService.findAddressById(id);
            if (address == null) {
                String uid = request.getParameter("userId");
                String redirectUrl = (uid != null && !uid.isEmpty())
                        ? "/admin/addresses?userId=" + uid + "&error=notfound"
                        : "/admin/users";
                response.sendRedirect(request.getContextPath() + redirectUrl);
                return;
            }
            List<Province> provinces = addressService.getAllProvinces();
            request.setAttribute("address", address);
            request.setAttribute("provinces", provinces);
            request.setAttribute("lang", I18nUtil.getCurrentLanguage(request));
            request.getRequestDispatcher("/admin/addresses/edit.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/users");
        }
    }

    private void updateAddress(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam     = request.getParameter("id");
        String userIdParam = request.getParameter("userId");
        if (idParam == null || userIdParam == null) {
            response.sendRedirect(request.getContextPath() + "/admin/users");
            return;
        }
        try {
            int id     = Integer.parseInt(idParam);
            int userId = Integer.parseInt(userIdParam);

            UserAddress existing = addressService.findAddressById(id);
            if (existing == null || !existing.getUserId().equals(userId)) {
                response.sendRedirect(request.getContextPath() + "/admin/addresses?userId=" + userId + "&error=notfound");
                return;
            }

            existing.setFullName(trim(request.getParameter("fullName")));
            existing.setPhone(trim(request.getParameter("phone")));
            String provId = request.getParameter("provinceId");
            if (provId != null && !provId.isEmpty()) {
                existing.setProvinceId(Integer.parseInt(provId));
            }
            existing.setDistrict(trim(request.getParameter("district")));
            existing.setWard(trim(request.getParameter("ward")));
            existing.setAddressDetail(trim(request.getParameter("addressDetail")));
            existing.setDefault("on".equals(request.getParameter("isDefault")));

            String err = addressService.updateAddress(existing);
            if (err != null) {
                request.setAttribute("error", I18nUtil.getMessage(request, err));
                request.setAttribute("address", existing);
                request.setAttribute("provinces", addressService.getAllProvinces());
                request.setAttribute("lang", I18nUtil.getCurrentLanguage(request));
                request.getRequestDispatcher("/admin/addresses/edit.jsp").forward(request, response);
                return;
            }
            response.sendRedirect(request.getContextPath() + "/admin/addresses?userId=" + userId + "&success=updated");
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/users");
        }
    }

    private void setDefault(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam     = request.getParameter("id");
        String userIdParam = request.getParameter("userId");
        if (idParam != null && userIdParam != null) {
            try {
                int id     = Integer.parseInt(idParam);
                int userId = Integer.parseInt(userIdParam);
                addressService.setDefaultAddress(id, userId);
            } catch (NumberFormatException ignored) {}
        }
        if (userIdParam != null && !userIdParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/addresses?userId="
                    + userIdParam + "&success=defaultSet");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/users");
        }
    }

    private String trim(String s) {
        return s != null ? s.trim() : "";
    }
}
