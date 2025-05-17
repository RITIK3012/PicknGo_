package com.pickngo.service;

import com.pickngo.model.Shipper;
import com.pickngo.model.Shipment;

import java.util.List;
import java.util.Optional;

public interface ShipperService {
    Shipper registerShipper(Shipper shipper);
    Optional<Shipper> getShipperById(Long id);
    Optional<Shipper> getShipperByEmail(String email);
    List<Shipper> getAllShippers();
    Shipper updateShipper(Shipper shipper);
    void deleteShipper(Long id);
    boolean existsByEmail(String email);
    List<Shipment> getShipmentsByShipperId(Long shipperId);
} 