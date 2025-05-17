package com.pickngo.controller;

import com.pickngo.model.Location;
import com.pickngo.model.Shipment;
import com.pickngo.service.ShipmentService;
import com.pickngo.service.WebSocketService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.stereotype.Controller;

import java.time.LocalDateTime;
import java.util.Map;
import java.util.Optional;

@Controller
public class WebSocketController {

    private final ShipmentService shipmentService;
    private final WebSocketService webSocketService;

    @Autowired
    public WebSocketController(ShipmentService shipmentService, WebSocketService webSocketService) {
        this.shipmentService = shipmentService;
        this.webSocketService = webSocketService;
    }

    /**
     * Handle location updates sent through WebSocket
     */
    @MessageMapping("/location")
    public void processLocationUpdate(Map<String, Object> locationData) {
        try {
            Long shipmentId = ((Number) locationData.get("shipmentId")).longValue();
            Double latitude = (Double) locationData.get("latitude");
            Double longitude = (Double) locationData.get("longitude");
            String simulatedBy = (String) locationData.get("simulatedBy");
            
            // Validate the data
            if (shipmentId == null || latitude == null || longitude == null) {
                return;
            }
            
            Optional<Shipment> optionalShipment = shipmentService.getShipmentById(shipmentId);
            
            if (optionalShipment.isPresent()) {
                Shipment shipment = optionalShipment.get();
                
                // Create location entry
                Location location = Location.builder()
                        .shipment(shipment)
                        .driver(shipment.getDriver())
                        .latitude(latitude)
                        .longitude(longitude)
                        .timestamp(LocalDateTime.now())
                        .build();
                
                // Save the location update
                shipmentService.addLocationToShipment(location);
                
                // If this is a simulation from the admin dashboard, we need to mark it as in transit
                if ("admin".equals(simulatedBy) && 
                        shipment.getStatus() != null && 
                        !shipment.getStatus().toString().equals("IN_TRANSIT")) {
                    shipmentService.updateShipmentStatus(shipmentId, com.pickngo.model.ShipmentStatus.IN_TRANSIT);
                }
                
                // Broadcast the update to all clients
                webSocketService.notifyLocationUpdate(location);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
} 