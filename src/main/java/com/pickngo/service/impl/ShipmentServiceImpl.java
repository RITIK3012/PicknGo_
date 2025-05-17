package com.pickngo.service.impl;

import com.pickngo.model.Driver;
import com.pickngo.model.Location;
import com.pickngo.model.Shipment;
import com.pickngo.model.ShipmentStatus;
import com.pickngo.repository.DriverRepository;
import com.pickngo.repository.LocationRepository;
import com.pickngo.repository.ShipmentRepository;
import com.pickngo.service.ShipmentService;
import com.pickngo.service.WebSocketService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Optional;
import java.util.Random;

@Service
public class ShipmentServiceImpl implements ShipmentService {

    private final ShipmentRepository shipmentRepository;
    private final DriverRepository driverRepository;
    private final LocationRepository locationRepository;
    private final WebSocketService webSocketService;
    private final Random random = new Random();

    @Autowired
    public ShipmentServiceImpl(ShipmentRepository shipmentRepository, DriverRepository driverRepository,
                               LocationRepository locationRepository, WebSocketService webSocketService) {
        this.shipmentRepository = shipmentRepository;
        this.driverRepository = driverRepository;
        this.locationRepository = locationRepository;
        this.webSocketService = webSocketService;
    }

    @Override
    public Shipment createShipment(Shipment shipment) {
        shipment.setStatus(ShipmentStatus.PENDING);
        shipment.setTrackingNumber(generateTrackingNumber());
        Shipment savedShipment = shipmentRepository.save(shipment);
        
        // Send WebSocket notification
        webSocketService.notifyShipmentUpdate(savedShipment);
        
        return savedShipment;
    }

    private String generateTrackingNumber() {
        // Format: PG + YearMonthDay + 6 random digits
        LocalDateTime now = LocalDateTime.now();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyMMdd");
        String datePart = now.format(formatter);
        
        // Generate 6 random digits
        int randomNumber = 100000 + random.nextInt(900000);
        
        return "PG" + datePart + randomNumber;
    }

    @Override
    public Optional<Shipment> getShipmentById(Long id) {
        return shipmentRepository.findById(id);
    }

    @Override
    public List<Shipment> getAllShipments() {
        return shipmentRepository.findAll();
    }

    @Override
    public List<Shipment> getShipmentsByShipperId(Long shipperId) {
        return shipmentRepository.findByShipperId(shipperId);
    }

    @Override
    public List<Shipment> getShipmentsByDriverId(Long driverId) {
        return shipmentRepository.findByDriverId(driverId);
    }

    @Override
    public List<Shipment> getShipmentsByStatus(ShipmentStatus status) {
        return shipmentRepository.findByStatus(status);
    }

    @Override
    public List<Shipment> getAvailableShipments() {
        // Get shipments that are PENDING or have INTEREST_SHOWN and not yet assigned to a driver
        List<ShipmentStatus> availableStatuses = Arrays.asList(ShipmentStatus.PENDING, ShipmentStatus.INTEREST_SHOWN);
        List<Shipment> availableShipments = new ArrayList<>();
        
        for (ShipmentStatus status : availableStatuses) {
            List<Shipment> shipments = shipmentRepository.findByStatus(status);
            for (Shipment shipment : shipments) {
                if (shipment.getDriver() == null) {
                    availableShipments.add(shipment);
                }
            }
        }
        
        return availableShipments;
    }

    @Override
    public List<Shipment> getUnassignedShipments() {
        // Get all shipments without a driver assigned, regardless of status
        return shipmentRepository.findByDriverIsNull();
    }

    @Override
    public int assignShipmentsToDriver(Driver driver, List<Shipment> shipments) {
        int assignedCount = 0;
        
        for (Shipment shipment : shipments) {
            // Assign driver and update status
            shipment.setDriver(driver);
            shipment.setStatus(ShipmentStatus.ASSIGNED);
            shipmentRepository.save(shipment);
            
            // Send WebSocket notification for each shipment update
            webSocketService.notifyShipmentUpdate(shipment);
            assignedCount++;
        }
        
        // Send a consolidated notification about all assignments
        if (assignedCount > 0) {
            webSocketService.notifyBulkAssignment(driver, assignedCount);
        }
        
        return assignedCount;
    }

    @Override
    public Shipment updateShipment(Shipment shipment) {
        // Ensure existing shipments also have tracking numbers
        if (shipment.getTrackingNumber() == null || shipment.getTrackingNumber().isEmpty()) {
            shipment.setTrackingNumber(generateTrackingNumber());
        }
        Shipment updatedShipment = shipmentRepository.save(shipment);
        
        // Send WebSocket notification
        webSocketService.notifyShipmentUpdate(updatedShipment);
        
        return updatedShipment;
    }

    @Override
    public void deleteShipment(Long id) {
        shipmentRepository.deleteById(id);
    }

    @Override
    public Shipment assignDriverToShipment(Long shipmentId, Long driverId) {
        Optional<Shipment> optionalShipment = shipmentRepository.findById(shipmentId);
        Optional<Driver> optionalDriver = driverRepository.findById(driverId);
        
        if (optionalShipment.isPresent() && optionalDriver.isPresent()) {
            Shipment shipment = optionalShipment.get();
            shipment.setDriver(optionalDriver.get());
            shipment.setStatus(ShipmentStatus.ASSIGNED);
            Shipment updatedShipment = shipmentRepository.save(shipment);
            
            // Send WebSocket notification
            webSocketService.notifyShipmentUpdate(updatedShipment);
            
            return updatedShipment;
        }
        
        return null;
    }

    @Override
    public Shipment updateShipmentStatus(Long shipmentId, ShipmentStatus status) {
        Optional<Shipment> optionalShipment = shipmentRepository.findById(shipmentId);
        
        if (optionalShipment.isPresent()) {
            Shipment shipment = optionalShipment.get();
            shipment.setStatus(status);
            
            if (status == ShipmentStatus.PICKED_UP) {
                shipment.setPickupTime(LocalDateTime.now());
            } else if (status == ShipmentStatus.DELIVERED) {
                shipment.setDeliveryTime(LocalDateTime.now());
            }
            
            Shipment updatedShipment = shipmentRepository.save(shipment);
            
            // Send WebSocket notification
            webSocketService.notifyShipmentUpdate(updatedShipment);
            
            return updatedShipment;
        }
        
        return null;
    }

    @Override
    public Optional<Location> getLatestLocationByShipmentId(Long shipmentId) {
        return locationRepository.findLatestLocationByShipmentId(shipmentId);
    }

    @Override
    public void addLocationToShipment(Location location) {
        locationRepository.save(location);
        
        // Send WebSocket notification for the location update
        webSocketService.notifyLocationUpdate(location);
    }

    @Override
    public List<Shipment> getShipmentsByVendorId(Long vendorId) {
        // Get all drivers for the vendor
        List<Driver> drivers = driverRepository.findByVendorId(vendorId);
        
        // Collect all shipments assigned to those drivers
        List<Shipment> shipments = new ArrayList<>();
        for (Driver driver : drivers) {
            shipments.addAll(shipmentRepository.findByDriverId(driver.getId()));
        }
        
        return shipments;
    }
} 