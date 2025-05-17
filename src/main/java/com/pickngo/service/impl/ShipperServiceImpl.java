package com.pickngo.service.impl;

import com.pickngo.model.Shipper;
import com.pickngo.model.Shipment;
import com.pickngo.repository.ShipperRepository;
import com.pickngo.repository.ShipmentRepository;
import com.pickngo.service.ShipperService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class ShipperServiceImpl implements ShipperService {

    private final ShipperRepository shipperRepository;
    private final ShipmentRepository shipmentRepository;
    private final PasswordEncoder passwordEncoder;

    @Autowired
    public ShipperServiceImpl(ShipperRepository shipperRepository, ShipmentRepository shipmentRepository, 
                              PasswordEncoder passwordEncoder) {
        this.shipperRepository = shipperRepository;
        this.shipmentRepository = shipmentRepository;
        this.passwordEncoder = passwordEncoder;
    }

    @Override
    public Shipper registerShipper(Shipper shipper) {
        shipper.setPassword(passwordEncoder.encode(shipper.getPassword()));
        return shipperRepository.save(shipper);
    }

    @Override
    public Optional<Shipper> getShipperById(Long id) {
        return shipperRepository.findById(id);
    }

    @Override
    public Optional<Shipper> getShipperByEmail(String email) {
        return shipperRepository.findByEmail(email);
    }

    @Override
    public List<Shipper> getAllShippers() {
        return shipperRepository.findAll();
    }

    @Override
    public Shipper updateShipper(Shipper shipper) {
        if (shipper.getPassword() != null && !shipper.getPassword().startsWith("$2a$")) {
            shipper.setPassword(passwordEncoder.encode(shipper.getPassword()));
        }
        return shipperRepository.save(shipper);
    }

    @Override
    public void deleteShipper(Long id) {
        shipperRepository.deleteById(id);
    }

    @Override
    public boolean existsByEmail(String email) {
        return shipperRepository.existsByEmail(email);
    }

    @Override
    public List<Shipment> getShipmentsByShipperId(Long shipperId) {
        return shipmentRepository.findByShipperId(shipperId);
    }
} 