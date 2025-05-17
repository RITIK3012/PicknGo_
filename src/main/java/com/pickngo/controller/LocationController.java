package com.pickngo.controller;

import com.pickngo.model.Location;
import com.pickngo.model.Shipment;
import com.pickngo.model.ShipmentStatus;
import com.pickngo.service.ShipmentService;
import com.pickngo.service.WebSocketService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

/**
 * REST Controller for handling shipment location updates
 */
@RestController
@RequestMapping("/api/locations")
public class LocationController {

    private final ShipmentService shipmentService;
    private final WebSocketService webSocketService;

    @Autowired
    public LocationController(ShipmentService shipmentService, WebSocketService webSocketService) {
        this.shipmentService = shipmentService;
        this.webSocketService = webSocketService;
    }

    /**
     * Endpoint for admins to simulate a location update
     */
    @PostMapping("/simulate/{shipmentId}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<?> simulateLocation(
            @PathVariable Long shipmentId,
            @RequestParam Double latitude,
            @RequestParam Double longitude) {
        
        Optional<Shipment> optionalShipment = shipmentService.getShipmentById(shipmentId);
        
        if (optionalShipment.isPresent()) {
            Shipment shipment = optionalShipment.get();
            
            // Create location object
            Location location = Location.builder()
                    .shipment(shipment)
                    .driver(shipment.getDriver())
                    .latitude(latitude)
                    .longitude(longitude)
                    .timestamp(LocalDateTime.now())
                    .build();
            
            // Save location
            shipmentService.addLocationToShipment(location);
            
            // If shipment is not already in transit, update its status
            if (shipment.getStatus() != ShipmentStatus.IN_TRANSIT &&
                shipment.getStatus() != ShipmentStatus.DELIVERED) {
                shipmentService.updateShipmentStatus(shipmentId, ShipmentStatus.IN_TRANSIT);
            }
            
            // Send WebSocket notification
            webSocketService.notifyLocationUpdate(location);
            
            Map<String, Object> response = new HashMap<>();
            response.put("status", "success");
            response.put("message", "Location simulated successfully");
            response.put("latitude", latitude);
            response.put("longitude", longitude);
            response.put("timestamp", location.getTimestamp().toString());
            
            return ResponseEntity.ok(response);
        }
        
        Map<String, Object> response = new HashMap<>();
        response.put("status", "error");
        response.put("message", "Shipment not found");
        
        return ResponseEntity.badRequest().body(response);
    }
    
    /**
     * Get the latest location for a shipment
     */
    @GetMapping("/{shipmentId}/latest")
    public ResponseEntity<?> getLatestLocation(@PathVariable Long shipmentId) {
        Optional<Location> latestLocation = shipmentService.getLatestLocationByShipmentId(shipmentId);
        
        if (latestLocation.isPresent()) {
            Map<String, Object> response = new HashMap<>();
            Location location = latestLocation.get();
            
            response.put("shipmentId", shipmentId);
            response.put("latitude", location.getLatitude());
            response.put("longitude", location.getLongitude());
            response.put("timestamp", location.getTimestamp().toString());
            
            return ResponseEntity.ok(response);
        }
        
        return ResponseEntity.notFound().build();
    }
} 