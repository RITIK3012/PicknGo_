package com.pickngo.repository;

import com.pickngo.model.Shipment;
import com.pickngo.model.ShipmentStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ShipmentRepository extends JpaRepository<Shipment, Long> {
    List<Shipment> findByShipperId(Long shipperId);
    List<Shipment> findByDriverId(Long driverId);
    List<Shipment> findByStatus(ShipmentStatus status);
    List<Shipment> findByShipperIdAndStatus(Long shipperId, ShipmentStatus status);
    List<Shipment> findByDriverIdAndStatus(Long driverId, ShipmentStatus status);
    List<Shipment> findByDriverIsNull();
} 