package group36.model;

import java.io.Serializable;





public class PaymentMethod implements Serializable {
    private int id;
    private String methodName;
    private String status;

    
    public static final String STATUS_ACTIVE = "active";
    public static final String STATUS_INACTIVE = "inactive";

    
    public PaymentMethod() {
    }

    public PaymentMethod(String methodName) {
        this.methodName = methodName;
        this.status = STATUS_ACTIVE;
    }

    public PaymentMethod(int id, String methodName, String status) {
        this.id = id;
        this.methodName = methodName;
        this.status = status;
    }

    
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getMethodName() {
        return methodName;
    }

    
    public String getName() {
        return methodName;
    }

    public void setMethodName(String methodName) {
        this.methodName = methodName;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    

    




    public boolean isActive() {
        return STATUS_ACTIVE.equalsIgnoreCase(status);
    }

    




    public String getIconClass() {
        if (methodName == null)
            return "fa-credit-card";

        String lowerName = methodName.toLowerCase();
        if (lowerName.contains("cod") || lowerName.contains("nhận hàng")) {
            return "fa-money-bill-wave";
        } else if (lowerName.contains("ngân hàng") || lowerName.contains("chuyển khoản")) {
            return "fa-university";
        } else if (lowerName.contains("momo")) {
            return "fa-wallet";
        } else if (lowerName.contains("zalo")) {
            return "fa-wallet";
        } else if (lowerName.contains("ví") || lowerName.contains("wallet")) {
            return "fa-wallet";
        }
        return "fa-credit-card";
    }

    @Override
    public String toString() {
        return "PaymentMethod{" +
                "id=" + id +
                ", methodName='" + methodName + '\'' +
                ", status='" + status + '\'' +
                '}';
    }
}
