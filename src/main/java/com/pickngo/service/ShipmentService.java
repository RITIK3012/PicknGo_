package com.pickngo.service;

import com.pickngo.model.Driver;
import com.pickngo.model.Location;
import com.pickngo.model.Shipment;
import com.pickngo.model.ShipmentStatus;

import java.util.List;
import java.util.Optional;

public interface ShipmentService {
    Shipment createShipment(Shipment shipment);
    Optional<Shipment> getShipmentById(Long id);
    List<Shipment> getAllShipments();
    List<Shipment> getShipmentsByShipperId(Long shipperId);
    List<Shipment> getShipmentsByDriverId(Long driverId);
    List<Shipment> getShipmentsByVendorId(Long vendorId);
    List<Shipment> getShipmentsByStatus(ShipmentStatus status);
    List<Shipment> getAvailableShipments();
    List<Shipment> getUnassignedShipments();
    int assignShipmentsToDriver(Driver driver, List<Shipment> shipments);
    Shipment updateShipment(Shipment shipment);
    void deleteShipment(Long id);
    Shipment assignDriverToShipment(Long shipmentId, Long driverId);
    Shipment updateShipmentStatus(Long shipmentId, ShipmentStatus status);
    Optional<Location> getLatestLocationByShipmentId(Long shipmentId);
    void addLocationToShipment(Location location);
} 