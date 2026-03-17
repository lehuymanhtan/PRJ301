package services;

import dao.AddressDAO;
import dao.ProvinceDAO;
import models.Province;
import models.UserAddress;
import java.util.List;

public class AddressService {

    private final ProvinceDAO provinceDAO = new ProvinceDAO();
    private final AddressDAO addressDAO = new AddressDAO();

    // ── Province operations ──────────────────────────────────────────────────

    public List<Province> getActiveProvinces() {
        return provinceDAO.findAllActive();
    }

    public Province findProvinceById(Integer id) {
        return provinceDAO.findById(id);
    }

    // ── User address operations ──────────────────────────────────────────────

    public List<UserAddress> getAddressesByUserId(Integer userId) {
        return addressDAO.findByUserId(userId);
    }

    public UserAddress findAddressById(Integer id) {
        return addressDAO.findById(id);
    }

    public UserAddress findDefaultAddress(Integer userId) {
        return addressDAO.findDefaultByUserId(userId);
    }

    public void addAddress(UserAddress address) {
        validateAddress(address);

        long count = addressDAO.countByUserId(address.getUserId());
        if (count == 0) {
            // First address always becomes default
            address.setDefault(true);
        } else if (address.isDefault()) {
            // User wants this to be default → clear existing default first
            addressDAO.clearDefault(address.getUserId());
        }
        addressDAO.insert(address);
    }

    public void updateAddress(UserAddress address) {
        validateAddress(address);

        if (address.isDefault()) {
            // Clear other defaults, then this one is default
            addressDAO.clearDefault(address.getUserId());
        } else {
            // If this was the only address, force it to remain default
            long count = addressDAO.countByUserId(address.getUserId());
            if (count == 1) {
                address.setDefault(true);
            } else {
                // Ensure there is always at least one default
                UserAddress currentDefault = addressDAO.findDefaultByUserId(address.getUserId());
                if (currentDefault != null && currentDefault.getId().equals(address.getId())) {
                    // This address WAS the default and user unchecked it → keep it as default
                    address.setDefault(true);
                }
            }
        }
        addressDAO.update(address);
    }

    public void deleteAddress(Integer id, Integer userId) {
        UserAddress address = addressDAO.findById(id);
        if (address == null || !address.getUserId().equals(userId)) {
            throw new IllegalArgumentException("Address not found or unauthorized");
        }

        boolean wasDefault = address.isDefault();
        addressDAO.delete(id);

        if (wasDefault) {
            // Promote the most-recently-created remaining address to default
            List<UserAddress> remaining = addressDAO.findByUserId(userId);
            if (!remaining.isEmpty()) {
                UserAddress promote = remaining.get(0);
                promote.setDefault(true);
                addressDAO.update(promote);
            }
        }
    }

    public void setDefaultAddress(Integer addressId, Integer userId) {
        UserAddress address = addressDAO.findById(addressId);
        if (address == null || !address.getUserId().equals(userId)) {
            throw new IllegalArgumentException("Address not found or unauthorized");
        }
        addressDAO.clearDefault(userId);
        address.setDefault(true);
        addressDAO.update(address);
    }

    // ── Validation ───────────────────────────────────────────────────────────

    private void validateAddress(UserAddress a) {
        if (a.getFullName() == null || a.getFullName().isBlank()) {
            throw new IllegalArgumentException("Full name is required");
        }
        if (a.getPhone() == null || a.getPhone().isBlank()) {
            throw new IllegalArgumentException("Phone is required");
        }
        // Phone validation: 10 digits starting with 0
        if (!a.getPhone().matches("^0\\d{9}$")) {
            throw new IllegalArgumentException("Phone must be 10 digits starting with 0");
        }
        if (a.getProvinceId() == null) {
            throw new IllegalArgumentException("Province is required");
        }
        if (a.getDistrict() == null || a.getDistrict().isBlank()) {
            throw new IllegalArgumentException("District is required");
        }
        if (a.getWard() == null || a.getWard().isBlank()) {
            throw new IllegalArgumentException("Ward is required");
        }
        if (a.getAddressDetail() == null || a.getAddressDetail().isBlank()) {
            throw new IllegalArgumentException("Address detail is required");
        }
    }
}
