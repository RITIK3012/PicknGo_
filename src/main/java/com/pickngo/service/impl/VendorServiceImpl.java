package com.pickngo.service.impl;

import com.pickngo.model.Driver;
import com.pickngo.model.Vendor;
import com.pickngo.repository.DriverRepository;
import com.pickngo.repository.VendorRepository;
import com.pickngo.service.VendorService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class VendorServiceImpl implements VendorService {

    private final VendorRepository vendorRepository;
    private final DriverRepository driverRepository;
    private final PasswordEncoder passwordEncoder;

    @Autowired
    public VendorServiceImpl(VendorRepository vendorRepository, DriverRepository driverRepository,
                          PasswordEncoder passwordEncoder) {
        this.vendorRepository = vendorRepository;
        this.driverRepository = driverRepository;
        this.passwordEncoder = passwordEncoder;
    }

    @Override
    public Vendor registerVendor(Vendor vendor) {
        vendor.setPassword(passwordEncoder.encode(vendor.getPassword()));
        return vendorRepository.save(vendor);
    }

    @Override
    public Optional<Vendor> getVendorById(Long id) {
        return vendorRepository.findById(id);
    }

    @Override
    public Optional<Vendor> getVendorByEmail(String email) {
        return vendorRepository.findByEmail(email);
    }

    @Override
    public List<Vendor> getAllVendors() {
        return vendorRepository.findAll();
    }

    @Override
    public Vendor updateVendor(Vendor vendor) {
        if (vendor.getPassword() != null && !vendor.getPassword().startsWith("$2a$")) {
            vendor.setPassword(passwordEncoder.encode(vendor.getPassword()));
        }
        return vendorRepository.save(vendor);
    }

    @Override
    public void deleteVendor(Long id) {
        vendorRepository.deleteById(id);
    }

    @Override
    public boolean existsByEmail(String email) {
        return vendorRepository.existsByEmail(email);
    }

    @Override
    public List<Driver> getDriversByVendorId(Long vendorId) {
        return driverRepository.findByVendorId(vendorId);
    }

    @Override
    public void assignDriverToVendor(Long driverId, Long vendorId) {
        Optional<Driver> optionalDriver = driverRepository.findById(driverId);
        Optional<Vendor> optionalVendor = vendorRepository.findById(vendorId);
        
        if (optionalDriver.isPresent() && optionalVendor.isPresent()) {
            Driver driver = optionalDriver.get();
            driver.setVendor(optionalVendor.get());
            driverRepository.save(driver);
        }
    }
} 