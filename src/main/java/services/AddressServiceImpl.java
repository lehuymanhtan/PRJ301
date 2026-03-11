package services;

import dao.AddressDAO;
import dao.ProvinceDAO;
import models.Province;
import models.UserAddress;
import java.util.List;

public class AddressServiceImpl implements AddressService {

    private final ProvinceDAO provinceDAO = new ProvinceDAO();
    private final AddressDAO  addressDAO  = new AddressDAO();

    // ── Province operations ──────────────────────────────────────────────────

    @Override
    public List<Province> getActiveProvinces() {
        return provinceDAO.findAllActive();
    }

    @Override
    public List<Province> getAllProvinces() {
        return provinceDAO.findAll();
    }

    @Override
    public Province findProvinceById(int id) {
        return provinceDAO.findById(id);
    }

    @Override
    public String createProvince(Province province) {
        if (province.getNameVi() == null || province.getNameVi().isBlank())
            return "province.error.nameViRequired";
        if (province.getNameEn() == null || province.getNameEn().isBlank())
            return "province.error.nameEnRequired";
        provinceDAO.insert(province);
        return null;
    }

    @Override
    public String updateProvince(Province province) {
        if (province.getNameVi() == null || province.getNameVi().isBlank())
            return "province.error.nameViRequired";
        if (province.getNameEn() == null || province.getNameEn().isBlank())
            return "province.error.nameEnRequired";
        provinceDAO.update(province);
        return null;
    }

    @Override
    public void deleteProvince(int id) {
        provinceDAO.delete(id);
    }

    // ── User address operations ──────────────────────────────────────────────

    @Override
    public List<UserAddress> getAddressesByUserId(int userId) {
        return addressDAO.findByUserId(userId);
    }

    @Override
    public UserAddress findAddressById(int id) {
        return addressDAO.findById(id);
    }

    @Override
    public UserAddress findDefaultAddress(int userId) {
        return addressDAO.findDefaultByUserId(userId);
    }

    @Override
    public String addAddress(UserAddress address) {
        String err = validateAddress(address);
        if (err != null) return err;

        long count = addressDAO.countByUserId(address.getUserId());
        if (count == 0) {
            // First address always becomes default
            address.setDefault(true);
        } else if (address.isDefault()) {
            // User wants this to be default → clear existing default first
            addressDAO.clearDefault(address.getUserId());
        }
        addressDAO.insert(address);
        return null;
    }

    @Override
    public String updateAddress(UserAddress address) {
        String err = validateAddress(address);
        if (err != null) return err;

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
        return null;
    }

    @Override
    public void deleteAddress(int id, int userId) {
        UserAddress address = addressDAO.findById(id);
        if (address == null || !address.getUserId().equals(userId)) return;

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

    @Override
    public void setDefaultAddress(int addressId, int userId) {
        UserAddress address = addressDAO.findById(addressId);
        if (address == null || !address.getUserId().equals(userId)) return;
        addressDAO.clearDefault(userId);
        address.setDefault(true);
        addressDAO.update(address);
    }

    // ── Validation ───────────────────────────────────────────────────────────

    private String validateAddress(UserAddress a) {
        if (a.getFullName() == null || a.getFullName().isBlank())
            return "address.error.fullNameRequired";
        if (a.getPhone() == null || a.getPhone().isBlank())
            return "address.error.phoneRequired";
        if (!a.getPhone().matches("^0\\d{9}$"))
            return "address.error.phoneInvalid";
        if (a.getProvinceId() == null)
            return "address.error.provinceRequired";
        if (a.getDistrict() == null || a.getDistrict().isBlank())
            return "address.error.districtRequired";
        if (a.getWard() == null || a.getWard().isBlank())
            return "address.error.wardRequired";
        if (a.getAddressDetail() == null || a.getAddressDetail().isBlank())
            return "address.error.detailRequired";
        return null;
    }
}
