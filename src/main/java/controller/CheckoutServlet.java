package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import models.Cart;
import models.CartItem;
import models.Order;
import models.OrderDetail;
import models.User;
import models.UserAddress;
import services.AddressService;
import services.LoyaltyService;
import services.OrderService;
import services.OrderServiceImpl;
import services.UserService;
import util.VNPayUtil;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import services.EmailService;

/**
 * Checkout flow at /checkout.
 *
 * GET → show order summary + payment form (requires non-empty cart and
 * logged-in user) POST → place the order, clear cart, redirect to success page
 * or VNPay
 */
@WebServlet(urlPatterns = {"/checkout"})
public class CheckoutServlet extends HttpServlet {

    private final OrderService   orderService   = new OrderServiceImpl();
    private final LoyaltyService loyaltyService = new LoyaltyService();
    private final UserService    userService    = new UserService();
    private final AddressService addressService = new AddressService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Cart cart = (session != null) ? (Cart) session.getAttribute("cart") : null;

        if (cart == null || cart.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        User user = (session != null) ? (User) session.getAttribute("user") : null;
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Check if user has at least one address
        List<UserAddress> addresses = addressService.getAddressesByUserId(user.getUserId());
        if (addresses.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/users/addresses?fromCheckout=true");
            return;
        }

        request.setAttribute("cart", cart);
        request.setAttribute("addresses", addresses);
        request.getRequestDispatcher("/cart/checkout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Cart cart = (session != null) ? (Cart) session.getAttribute("cart") : null;

        if (cart == null || cart.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        User user = (session != null) ? (User) session.getAttribute("user") : null;
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String paymentMethod = request.getParameter("paymentMethod");
        if (paymentMethod == null) {
            paymentMethod = "COD";
        }

        // Get selected address (or use default)
        String addressIdParam = request.getParameter("addressId");
        UserAddress selectedAddress = null;
        if (addressIdParam != null && !addressIdParam.isEmpty()) {
            try {
                int addressId = Integer.parseInt(addressIdParam);
                selectedAddress = addressService.findAddressById(addressId);
                // Validate address belongs to user
                if (selectedAddress != null && !selectedAddress.getUserId().equals(user.getUserId())) {
                    selectedAddress = null;
                }
            } catch (NumberFormatException e) {
                // Invalid address ID
            }
        }
        // Fallback to default address if none selected
        if (selectedAddress == null) {
            selectedAddress = addressService.findDefaultAddress(user.getUserId());
        }

        // Ensure we have a valid address
        if (selectedAddress == null) {
            response.sendRedirect(request.getContextPath() + "/users/addresses?fromCheckout=true");
            return;
        }

        // Calculate total
        double total = cart.getTotalCost();

        // Apply loyalty points discount if requested
        int usedPoints = 0;
        String usePointsParam = request.getParameter("usePoints");
        if ("on".equals(usePointsParam) && user.getPoints() > 0) {
            double discount = Math.min(user.getPoints(), total);
            total = total - discount;
            usedPoints = (int) discount;
        }

        // Create order (status = "Pending" until payment is confirmed)
        Order order = new Order(user.getUserId(), total, "Pending");

        // Snapshot shipping address
        order.setShippingFullName(selectedAddress.getFullName());
        order.setShippingPhone(selectedAddress.getPhone());
        order.setShippingProvinceId(selectedAddress.getProvinceId());
        order.setShippingDistrict(selectedAddress.getDistrict());
        order.setShippingWard(selectedAddress.getWard());
        order.setShippingAddress(selectedAddress.getAddressDetail());

        Integer orderId = orderService.createOrder(order);

        // Add order details
        List<OrderDetail> orderDetailsList = new ArrayList<>();
        for (CartItem item : cart) {
            OrderDetail detail = new OrderDetail(
                    orderId,
                    item.getProduct().getId(),
                    item.getProduct().getName(),
                    item.getQuantity(),
                    item.getProduct().getPrice()
            );
            orderService.addOrderDetail(detail);
            orderDetailsList.add(detail);
        }
        EmailService.sendOrderEmail(
                user.getEmail(),
                user.getName(),
                orderId,
                orderDetailsList
        );
        // Store order id in session for result pages
        session.setAttribute("lastOrderId", orderId);
        session.setAttribute("lastPaymentMethod", paymentMethod);
        session.setAttribute("usedPoints", usedPoints);

        // ── VNPay online payment ──────────────────────────────────────────
        if ("VNPAY".equalsIgnoreCase(paymentMethod)) {

            // Clear cart before leaving the site
            session.removeAttribute("cart");

            // Amount in VND (stored as double, cast to long)
            long amountVnd = (long) total;

            // Build an ASCII-safe order description
            String orderInfo = "Thanh toan don hang #" + orderId;

            // Absolute return URL (ReturnUrl is for browser redirect)
            String returnUrl = buildAbsoluteUrl(request, "/vnpay-return");

            // Client IP address
            String ipAddr = getClientIp(request);

            // Build VNPay redirect URL and redirect
            String paymentUrl = VNPayUtil.buildPaymentUrl(orderId, amountVnd,
                    orderInfo, ipAddr, returnUrl);

            response.sendRedirect(paymentUrl);
            return;
        }

        // ── Cash on Delivery (COD) ────────────────────────────────────────
        // Mark order as confirmed immediately for COD
        order.setId(orderId);
        order.setStatus("Processing");
        orderService.updateOrder(order);

        // Record loyalty points usage and earning
        if (usedPoints > 0) {
            loyaltyService.usePoints(user.getUserId(), orderId, usedPoints);
        }
        loyaltyService.addPoints(user.getUserId(), orderId, total);

        // Refresh session user with updated points/tier
        User refreshed = userService.findById(user.getUserId());
        if (refreshed != null) session.setAttribute("user", refreshed);

        // Clear cart
        session.removeAttribute("cart");

        response.sendRedirect(request.getContextPath() + "/cart/success.jsp");
    }

    // ─────────────────────────────────────────────────────────────────────────
    //  Helpers
    // ─────────────────────────────────────────────────────────────────────────
    /**
     * Builds an absolute URL for a context-relative path, e.g. "/vnpay-return"
     * → "http://localhost:8080/PRJ301/vnpay-return"
     */
    private String buildAbsoluteUrl(HttpServletRequest req, String contextRelativePath) {
        String scheme = req.getScheme();
        String host = req.getServerName();
        int port = req.getServerPort();
        String ctx = req.getContextPath();

        StringBuilder sb = new StringBuilder();
        sb.append(scheme).append("://").append(host);
        if (!(("http".equals(scheme) && port == 80) || ("https".equals(scheme) && port == 443))) {
            sb.append(':').append(port);
        }
        sb.append(ctx).append(contextRelativePath);
        return sb.toString();
    }

    /**
     * Returns the real client IP, respecting common reverse-proxy headers.
     */
    private String getClientIp(HttpServletRequest req) {
        String ip = req.getHeader("X-Forwarded-For");
        if (ip != null && !ip.isEmpty() && !"unknown".equalsIgnoreCase(ip)) {
            return ip.split(",")[0].trim();
        }
        ip = req.getHeader("X-Real-IP");
        if (ip != null && !ip.isEmpty()) {
            return ip;
        }
        return req.getRemoteAddr();
    }
}
