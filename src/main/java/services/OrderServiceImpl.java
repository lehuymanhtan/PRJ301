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

    @Override
    public List<Order> getAllOrders() {
        return orderDAO.findAll();
    }

    @Override
    public List<Order> getOrdersByUserId(Integer userId) {
        return orderDAO.findByUserId(userId);
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
