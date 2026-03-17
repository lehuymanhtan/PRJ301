package services;

import models.DailyIncome;
import models.MonthlyIncome;
import models.Order;
import models.OrderDetail;
import models.YearlyIncome;
import java.util.List;

public interface OrderService {

    List<Order> getAllOrders();

    long countAllOrders();

    List<Order> getOrdersPage(int pageNumber, int pageSize);

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

    /** Returns daily income for the last {@code days} days, ordered ascending. */
    List<DailyIncome> getDailyIncomeRange(int days);

    /** Returns income grouped by month for the last {@code months} calendar months, ordered ascending. */
    List<MonthlyIncome> getMonthlyIncome(int months);

    /** Returns income grouped by year for the last {@code years} calendar years, ordered ascending. */
    List<YearlyIncome> getYearlyIncome(int years);
}
