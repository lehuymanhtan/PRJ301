package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import models.User;
import models.UserAddress;
import models.Province;
import services.AddressService;
import services.AddressServiceImpl;
import util.I18nUtil;

import java.io.IOException;
import java.util.List;

/**
 * User address book management at /users/addresses.
 *
 * GET  (default)          → list all addresses
 * GET  action=add         → show add form
 * GET  action=edit&id=X   → show edit form
 * GET  action=delete&id=X → delete address, redirect to list
 * GET  action=setDefault&id=X → set address as default, redirect to list
 * POST action=add         → save new address
 * POST action=edit        → update address
 */
@WebServlet(urlPatterns = {"/users/addresses"})
public class AddressServlet extends HttpServlet {

    private final AddressService addressService = new AddressServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = getUser(request, response);
        if (user == null) return;

        String action = request.getParameter("action");
        if (action == null) action = "";

        switch (action) {
            case "add":        showForm(request, response, user, null);   break;
            case "edit":       showEditForm(request, response, user);     break;
            case "delete":     deleteAddress(request, response, user);    break;
            case "setDefault": setDefault(request, response, user);       break;
            default:           listAddresses(request, response, user);    break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = getUser(request, response);
        if (user == null) return;

        String action = request.getParameter("action");
        if ("edit".equals(action)) {
            updateAddress(request, response, user);
        } else {
            addAddress(request, response, user);
        }
    }

    // ── Handlers ─────────────────────────────────────────────────────────────

    private void listAddresses(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        List<UserAddress> addresses = addressService.getAddressesByUserId(user.getUserId());
        request.setAttribute("addresses", addresses);
        request.setAttribute("lang", I18nUtil.getCurrentLanguage(request));
        request.getRequestDispatcher("/users/addresses.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/users/addresses");
            return;
        }
        int id;
        try {
            id = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/users/addresses");
            return;
        }
        UserAddress address = addressService.findAddressById(id);
        if (address == null || !address.getUserId().equals(user.getUserId())) {
            response.sendRedirect(request.getContextPath() + "/users/addresses?error=notfound");
            return;
        }
        showForm(request, response, user, address);
    }

    private void showForm(HttpServletRequest request, HttpServletResponse response,
                          User user, UserAddress address)
            throws ServletException, IOException {
        List<Province> provinces = addressService.getActiveProvinces();
        request.setAttribute("provinces", provinces);
        request.setAttribute("address", address);
        request.setAttribute("lang", I18nUtil.getCurrentLanguage(request));
        request.getRequestDispatcher("/users/address-form.jsp").forward(request, response);
    }

    private void addAddress(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        UserAddress address = bindAddress(request);
        address.setUserId(user.getUserId());

        String err = addressService.addAddress(address);
        if (err != null) {
            request.setAttribute("error", I18nUtil.getMessage(request, err));
            request.setAttribute("address", address);
            List<Province> provinces = addressService.getActiveProvinces();
            request.setAttribute("provinces", provinces);
            request.setAttribute("lang", I18nUtil.getCurrentLanguage(request));
            request.getRequestDispatcher("/users/address-form.jsp").forward(request, response);
            return;
        }
        response.sendRedirect(request.getContextPath() + "/users/addresses?success=added");
    }

    private void updateAddress(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/users/addresses");
            return;
        }
        int id;
        try {
            id = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/users/addresses");
            return;
        }
        UserAddress existing = addressService.findAddressById(id);
        if (existing == null || !existing.getUserId().equals(user.getUserId())) {
            response.sendRedirect(request.getContextPath() + "/users/addresses?error=notfound");
            return;
        }

        UserAddress address = bindAddress(request);
        address.setId(id);
        address.setUserId(user.getUserId());
        address.setCreatedAt(existing.getCreatedAt());

        String err = addressService.updateAddress(address);
        if (err != null) {
            request.setAttribute("error", I18nUtil.getMessage(request, err));
            request.setAttribute("address", address);
            List<Province> provinces = addressService.getActiveProvinces();
            request.setAttribute("provinces", provinces);
            request.setAttribute("lang", I18nUtil.getCurrentLanguage(request));
            request.getRequestDispatcher("/users/address-form.jsp").forward(request, response);
            return;
        }
        response.sendRedirect(request.getContextPath() + "/users/addresses?success=updated");
    }

    private void deleteAddress(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam != null) {
            try {
                int id = Integer.parseInt(idParam);
                addressService.deleteAddress(id, user.getUserId());
            } catch (NumberFormatException ignored) {}
        }
        response.sendRedirect(request.getContextPath() + "/users/addresses?success=deleted");
    }

    private void setDefault(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam != null) {
            try {
                int id = Integer.parseInt(idParam);
                addressService.setDefaultAddress(id, user.getUserId());
            } catch (NumberFormatException ignored) {}
        }
        response.sendRedirect(request.getContextPath() + "/users/addresses?success=defaultSet");
    }

    // ── Helpers ───────────────────────────────────────────────────────────────

    private UserAddress bindAddress(HttpServletRequest request) {
        UserAddress a = new UserAddress();
        a.setFullName(trim(request.getParameter("fullName")));
        a.setPhone(trim(request.getParameter("phone")));
        String provId = request.getParameter("provinceId");
        if (provId != null && !provId.isEmpty()) {
            try { a.setProvinceId(Integer.parseInt(provId)); } catch (NumberFormatException ignored) {}
        }
        a.setDistrict(trim(request.getParameter("district")));
        a.setWard(trim(request.getParameter("ward")));
        a.setAddressDetail(trim(request.getParameter("addressDetail")));
        a.setDefault("on".equals(request.getParameter("isDefault")));
        return a;
    }

    private String trim(String s) {
        return s != null ? s.trim() : "";
    }

    private User getUser(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return null;
        }
        return user;
    }
}
