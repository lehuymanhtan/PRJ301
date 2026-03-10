package services;

import dao.RefundDAO;
import models.RefundRequest;
import java.util.List;

public class RefundServiceImpl implements RefundService {

    private final RefundDAO refundDAO = new RefundDAO();

    @Override
    public List<RefundRequest> getAllRefunds() {
        return refundDAO.findAll();
    }

    @Override
    public RefundRequest findById(Integer id) {
        return refundDAO.findById(id);
    }

    @Override
    public RefundRequest findByOrderId(Integer orderId) {
        return refundDAO.findByOrderId(orderId);
    }

    @Override
    public List<RefundRequest> findByUserId(Integer userId) {
        return refundDAO.findByUserId(userId);
    }

    @Override
    public Integer createRefund(RefundRequest refund) {
        return refundDAO.insert(refund);
    }

    @Override
    public void updateRefund(RefundRequest refund) {
        refundDAO.update(refund);
    }
}
