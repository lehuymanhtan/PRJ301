package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.Province;
import models.User;
import models.UserAddress;
import services.AddressService;

import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"/users/addresses"})
public class AddressServlet extends HttpServlet {

    private final AddressService addressService = new AddressService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = getUser(request, response);
        if (user == null) return;

        String action = request.getParameter("action");
        if (action == null) action = "";

        switch (action) {
            case "add":
                showForm(request, response, null);
                break;
            case "edit":
                showEditForm(request, response, user);
                break;
            case "delete":
                deleteAddress(request, response, user);
                break;
            case "setDefault":
                setDefault(request, response, user);
                break;
            default:
                listAddresses(request, response, user);
                break;
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

    private void listAddresses(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        List<UserAddress> addresses = addressService.getAddressesByUserId(user.getUserId());
        request.setAttribute("addresses", addresses);

        // Pass checkout redirect flag
        String fromCheckout = request.getParameter("fromCheckout");
        if (fromCheckout != null) {
            request.setAttribute("fromCheckout", true);
        }

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

        showForm(request, response, address);
    }

    private void showForm(HttpServletRequest request, HttpServletResponse response, UserAddress address)
            throws ServletException, IOException {
        List<Province> provinces = addressService.getActiveProvinces();
        request.setAttribute("provinces", provinces);
        request.setAttribute("address", address);
        request.getRequestDispatcher("/users/address-form.jsp").forward(request, response);
    }

    private void addAddress(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        UserAddress address = bindAddress(request);
        address.setUserId(user.getUserId());

        try {
            addressService.addAddress(address);
            response.sendRedirect(request.getContextPath() + "/users/addresses?success=added");
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
            request.setAttribute("address", address);
            request.setAttribute("provinces", addressService.getActiveProvinces());
            request.getRequestDispatcher("/users/address-form.jsp").forward(request, response);
        }
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

        try {
            addressService.updateAddress(address);
            response.sendRedirect(request.getContextPath() + "/users/addresses?success=updated");
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
            request.setAttribute("address", address);
            request.setAttribute("provinces", addressService.getActiveProvinces());
            request.getRequestDispatcher("/users/address-form.jsp").forward(request, response);
        }
    }

    private void deleteAddress(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {
        String idParam = request.getParameter("id");
        if (idParam != null) {
            try {
                int id = Integer.parseInt(idParam);
                addressService.deleteAddress(id, user.getUserId());
            } catch (IllegalArgumentException e) {
                // Ignore errors, just redirect
            }
        }
        response.sendRedirect(request.getContextPath() + "/users/addresses?success=deleted");
    }

    private void setDefault(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {
        String idParam = request.getParameter("id");
        if (idParam != null) {
            try {
                int id = Integer.parseInt(idParam);
                addressService.setDefaultAddress(id, user.getUserId());
            } catch (IllegalArgumentException e) {
                // Ignore errors, just redirect
            }
        }
        response.sendRedirect(request.getContextPath() + "/users/addresses?success=defaultSet");
    }

    private UserAddress bindAddress(HttpServletRequest request) {
        UserAddress a = new UserAddress();
        a.setFullName(trim(request.getParameter("fullName")));
        a.setPhone(trim(request.getParameter("phone")));

        String provId = request.getParameter("provinceId");
        if (provId != null && !provId.isEmpty()) {
            try {
                a.setProvinceId(Integer.valueOf(provId));
            } catch (NumberFormatException e) {
                // Leave as null
            }
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
