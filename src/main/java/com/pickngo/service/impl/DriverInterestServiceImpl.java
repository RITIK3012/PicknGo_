package com.pickngo.service.impl;

import com.pickngo.model.*;
import com.pickngo.repository.DriverInterestRepository;
import com.pickngo.repository.DriverRepository;
import com.pickngo.repository.ShipmentRepository;
import com.pickngo.service.DriverInterestService;
import com.pickngo.service.WebSocketService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
public class DriverInterestServiceImpl implements DriverInterestService {

    private final DriverInterestRepository driverInterestRepository;
    private final DriverRepository driverRepository;
    private final ShipmentRepository shipmentRepository;
    private final WebSocketService webSocketService;

    @Autowired
    public DriverInterestServiceImpl(DriverInterestRepository driverInterestRepository,
                                     DriverRepository driverRepository,
                                     ShipmentRepository shipmentRepository,
                                     WebSocketService webSocketService) {
        this.driverInterestRepository = driverInterestRepository;
        this.driverRepository = driverRepository;
        this.shipmentRepository = shipmentRepository;
        this.webSocketService = webSocketService;
    }

    @Override
    @Transactional
    public DriverInterest createInterest(Long driverId, Long shipmentId) {
        Optional<Driver> optionalDriver = driverRepository.findById(driverId);
        Optional<Shipment> optionalShipment = shipmentRepository.findById(shipmentId);
        
        if (optionalDriver.isPresent() && optionalShipment.isPresent()) {
            Shipment shipment = optionalShipment.get();
            
            // Check if the shipment is still in a state where interest can be shown
            if (shipment.getStatus() == ShipmentStatus.PENDING || 
                shipment.getStatus() == ShipmentStatus.INTEREST_SHOWN) {
                
                // Check if interest already exists
                Optional<DriverInterest> existingInterest = driverInterestRepository
                    .findByDriverIdAndShipmentId(driverId, shipmentId);
                
                if (existingInterest.isPresent()) {
                    return existingInterest.get();
                }
                
                // Create new interest
                DriverInterest interest = new DriverInterest();
                interest.setDriver(optionalDriver.get());
                interest.setShipment(shipment);
                interest.setStatus(DriverInterestStatus.PENDING);
                
                // Update shipment status
                shipment.setStatus(ShipmentStatus.INTEREST_SHOWN);
                Shipment updatedShipment = shipmentRepository.save(shipment);
                
                // Save the interest
                DriverInterest savedInterest = driverInterestRepository.save(interest);
                
                // Send WebSocket notifications
                webSocketService.notifyShipmentUpdate(updatedShipment);
                webSocketService.notifyDriverInterestUpdate(savedInterest);
                
                return savedInterest;
            }
        }
        
        return null;
    }

    @Override
    public Optional<DriverInterest> getInterestById(Long id) {
        return driverInterestRepository.findById(id);
    }

    @Override
    public List<DriverInterest> getInterestsByDriverId(Long driverId) {
        return driverInterestRepository.findByDriverId(driverId);
    }

    @Override
    public List<DriverInterest> getInterestsByShipmentId(Long shipmentId) {
        return driverInterestRepository.findByShipmentId(shipmentId);
    }

    @Override
    public List<DriverInterest> getInterestsByDriverIdAndStatus(Long driverId, DriverInterestStatus status) {
        return driverInterestRepository.findByDriverIdAndStatus(driverId, status);
    }

    @Override
    public List<DriverInterest> getInterestsByShipmentIdAndStatus(Long shipmentId, DriverInterestStatus status) {
        return driverInterestRepository.findByShipmentIdAndStatus(shipmentId, status);
    }

    @Override
    public Optional<DriverInterest> getInterestByDriverIdAndShipmentId(Long driverId, Long shipmentId) {
        return driverInterestRepository.findByDriverIdAndShipmentId(driverId, shipmentId);
    }

    @Override
    @Transactional
    public DriverInterest updateInterestStatus(Long interestId, DriverInterestStatus status) {
        Optional<DriverInterest> optionalInterest = driverInterestRepository.findById(interestId);
        
        if (optionalInterest.isPresent()) {
            DriverInterest interest = optionalInterest.get();
            interest.setStatus(status);
            
            // If driver is accepted, update shipment
            if (status == DriverInterestStatus.ACCEPTED) {
                Shipment shipment = interest.getShipment();
                Driver driver = interest.getDriver();
                
                // Set the driver and update status
                shipment.setDriver(driver);
                shipment.setStatus(ShipmentStatus.ASSIGNED);
                
                // Save the shipment changes
                Shipment updatedShipment = shipmentRepository.save(shipment);
                
                // Send WebSocket notification for shipment update
                webSocketService.notifyShipmentUpdate(updatedShipment);
                
                // Reject all other interests for this shipment
                List<DriverInterest> otherInterests = driverInterestRepository.findByShipmentIdAndStatusNot(
                    shipment.getId(), DriverInterestStatus.ACCEPTED);
                
                for (DriverInterest otherInterest : otherInterests) {
                    if (!otherInterest.getId().equals(interest.getId())) {
                        otherInterest.setStatus(DriverInterestStatus.REJECTED);
                        driverInterestRepository.save(otherInterest);
                        webSocketService.notifyDriverInterestUpdate(otherInterest);
                    }
                }
            }
            
            // Save the updated interest
            DriverInterest updatedInterest = driverInterestRepository.save(interest);
            
            // Send WebSocket notification for interest update
            webSocketService.notifyDriverInterestUpdate(updatedInterest);
            
            return updatedInterest;
        }
        
        return null;
    }

    @Override
    public void deleteInterest(Long id) {
        driverInterestRepository.deleteById(id);
    }
} 