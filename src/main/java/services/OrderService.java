package services;

import models.DailyIncome;
import models.Order;
import models.OrderDetail;
import java.util.List;

public interface OrderService {

    List<Order> getAllOrders();

    List<Order> getOrdersByUserId(Integer userId);

    Order getOrderById(Integer id);

    List<OrderDetail> getOrderDetails(Integer orderId);

    /** Creates an order and returns its generated id. */
    Integer createOrder(Order order);

    void addOrderDetail(OrderDetail detail);

    void updateOrder(Order order);

    void deleteOrder(Integer id);

    /** Returns aggregated income per day, ordered by date descending. */
    List<DailyIncome> getDailyIncome();
}
