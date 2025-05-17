package com.pickngo.controller;

import com.pickngo.model.Shipment;
import com.pickngo.service.ShipmentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

/**
 * Utility controller for admin functions
 */
@Controller
@RequestMapping("/admin/util")
@PreAuthorize("hasRole('ADMIN')")
public class AdminUtilController {

    private final ShipmentService shipmentService;

    @Autowired
    public AdminUtilController(ShipmentService shipmentService) {
        this.shipmentService = shipmentService;
    }

    /**
     * Utility endpoint to update all existing shipments that don't have tracking numbers
     * This should be run after adding the trackingNumber field to the Shipment model
     */
    @GetMapping(value = "/generate-tracking-numbers", produces = MediaType.TEXT_PLAIN_VALUE)
    @ResponseBody
    public String generateTrackingNumbers() {
        List<Shipment> shipments = shipmentService.getAllShipments();
        int updatedCount = 0;
        
        for (Shipment shipment : shipments) {
            if (shipment.getTrackingNumber() == null || shipment.getTrackingNumber().isEmpty()) {
                shipmentService.updateShipment(shipment);
                updatedCount++;
            }
        }
        
        if (updatedCount == 0) {
            return "All shipments already have tracking numbers. No updates needed.";
        } else {
            return "Success! Updated " + updatedCount + " shipments with tracking numbers.";
        }
    }
} 