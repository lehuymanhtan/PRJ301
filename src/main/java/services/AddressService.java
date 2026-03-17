package services;

import models.Province;
import java.util.List;

public interface AddressService {
    // ── Province operations ──────────────────────────────────────────────────
    List<Province> getActiveProvinces();
    List<Province> getAllProvinces();
    Province findProvinceById(int id);
    String createProvince(Province province);          // returns error msg or null
    String updateProvince(Province province);
    void deleteProvince(int id);

    // ── User address operations ──────────────────────────────────────────────
    List<models.UserAddress> getAddressesByUserId(int userId);
    models.UserAddress findAddressById(int id);
    models.UserAddress findDefaultAddress(int userId);
    String addAddress(models.UserAddress address);    // returns error msg or null
    String updateAddress(models.UserAddress address);
    void deleteAddress(int id, int userId);
    void setDefaultAddress(int addressId, int userId);
}
