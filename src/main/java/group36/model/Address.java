package group36.model;

import java.io.Serializable;
import java.sql.Timestamp;





public class Address implements Serializable {
    private int id;
    private int userId;
    private String receiver;
    private String phone;
    private String addressDetail;
    private String district;
    private String city;
    private Integer ghnDistrictId;
    private String ghnWardCode;
    private boolean isDefault;
    private boolean isDeleted;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    
    public Address() {
    }

    public Address(int userId, String receiver, String phone, String addressDetail, String district, String city) {
        this.userId = userId;
        this.receiver = receiver;
        this.phone = phone;
        this.addressDetail = addressDetail;
        this.district = district;
        this.city = city;
        this.isDefault = false;
    }

    public Address(int id, int userId, String receiver, String phone, String addressDetail, String district,
            String city, boolean isDefault, Timestamp createdAt, Timestamp updatedAt) {
        this.id = id;
        this.userId = userId;
        this.receiver = receiver;
        this.phone = phone;
        this.addressDetail = addressDetail;
        this.district = district;
        this.city = city;
        this.isDefault = isDefault;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getReceiver() {
        return receiver;
    }

    public void setReceiver(String receiver) {
        this.receiver = receiver;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getAddressDetail() {
        return addressDetail;
    }

    public void setAddressDetail(String addressDetail) {
        this.addressDetail = addressDetail;
    }

    public String getDistrict() {
        return district;
    }

    public void setDistrict(String district) {
        this.district = district;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public Integer getGhnDistrictId() {
        return ghnDistrictId;
    }

    public void setGhnDistrictId(Integer ghnDistrictId) {
        this.ghnDistrictId = ghnDistrictId;
    }

    public String getGhnWardCode() {
        return ghnWardCode;
    }

    public void setGhnWardCode(String ghnWardCode) {
        this.ghnWardCode = ghnWardCode;
    }

    public boolean isDefault() {
        return isDefault;
    }

    public void setDefault(boolean isDefault) {
        this.isDefault = isDefault;
    }

    public boolean isDeleted() {
        return isDeleted;
    }

    public void setDeleted(boolean isDeleted) {
        this.isDeleted = isDeleted;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

    

    





    public String getFullAddress() {
        StringBuilder sb = new StringBuilder();
        if (addressDetail != null && !addressDetail.isEmpty()) {
            sb.append(addressDetail);
        }
        if (district != null && !district.isEmpty()) {
            if (sb.length() > 0)
                sb.append(", ");
            sb.append(district);
        }
        if (city != null && !city.isEmpty()) {
            if (sb.length() > 0)
                sb.append(", ");
            sb.append(city);
        }
        return sb.toString();
    }

    





    public String getDisplayText() {
        StringBuilder sb = new StringBuilder();
        if (receiver != null && !receiver.isEmpty()) {
            sb.append(receiver);
        }
        if (addressDetail != null && !addressDetail.isEmpty()) {
            if (sb.length() > 0)
                sb.append(" - ");
            sb.append(addressDetail);
        }
        if (district != null && !district.isEmpty()) {
            sb.append(", ").append(district);
        }
        return sb.toString();
    }

    @Override
    public String toString() {
        return "Address{" +
                "id=" + id +
                ", userId=" + userId +
                ", receiver='" + receiver + '\'' +
                ", addressDetail='" + addressDetail + '\'' +
                ", district='" + district + '\'' +
                ", city='" + city + '\'' +
                ", isDefault=" + isDefault +
                ", createdAt=" + createdAt +
                ", updatedAt=" + updatedAt +
                '}';
    }
}
