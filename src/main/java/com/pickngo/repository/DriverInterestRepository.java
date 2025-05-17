package com.pickngo.repository;

import com.pickngo.model.DriverInterest;
import com.pickngo.model.DriverInterestStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface DriverInterestRepository extends JpaRepository<DriverInterest, Long> {
    List<DriverInterest> findByDriverId(Long driverId);
    List<DriverInterest> findByShipmentId(Long shipmentId);
    List<DriverInterest> findByDriverIdAndStatus(Long driverId, DriverInterestStatus status);
    List<DriverInterest> findByShipmentIdAndStatus(Long shipmentId, DriverInterestStatus status);
    List<DriverInterest> findByShipmentIdAndStatusNot(Long shipmentId, DriverInterestStatus status);
    Optional<DriverInterest> findByDriverIdAndShipmentId(Long driverId, Long shipmentId);
} 