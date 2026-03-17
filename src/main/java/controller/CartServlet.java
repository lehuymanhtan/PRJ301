package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import models.Cart;
import models.CartItem;
import models.Product;
import services.CartService;
import services.CartServiceImpl;
import services.ProductService;
import java.io.IOException;
import java.util.Iterator;

/**
 * Cart management at /cart.
 *
 * GET  (default)     → view cart
 * POST action=add    → add product to cart (requires productId, quantity)
 * POST action=update → update item quantity (requires productId, quantity)
 * POST action=remove → remove item from cart (requires productId)
 */
@WebServlet(urlPatterns = {"/cart"})
public class CartServlet extends HttpServlet {

    private final ProductService productService = new ProductService();
    private final CartService cartService = new CartServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null) {
            cart = new Cart();
        }

        // Validate stock and adjust quantities
        boolean stockAdjusted = false;
        if (!cart.isEmpty()) {
            Iterator<CartItem> iterator = cart.iterator();
            while (iterator.hasNext()) {
                CartItem item = iterator.next();
                Product p = productService.findById(item.getProduct().getId());
                if (p != null) {
                    if (p.getStock() <= 0) {
                        iterator.remove();
                        stockAdjusted = true;
                    } else if (item.getQuantity() > p.getStock()) {
                        item.setQuantity(p.getStock());
                        stockAdjusted = true;
                    }
                }
            }
        }

        if (stockAdjusted) {
            request.setAttribute("stockMessage",
                    "Some items were removed or adjusted to match available stock.");
        }

        // Transfer any pending flash message from session
        String cartMessage = (String) session.getAttribute("cartMessage");
        if (cartMessage != null) {
            request.setAttribute("cartMessage", cartMessage);
            session.removeAttribute("cartMessage");
        }

        request.setAttribute("cart", cart);
        request.getRequestDispatcher("/cart/cart.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null) {
            cart = new Cart();
        }

        String action = request.getParameter("action");
        if (action == null) action = "";

        String productIdParam = request.getParameter("productId");
        if (productIdParam == null || productIdParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }
        int productId;
        try {
            productId = Integer.parseInt(productIdParam);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        switch (action) {
            case "add":
                String quantityParam = request.getParameter("quantity");
                int quantity = 1;
                try {
                    if (quantityParam != null) quantity = Integer.parseInt(quantityParam);
                } catch (NumberFormatException ignored) {}
                Product product = productService.findById(productId);
                if (product != null) {
                    int currentInCart = 0;
                    for (CartItem item : cart) {
                        if (item.getProduct().getId().equals(productId)) {
                            currentInCart = item.getQuantity();
                            break;
                        }
                    }
                    int available = product.getStock() - currentInCart;
                    if (available <= 0) {
                        session.setAttribute("cartMessage", "Cannot add product. Out of stock.");
                    } else {
                        int toAdd = Math.min(quantity, available);
                        cartService.addToCart(cart, product, toAdd);
                        if (toAdd < quantity) {
                            session.setAttribute("cartMessage",
                                    "Only " + toAdd + " unit(s) added due to stock limit.");
                        } else {
                            session.setAttribute("cartMessage", "Product added to cart.");
                        }
                    }
                }
                break;
            case "update":
                int qty = 1;
                try {
                    String qtyParam = request.getParameter("quantity");
                    if (qtyParam != null) qty = Integer.parseInt(qtyParam);
                } catch (NumberFormatException ignored) {}
                Product pCheck = productService.findById(productId);
                if (pCheck != null && qty > pCheck.getStock()) {
                    qty = pCheck.getStock();
                    session.setAttribute("cartMessage",
                            "Quantity adjusted to available stock: " + qty);
                }
                if (qty < 1) qty = 1;
                cartService.updateCartItem(cart, productId, qty);
                break;
            case "remove":
                cartService.removeCartItem(cart, productId);
                break;
        }

        session.setAttribute("cart", cart);
        response.sendRedirect(request.getContextPath() + "/cart");
    }
}
