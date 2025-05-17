package com.pickngo.repository;

import com.pickngo.model.Location;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface LocationRepository extends JpaRepository<Location, Long> {
    List<Location> findByDriverId(Long driverId);
    List<Location> findByShipmentId(Long shipmentId);
    
    @Query("SELECT l FROM Location l WHERE l.driver.id = :driverId ORDER BY l.timestamp DESC")
    List<Location> findLocationsByDriverIdOrderByTimestampDesc(@Param("driverId") Long driverId);
    
    default Optional<Location> findLatestLocationByDriverId(Long driverId) {
        List<Location> locations = findLocationsByDriverIdOrderByTimestampDesc(driverId);
        return locations.isEmpty() ? Optional.empty() : Optional.of(locations.get(0));
    }
    
    @Query("SELECT l FROM Location l WHERE l.shipment.id = :shipmentId ORDER BY l.timestamp DESC")
    List<Location> findLocationsByShipmentIdOrderByTimestampDesc(@Param("shipmentId") Long shipmentId);
    
    default Optional<Location> findLatestLocationByShipmentId(Long shipmentId) {
        List<Location> locations = findLocationsByShipmentIdOrderByTimestampDesc(shipmentId);
        return locations.isEmpty() ? Optional.empty() : Optional.of(locations.get(0));
    }
} 