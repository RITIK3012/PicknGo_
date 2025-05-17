package com.pickngo.config;

import com.pickngo.model.*;
import com.pickngo.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public class CustomUserDetailsService implements UserDetailsService {

    private final AdminRepository adminRepository;
    private final ShipperRepository shipperRepository;
    private final DriverRepository driverRepository;
    private final VendorRepository vendorRepository;
    private final CustomerRepository customerRepository;

    @Autowired
    public CustomUserDetailsService(AdminRepository adminRepository, ShipperRepository shipperRepository,
                                   DriverRepository driverRepository, VendorRepository vendorRepository,
                                   CustomerRepository customerRepository) {
        this.adminRepository = adminRepository;
        this.shipperRepository = shipperRepository;
        this.driverRepository = driverRepository;
        this.vendorRepository = vendorRepository;
        this.customerRepository = customerRepository;
    }

    @Override
    public UserDetails loadUserByUsername(String email) throws UsernameNotFoundException {
        // Try to find the user in each repository
        Optional<Admin> admin = adminRepository.findByEmail(email);
        Optional<Shipper> shipper = shipperRepository.findByEmail(email);
        Optional<Driver> driver = driverRepository.findByEmail(email);
        Optional<Vendor> vendor = vendorRepository.findByEmail(email);
        Optional<Customer> customer = customerRepository.findByEmail(email);

        if (admin.isPresent()) {
            return new CustomUserDetails<>(admin.get(), "ROLE_ADMIN");
        } else if (shipper.isPresent()) {
            return new CustomUserDetails<>(shipper.get(), "ROLE_SHIPPER");
        } else if (driver.isPresent()) {
            return new CustomUserDetails<>(driver.get(), "ROLE_DRIVER");
        } else if (vendor.isPresent()) {
            return new CustomUserDetails<>(vendor.get(), "ROLE_VENDOR");
        } else if (customer.isPresent()) {
            return new CustomUserDetails<>(customer.get(), "ROLE_CUSTOMER");
        }

        throw new UsernameNotFoundException("User not found with email: " + email);
    }
} 