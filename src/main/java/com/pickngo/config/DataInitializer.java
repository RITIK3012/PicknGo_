package com.pickngo.config;

import com.pickngo.model.Admin;
import com.pickngo.model.Driver;
import com.pickngo.model.Shipper;
import com.pickngo.model.Vendor;
import com.pickngo.repository.AdminRepository;
import com.pickngo.repository.DriverRepository;
import com.pickngo.repository.ShipperRepository;
import com.pickngo.repository.VendorRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

@Component
public class DataInitializer implements CommandLineRunner {

    private final AdminRepository adminRepository;
    private final ShipperRepository shipperRepository;
    private final DriverRepository driverRepository;
    private final VendorRepository vendorRepository;
    private final PasswordEncoder passwordEncoder;

    @Autowired
    public DataInitializer(AdminRepository adminRepository, ShipperRepository shipperRepository,
                          DriverRepository driverRepository, VendorRepository vendorRepository,
                          PasswordEncoder passwordEncoder) {
        this.adminRepository = adminRepository;
        this.shipperRepository = shipperRepository;
        this.driverRepository = driverRepository;
        this.vendorRepository = vendorRepository;
        this.passwordEncoder = passwordEncoder;
    }

    @Override
    public void run(String... args) throws Exception {
        // Create default admin if none exists
        if (adminRepository.count() == 0) {
            Admin admin = Admin.builder()
                    .name("Admin User")
                    .email("admin@pickngo.com")
                    .password(passwordEncoder.encode("admin123"))
                    .contactNumber("9999999999")
                    .department("IT")
                    .position("System Administrator")
                    .build();
            
            adminRepository.save(admin);
        }
        
        // Create a sample shipper if none exists
        if (shipperRepository.count() == 0) {
            Shipper shipper = Shipper.builder()
                    .name("John Doe")
                    .email("shipper@pickngo.com")
                    .password(passwordEncoder.encode("shipper123"))
                    .contactNumber("9876543210")
                    .companyName("ABC Enterprises")
                    .address("123 Main St, Anytown")
                    .build();
            
            shipperRepository.save(shipper);
        }
        
        // Create a sample driver if none exists
        if (driverRepository.count() == 0) {
            Driver driver = Driver.builder()
                    .name("Mike Smith")
                    .email("driver@pickngo.com")
                    .password(passwordEncoder.encode("driver123"))
                    .contactNumber("8765432109")
                    .licenseNumber("DL123456789")
                    .bankAccountNumber("1234567890")
                    .bankName("HDFC Bank")
                    .ifscCode("HDFC0001234")
                    .verified(true)
                    .build();
            
            driverRepository.save(driver);
        }
        
        // Create a sample vendor if none exists
        if (vendorRepository.count() == 0) {
            Vendor vendor = Vendor.builder()
                    .name("Jane Wilson")
                    .email("vendor@pickngo.com")
                    .password(passwordEncoder.encode("vendor123"))
                    .contactNumber("7654321098")
                    .companyName("XYZ Logistics")
                    .businessRegistrationNumber("BR123456789")
                    .address("456 Oak St, Othertown")
                    .build();
            
            vendorRepository.save(vendor);
        }
    }
} 