package com.pickngo.service;

import com.pickngo.model.Driver;
import com.pickngo.model.DriverInterest;
import com.pickngo.model.Location;
import com.pickngo.model.Shipment;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.Map;

@Service
public class WebSocketService {

    private final SimpMessagingTemplate messagingTemplate;
    private static final DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    @Autowired
    public WebSocketService(SimpMessagingTemplate messagingTemplate) {
        this.messagingTemplate = messagingTemplate;
    }

    public void notifyShipmentUpdate(Shipment shipment) {
        Map<String, Object> payload = new HashMap<>();
        payload.put("type", "SHIPMENT_UPDATE");
        payload.put("shipmentId", shipment.getId());
        payload.put("status", shipment.getStatus());
        
        // Notify all users subscribed to this topic
        messagingTemplate.convertAndSend("/topic/shipments", payload);
        
        // Notify specific shipper
        if (shipment.getShipper() != null) {
            messagingTemplate.convertAndSend("/topic/shipper/" + shipment.getShipper().getId(), payload);
        }
        
        // Notify specific driver if assigned
        if (shipment.getDriver() != null) {
            messagingTemplate.convertAndSend("/topic/driver/" + shipment.getDriver().getId(), payload);
        }
    }
    
    public void notifyDriverInterestUpdate(DriverInterest interest) {
        Map<String, Object> payload = new HashMap<>();
        payload.put("type", "INTEREST_UPDATE");
        payload.put("interestId", interest.getId());
        payload.put("shipmentId", interest.getShipment().getId());
        payload.put("driverId", interest.getDriver().getId());
        payload.put("status", interest.getStatus());
        
        // Notify all admins
        messagingTemplate.convertAndSend("/topic/admin/interests", payload);
        
        // Notify specific shipper
        if (interest.getShipment().getShipper() != null) {
            messagingTemplate.convertAndSend("/topic/shipper/" + interest.getShipment().getShipper().getId(), payload);
        }
        
        // Notify specific driver
        messagingTemplate.convertAndSend("/topic/driver/" + interest.getDriver().getId(), payload);
    }
    
    public void notifyBulkAssignment(Driver driver, int count) {
        Map<String, Object> payload = new HashMap<>();
        payload.put("type", "BULK_ASSIGNMENT");
        payload.put("driverId", driver.getId());
        payload.put("driverName", driver.getName());
        payload.put("shipmentCount", count);
        payload.put("timestamp", LocalDateTime.now().toString());
        
        // Notify about driver assignments to all admin dashboards
        messagingTemplate.convertAndSend("/topic/admin/assignments", payload);
        
        // Notify the specific driver
        messagingTemplate.convertAndSend("/topic/driver/" + driver.getId(), payload);
        
        // Notify the vendor if driver has one
        if (driver.getVendor() != null) {
            messagingTemplate.convertAndSend("/topic/vendor/" + driver.getVendor().getId(), payload);
        }
        
        // Broadcast to driver-assignments topic for anyone interested
        messagingTemplate.convertAndSend("/topic/driver-assignments", payload);
    }
    
    /**
     * Notify all clients about a location update
     */
    public void notifyLocationUpdate(Location location) {
        if (location == null || location.getShipment() == null) {
            return;
        }
        
        Map<String, Object> payload = new HashMap<>();
        payload.put("type", "LOCATION_UPDATE");
        payload.put("shipmentId", location.getShipment().getId());
        payload.put("latitude", location.getLatitude());
        payload.put("longitude", location.getLongitude());
        payload.put("timestamp", location.getTimestamp().format(formatter));
        
        // Format timestamp for display
        String formattedTimestamp = location.getTimestamp() != null
                ? location.getTimestamp().format(formatter)
                : LocalDateTime.now().format(formatter);
        payload.put("formattedTimestamp", formattedTimestamp);
        
        // General shipment location topic
        messagingTemplate.convertAndSend("/topic/shipments/locations", payload);
        
        // Admin-specific location updates
        messagingTemplate.convertAndSend("/topic/admin/locations", payload);
        
        // Specific shipment location updates
        messagingTemplate.convertAndSend("/topic/shipment/" + location.getShipment().getId() + "/location", payload);
        
        // Notify the shipper
        if (location.getShipment().getShipper() != null) {
            messagingTemplate.convertAndSend("/topic/shipper/" + location.getShipment().getShipper().getId() + "/locations", payload);
        }
        
        // Notify the driver
        if (location.getDriver() != null) {
            messagingTemplate.convertAndSend("/topic/driver/" + location.getDriver().getId() + "/locations", payload);
        }
    }
} 