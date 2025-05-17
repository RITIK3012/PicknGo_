package com.pickngo.service;

import com.pickngo.model.DriverInterest;
import com.pickngo.model.DriverInterestStatus;

import java.util.List;
import java.util.Optional;

public interface DriverInterestService {
    DriverInterest createInterest(Long driverId, Long shipmentId);
    Optional<DriverInterest> getInterestById(Long id);
    List<DriverInterest> getInterestsByDriverId(Long driverId);
    List<DriverInterest> getInterestsByShipmentId(Long shipmentId);
    List<DriverInterest> getInterestsByDriverIdAndStatus(Long driverId, DriverInterestStatus status);
    List<DriverInterest> getInterestsByShipmentIdAndStatus(Long shipmentId, DriverInterestStatus status);
    Optional<DriverInterest> getInterestByDriverIdAndShipmentId(Long driverId, Long shipmentId);
    DriverInterest updateInterestStatus(Long interestId, DriverInterestStatus status);
    void deleteInterest(Long id);
} 