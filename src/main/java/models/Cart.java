package models;

import java.util.ArrayList;

public class Cart extends ArrayList<CartItem> {

    public double getTotalCost() {
        double total = 0;
        for (CartItem item : this) {
            total += item.getSubtotal();
        }
        return total;
    }
}
