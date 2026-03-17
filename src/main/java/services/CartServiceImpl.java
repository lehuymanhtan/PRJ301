package services;

import models.Cart;
import models.CartItem;
import models.Product;

public class CartServiceImpl implements CartService {

    @Override
    public void addToCart(Cart cart, Product product, int quantity) {
        for (CartItem item : cart) {
            if (item.getProduct().getId().equals(product.getId())) {
                item.setQuantity(item.getQuantity() + quantity);
                return;
            }
        }
        cart.add(new CartItem(product, quantity));
    }

    @Override
    public void updateCartItem(Cart cart, int productId, int quantity) {
        for (CartItem item : cart) {
            if (item.getProduct().getId().equals(productId)) {
                item.setQuantity(quantity);
                break;
            }
        }
    }

    @Override
    public void removeCartItem(Cart cart, int productId) {
        CartItem toRemove = null;
        for (CartItem item : cart) {
            if (item.getProduct().getId().equals(productId)) {
                toRemove = item;
                break;
            }
        }
        cart.remove(toRemove);
    }
}
