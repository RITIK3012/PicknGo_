package com.pickngo.service;

import com.pickngo.model.Driver;
import com.pickngo.model.Vendor;

import java.util.List;
import java.util.Optional;

public interface VendorService {
    Vendor registerVendor(Vendor vendor);
    Optional<Vendor> getVendorById(Long id);
    Optional<Vendor> getVendorByEmail(String email);
    List<Vendor> getAllVendors();
    Vendor updateVendor(Vendor vendor);
    void deleteVendor(Long id);
    boolean existsByEmail(String email);
    List<Driver> getDriversByVendorId(Long vendorId);
    void assignDriverToVendor(Long driverId, Long vendorId);
} 