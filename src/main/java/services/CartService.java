package services;

import models.Cart;
import models.Product;

public interface CartService {

    void addToCart(Cart cart, Product product, int quantity);

    void updateCartItem(Cart cart, int productId, int quantity);

    void removeCartItem(Cart cart, int productId);
}
