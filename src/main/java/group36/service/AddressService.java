package group36.service;

import group36.dao.AddressDAO;
import group36.model.Address;

import java.util.List;
import java.util.Optional;





public class AddressService {

    private final AddressDAO addressDAO;

    public AddressService() {
        this.addressDAO = new AddressDAO();
    }

    


    public List<Address> getAddressesByUserId(int userId) {
        return addressDAO.findByUserId(userId);
    }

    


    public Optional<Address> getAddressById(int id) {
        return addressDAO.findById(id);
    }

    


    public Optional<Address> getDefaultAddress(int userId) {
        return addressDAO.findDefaultByUserId(userId);
    }

    



    public Address createAddress(Address address) {
        
        int count = addressDAO.countByUserId(address.getUserId());
        if (count == 0 || address.isDefault()) {
            addressDAO.setDefault(address.getUserId(), 0); 
            address.setDefault(true);
        }

        int id = addressDAO.insert(address);
        address.setId(id);
        
        
        if (address.isDefault()) {
            addressDAO.setDefault(address.getUserId(), id);
        }
        
        return address;
    }

    



    public boolean updateAddress(Address address) {
        
        if (address.isDefault()) {
            addressDAO.setDefault(address.getUserId(), address.getId());
        }
        
        addressDAO.update(address);
        return true; 
    }

    



    public boolean deleteAddress(int userId, int addressId) {
        Optional<Address> addressOpt = addressDAO.findById(addressId);
        if (addressOpt.isEmpty()) {
            return false;
        }

        Address address = addressOpt.get();
        if (address.getUserId() != userId) {
            return false; 
        }

        boolean wasDefault = address.isDefault();
        int result = addressDAO.delete(addressId);

        
        if (result > 0 && wasDefault) {
            List<Address> remaining = addressDAO.findByUserId(userId);
            if (!remaining.isEmpty()) {
                addressDAO.setDefault(userId, remaining.get(0).getId());
            }
        }

        return result > 0;
    }

    


    public boolean setDefaultAddress(int userId, int addressId) {
        Optional<Address> addressOpt = addressDAO.findById(addressId);
        if (addressOpt.isEmpty()) {
            return false;
        }

        Address address = addressOpt.get();
        if (address.getUserId() != userId) {
            return false; 
        }

        addressDAO.setDefault(userId, addressId);
        return true;
    }

    


    public boolean hasAddresses(int userId) {
        return addressDAO.countByUserId(userId) > 0;
    }
}
