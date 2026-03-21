package services;

import models.RefundRequest;
import java.util.List;

public interface RefundService {

    List<RefundRequest> getAllRefunds();

    long countAllRefunds();

    List<RefundRequest> getRefundsPage(int pageNumber, int pageSize);

    RefundRequest findById(Integer id);

    RefundRequest findByOrderId(Integer orderId);

    List<RefundRequest> findByUserId(Integer userId);

    /** Creates a new refund request and returns its generated id. */
    Integer createRefund(RefundRequest refund);

    void updateRefund(RefundRequest refund);
}
