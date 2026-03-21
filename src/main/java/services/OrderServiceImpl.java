package services;

import dao.OrderDAO;
import models.DailyIncome;
import models.MonthlyIncome;
import models.Order;
import models.OrderDetail;
import models.YearlyIncome;
import java.util.List;

public class OrderServiceImpl implements OrderService {

    private final OrderDAO orderDAO = new OrderDAO();
    private final LoyaltyService loyaltyService = new LoyaltyService();

    @Override
    public List<Order> getAllOrders() {
        return orderDAO.findAll();
    }

    @Override
    public long countAllOrders() {
        return orderDAO.countAll();
    }

    @Override
    public List<Order> getOrdersPage(int pageNumber, int pageSize) {
        return orderDAO.findPage(pageNumber, pageSize);
    }

    @Override
    public List<Order> getOrdersByUserId(Integer userId) {
        return orderDAO.findByUserId(userId);
    }

    @Override
    public long countOrdersByUserId(Integer userId) {
        return orderDAO.countByUserId(userId);
    }

    @Override
    public List<Order> getOrdersPageByUserId(Integer userId, int pageNumber, int pageSize) {
        return orderDAO.findPageByUserId(userId, pageNumber, pageSize);
    }

    @Override
    public Order getOrderById(Integer id) {
        return orderDAO.findById(id);
    }

    @Override
    public List<OrderDetail> getOrderDetails(Integer orderId) {
        return orderDAO.findDetailsByOrderId(orderId);
    }

    @Override
    public Integer createOrder(Order order) {
        return orderDAO.insert(order);
    }

    @Override
    public void addOrderDetail(OrderDetail detail) {
        orderDAO.insertDetail(detail);
    }

    @Override
    public void updateOrder(Order order) {
        // Refund loyalty points when order is cancelled or refunded
        Order existing = orderDAO.findById(order.getId());
        if (existing != null && existing.getUserId() != null) {
            boolean wasNotRefundable = !("Cancelled".equals(existing.getStatus()) || "Refunded".equals(existing.getStatus()));
            boolean isNowRefundable  = "Cancelled".equals(order.getStatus()) || "Refunded".equals(order.getStatus());
            if (wasNotRefundable && isNowRefundable) {
                loyaltyService.refundPoints(existing.getUserId(), order.getId());
            }
        }
        orderDAO.update(order);
    }

    @Override
    public void deleteOrder(Integer id) {
        orderDAO.delete(id);
    }

    @Override
    public List<DailyIncome> getDailyIncome() {
        return orderDAO.getDailyIncome();
    }

    @Override
    public List<DailyIncome> getDailyIncomeRange(int days) {
        return orderDAO.getDailyIncomeRange(days);
    }

    @Override
    public List<MonthlyIncome> getMonthlyIncome(int months) {
        return orderDAO.getMonthlyIncome(months);
    }

    @Override
    public List<YearlyIncome> getYearlyIncome(int years) {
        return orderDAO.getYearlyIncome(years);
    }
}
