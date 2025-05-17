package com.pickngo.service;

import com.pickngo.model.Driver;
import com.pickngo.model.Shipment;
import com.pickngo.model.Vehicle;

import java.util.List;
import java.util.Optional;

public interface DriverService {
    Driver registerDriver(Driver driver);
    Optional<Driver> getDriverById(Long id);
    Optional<Driver> getDriverByEmail(String email);
    List<Driver> getAllDrivers();
    List<Driver> getDriversByVendorId(Long vendorId);
    List<Driver> getVerifiedDrivers();
    Driver updateDriver(Driver driver);
    void deleteDriver(Long id);
    boolean existsByEmail(String email);
    void verifyDriver(Long id);
    List<Shipment> getShipmentsByDriverId(Long driverId);
    List<Vehicle> getVehiclesByDriverId(Long driverId);
    Vehicle addVehicle(Vehicle vehicle);
    List<Driver> getInterestedDriversByShipmentId(Long shipmentId);
} 