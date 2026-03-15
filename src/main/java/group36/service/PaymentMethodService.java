package group36.service;

import group36.dao.PaymentMethodDAO;
import group36.model.PaymentMethod;

import java.util.List;
import java.util.Optional;





public class PaymentMethodService {

    private final PaymentMethodDAO paymentMethodDAO;

    public PaymentMethodService() {
        this.paymentMethodDAO = new PaymentMethodDAO();
    }

    


    public List<PaymentMethod> getActivePaymentMethods() {
        return paymentMethodDAO.findAllActive();
    }

    


    public List<PaymentMethod> getAllPaymentMethods() {
        return paymentMethodDAO.findAll();
    }

    


    public Optional<PaymentMethod> getPaymentMethodById(int id) {
        return paymentMethodDAO.findById(id);
    }

    


    public boolean isValidPaymentMethod(int paymentMethodId) {
        Optional<PaymentMethod> methodOpt = paymentMethodDAO.findById(paymentMethodId);
        return methodOpt.isPresent() && methodOpt.get().isActive();
    }
}
