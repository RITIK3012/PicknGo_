package com.pickngo.service.impl;

import com.pickngo.model.Driver;
import com.pickngo.model.DriverInterest;
import com.pickngo.model.Shipment;
import com.pickngo.model.Vehicle;
import com.pickngo.repository.DriverRepository;
import com.pickngo.repository.ShipmentRepository;
import com.pickngo.repository.VehicleRepository;
import com.pickngo.service.DriverInterestService;
import com.pickngo.service.DriverService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class DriverServiceImpl implements DriverService {

    private final DriverRepository driverRepository;
    private final ShipmentRepository shipmentRepository;
    private final VehicleRepository vehicleRepository;
    private final PasswordEncoder passwordEncoder;
    private final DriverInterestService driverInterestService;

    @Autowired
    public DriverServiceImpl(DriverRepository driverRepository, ShipmentRepository shipmentRepository,
                            VehicleRepository vehicleRepository, PasswordEncoder passwordEncoder,
                            DriverInterestService driverInterestService) {
        this.driverRepository = driverRepository;
        this.shipmentRepository = shipmentRepository;
        this.vehicleRepository = vehicleRepository;
        this.passwordEncoder = passwordEncoder;
        this.driverInterestService = driverInterestService;
    }

    @Override
    public Driver registerDriver(Driver driver) {
        driver.setPassword(passwordEncoder.encode(driver.getPassword()));
        driver.setVerified(false);
        return driverRepository.save(driver);
    }

    @Override
    public Optional<Driver> getDriverById(Long id) {
        return driverRepository.findById(id);
    }

    @Override
    public Optional<Driver> getDriverByEmail(String email) {
        return driverRepository.findByEmail(email);
    }

    @Override
    public List<Driver> getAllDrivers() {
        return driverRepository.findAll();
    }

    @Override
    public List<Driver> getDriversByVendorId(Long vendorId) {
        return driverRepository.findByVendorId(vendorId);
    }

    @Override
    public List<Driver> getVerifiedDrivers() {
        return driverRepository.findByVerifiedTrue();
    }

    @Override
    public Driver updateDriver(Driver driver) {
        if (driver.getPassword() != null && !driver.getPassword().startsWith("$2a$")) {
            driver.setPassword(passwordEncoder.encode(driver.getPassword()));
        }
        return driverRepository.save(driver);
    }

    @Override
    public void deleteDriver(Long id) {
        driverRepository.deleteById(id);
    }

    @Override
    public boolean existsByEmail(String email) {
        return driverRepository.existsByEmail(email);
    }

    @Override
    public void verifyDriver(Long id) {
        driverRepository.findById(id).ifPresent(driver -> {
            driver.setVerified(true);
            driverRepository.save(driver);
        });
    }

    @Override
    public List<Shipment> getShipmentsByDriverId(Long driverId) {
        return shipmentRepository.findByDriverId(driverId);
    }

    @Override
    public List<Vehicle> getVehiclesByDriverId(Long driverId) {
        return vehicleRepository.findByDriverId(driverId);
    }

    @Override
    public Vehicle addVehicle(Vehicle vehicle) {
        return vehicleRepository.save(vehicle);
    }
    
    @Override
    public List<Driver> getInterestedDriversByShipmentId(Long shipmentId) {
        // Get all driver interests for the given shipment
        List<DriverInterest> interests = driverInterestService.getInterestsByShipmentId(shipmentId);
        
        // Extract the driver from each interest
        return interests.stream()
            .map(DriverInterest::getDriver)
            .collect(Collectors.toList());
    }
} 