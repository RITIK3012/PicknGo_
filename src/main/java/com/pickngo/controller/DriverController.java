package com.pickngo.controller;

import com.pickngo.model.*;
import com.pickngo.service.DriverInterestService;
import com.pickngo.service.DriverService;
import com.pickngo.service.ShipmentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.http.HttpStatus;

import java.security.Principal;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Controller
@RequestMapping("/driver")
public class DriverController {

    private final DriverService driverService;
    private final ShipmentService shipmentService;
    private final DriverInterestService driverInterestService;

    @Autowired
    public DriverController(DriverService driverService, ShipmentService shipmentService,
                          DriverInterestService driverInterestService) {
        this.driverService = driverService;
        this.shipmentService = shipmentService;
        this.driverInterestService = driverInterestService;
    }

    /**
     * Helper method to mask email for privacy
     * @param email The full email address
     * @return The masked email (first 3 chars + ... + @domain)
     */
    private String maskEmail(String email) {
        if (email == null || email.isEmpty() || !email.contains("@")) {
            return email;
        }
        String[] parts = email.split("@");
        String username = parts[0];
        String domain = parts[1];
        
        // Show only first 3 characters of username
        String maskedUsername = username.length() <= 3 
            ? username 
            : username.substring(0, 3) + "...";
            
        return maskedUsername + "@" + domain;
    }

    @GetMapping("/dashboard")
    public String driverDashboard(Model model, Principal principal) {
        if (principal == null) {
            return "redirect:/login";
        }
        
        Optional<Driver> optionalDriver = driverService.getDriverByEmail(principal.getName());
        if (optionalDriver.isPresent()) {
            Driver driver = optionalDriver.get();
            List<Shipment> shipments = driverService.getShipmentsByDriverId(driver.getId());
            List<Vehicle> vehicles = driverService.getVehiclesByDriverId(driver.getId());
            
            // Get available shipments for the driver to show interest in
            List<Shipment> availableShipments = shipmentService.getAvailableShipments();
            
            // Get all shipments this driver has shown interest in
            List<DriverInterest> interests = driverInterestService.getInterestsByDriverId(driver.getId());
            
            // Create a map of shipmentId -> interest status for easy lookup in the view
            Map<Long, DriverInterestStatus> interestStatusMap = new HashMap<>();
            for (DriverInterest interest : interests) {
                interestStatusMap.put(interest.getShipment().getId(), interest.getStatus());
            }
            
            model.addAttribute("driver", driver);
            model.addAttribute("shipments", shipments);
            model.addAttribute("vehicles", vehicles);
            model.addAttribute("availableShipments", availableShipments);
            model.addAttribute("interestStatusMap", interestStatusMap);
            
            return "driver/dashboard";
        }
        return "redirect:/login";
    }
    
    @GetMapping("/profile")
    public String viewProfile(Model model, Principal principal) {
        Optional<Driver> optionalDriver = driverService.getDriverByEmail(principal.getName());
        if (optionalDriver.isPresent()) {
            model.addAttribute("driver", optionalDriver.get());
            return "driver/profile";
        }
        return "redirect:/login";
    }
    
    @PostMapping("/profile/update")
    public String updateProfile(@ModelAttribute Driver driver, RedirectAttributes redirectAttributes, Principal principal) {
        Optional<Driver> optionalDriver = driverService.getDriverByEmail(principal.getName());
        if (optionalDriver.isPresent()) {
            Driver existingDriver = optionalDriver.get();
            // Only update fields that should be updatable by the driver
            existingDriver.setName(driver.getName());
            existingDriver.setContactNumber(driver.getContactNumber());
            existingDriver.setLicenseNumber(driver.getLicenseNumber());
            existingDriver.setAddress(driver.getAddress());
            existingDriver.setBankName(driver.getBankName());
            existingDriver.setBankAccountNumber(driver.getBankAccountNumber());
            existingDriver.setIfscCode(driver.getIfscCode());
            
            // Only update password if a new one is provided
            if (driver.getPassword() != null && !driver.getPassword().isEmpty()) {
                existingDriver.setPassword(driver.getPassword());
            }
            
            driverService.updateDriver(existingDriver);
            redirectAttributes.addFlashAttribute("success", "Profile updated successfully");
            return "redirect:/driver/profile";
        }
        return "redirect:/login";
    }
    
    @GetMapping("/shipments")
    public String viewShipments(Model model, Principal principal) {
        Optional<Driver> optionalDriver = driverService.getDriverByEmail(principal.getName());
        if (optionalDriver.isPresent() && optionalDriver.get().isVerified()) {
            Driver driver = optionalDriver.get();
            List<Shipment> shipments = driverService.getShipmentsByDriverId(driver.getId());
            
            // Get available shipments for the driver to show interest in
            List<Shipment> availableShipments = shipmentService.getAvailableShipments();
            
            // Get all shipments this driver has shown interest in
            List<DriverInterest> interests = driverInterestService.getInterestsByDriverId(driver.getId());
            
            // Create a map of shipmentId -> interest status for easy lookup in the view
            Map<Long, DriverInterestStatus> interestStatusMap = new HashMap<>();
            for (DriverInterest interest : interests) {
                interestStatusMap.put(interest.getShipment().getId(), interest.getStatus());
            }
            
            model.addAttribute("shipments", shipments);
            model.addAttribute("availableShipments", availableShipments);
            model.addAttribute("interestStatusMap", interestStatusMap);
            
            return "driver/shipments";
        }
        return "redirect:/driver/dashboard";
    }
    
    @GetMapping("/available-shipments")
    public String viewAvailableShipments(Model model, Principal principal) {
        Optional<Driver> optionalDriver = driverService.getDriverByEmail(principal.getName());
        if (optionalDriver.isPresent() && optionalDriver.get().isVerified()) {
            Driver driver = optionalDriver.get();
            
            // Get available shipments for the driver to show interest in
            List<Shipment> availableShipments = shipmentService.getAvailableShipments();
            
            // Get all shipments this driver has shown interest in
            List<DriverInterest> interests = driverInterestService.getInterestsByDriverId(driver.getId());
            
            // Create a map of shipmentId -> interest status for easy lookup in the view
            Map<Long, DriverInterestStatus> interestStatusMap = new HashMap<>();
            for (DriverInterest interest : interests) {
                interestStatusMap.put(interest.getShipment().getId(), interest.getStatus());
            }
            
            model.addAttribute("availableShipments", availableShipments);
            model.addAttribute("interestStatusMap", interestStatusMap);
            
            return "driver/available-shipments";
        }
        return "redirect:/driver/dashboard";
    }
    
    @PostMapping("/show-interest/{shipmentId}")
    @ResponseBody
    public ResponseEntity<?> showInterest(@PathVariable Long shipmentId, Principal principal) {
        Optional<Driver> optionalDriver = driverService.getDriverByEmail("ramukaka@gmail.com");
        System.out.println(optionalDriver);
        if (optionalDriver.isPresent() ){
            Driver driver = optionalDriver.get();
            DriverInterest interest = driverInterestService.createInterest(driver.getId(), shipmentId);

            
            if (interest != null) {
                Map<String, Object> response = new HashMap<>();
                response.put("status", "success");
                response.put("message", "Interest shown successfully");
                return ResponseEntity.ok(response);
            } else {
                Map<String, Object> response = new HashMap<>();
                response.put("status", "error");
                response.put("message", "Failed to show interest in shipment");
                return ResponseEntity.badRequest().body(response);
            }
        } else {
            Map<String, Object> response = new HashMap<>();
            response.put("status", "error");
            response.put("message", "Driver not verified or not found");
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(response);
        }
    }
    
    @GetMapping("/vehicles")
    public String viewVehicles(Model model, Principal principal) {
        Optional<Driver> optionalDriver = driverService.getDriverByEmail(principal.getName());
        if (optionalDriver.isPresent()) {
            List<Vehicle> vehicles = driverService.getVehiclesByDriverId(optionalDriver.get().getId());
            model.addAttribute("vehicles", vehicles);
            model.addAttribute("newVehicle", new Vehicle());
            return "driver/vehicles";
        }
        return "redirect:/login";
    }
    
    @PostMapping("/add-vehicle")
    public String addVehicle(@ModelAttribute Vehicle vehicle, Principal principal) {
        Optional<Driver> optionalDriver = driverService.getDriverByEmail(principal.getName());
        if (optionalDriver.isPresent()) {
            vehicle.setDriver(optionalDriver.get());
            driverService.addVehicle(vehicle);
            return "redirect:/driver/vehicles";
        }
        return "redirect:/login";
    }
    
    @PostMapping("/update-vehicle")
    public String updateVehicle(@ModelAttribute Vehicle vehicle, Principal principal, RedirectAttributes redirectAttributes) {
        Optional<Driver> optionalDriver = driverService.getDriverByEmail(principal.getName());
        if (optionalDriver.isPresent()) {
            vehicle.setDriver(optionalDriver.get());
            driverService.addVehicle(vehicle); // This method updates if id exists
            redirectAttributes.addFlashAttribute("success", "Vehicle updated successfully");
            return "redirect:/driver/vehicles";
        }
        return "redirect:/login";
    }
    
    @GetMapping("/shipments/{id}")
    public String shipmentDetails(@PathVariable Long id, Model model, Principal principal) {
        Optional<Driver> optionalDriver = driverService.getDriverByEmail(principal.getName());
        if (optionalDriver.isPresent()) {
            Driver driver = optionalDriver.get();
            Optional<Shipment> shipment = shipmentService.getShipmentById(id);
            
            if (shipment.isPresent() && shipment.get().getDriver() != null && 
                shipment.get().getDriver().getId().equals(driver.getId())) {
                model.addAttribute("shipment", shipment.get());
                return "driver/shipment-details";
            }
        }
        return "redirect:/driver/shipments";
    }
    
    @PostMapping("/update-shipment-status/{id}")
    public String updateShipmentStatus(@PathVariable Long id, @RequestParam ShipmentStatus status,
                                       @RequestParam Double latitude, @RequestParam Double longitude,
                                       Principal principal) {
        Optional<Driver> optionalDriver = driverService.getDriverByEmail(principal.getName());
        Optional<Shipment> optionalShipment = shipmentService.getShipmentById(id);
        
        if (optionalDriver.isPresent() && optionalShipment.isPresent()) {
            Driver driver = optionalDriver.get();
            Shipment shipment = optionalShipment.get();
            
            // Check if this shipment is assigned to the logged-in driver
            if (shipment.getDriver() != null && shipment.getDriver().getId().equals(driver.getId())) {
                // Update shipment status
                shipmentService.updateShipmentStatus(id, status);
                
                // Add new location data
                Location location = Location.builder()
                        .driver(driver)
                        .shipment(shipment)
                        .latitude(latitude)
                        .longitude(longitude)
                        .timestamp(LocalDateTime.now())
                        .build();
                
                shipmentService.addLocationToShipment(location);
                
                return "redirect:/driver/shipments";
            }
        }
        return "redirect:/driver/dashboard";
    }
    
    @PostMapping("/upload-kyc")
    public String uploadKYC(@RequestParam("kycVideo") MultipartFile kycVideo, Principal principal) {
        Optional<Driver> optionalDriver = driverService.getDriverByEmail(principal.getName());
        if (optionalDriver.isPresent()) {
            // Here would be logic to handle the KYC video upload
            // For now, we'll just update the kycVideoUrl field with a placeholder
            Driver driver = optionalDriver.get();
            driver.setKycVideoUrl("kyc_video_" + driver.getId() + ".mp4");
            driverService.updateDriver(driver);
            return "redirect:/driver/profile";
        }
        return "redirect:/login";
    }

    @GetMapping("/browseShipments")
    public String browseShipments(Model model, Principal principal) {
        Optional<Driver> optionalDriver = driverService.getDriverByEmail(principal.getName());
        if (optionalDriver.isPresent()) {
            Driver driver = optionalDriver.get();
            List<Shipment> availableShipments = shipmentService.getAvailableShipments();
            
            // Mask shipper emails for privacy
            for (Shipment shipment : availableShipments) {
                if (shipment.getShipper() != null && shipment.getShipper().getEmail() != null) {
                    model.addAttribute("maskedShipperEmail_" + shipment.getShipper().getId(), 
                                      maskEmail(shipment.getShipper().getEmail()));
                }
            }
            
            model.addAttribute("shipments", availableShipments);
            model.addAttribute("driver", driver);
            return "driver/browse-shipments";
        }
        return "redirect:/login";
    }
    
    @GetMapping("/myShipments")
    public String myShipments(Model model, Principal principal) {
        Optional<Driver> optionalDriver = driverService.getDriverByEmail(principal.getName());
        if (optionalDriver.isPresent()) {
            Driver driver = optionalDriver.get();
            List<Shipment> assignedShipments = shipmentService.getShipmentsByDriverId(driver.getId());
            
            // Mask shipper emails for privacy
            for (Shipment shipment : assignedShipments) {
                if (shipment.getShipper() != null && shipment.getShipper().getEmail() != null) {
                    model.addAttribute("maskedShipperEmail_" + shipment.getShipper().getId(), 
                                      maskEmail(shipment.getShipper().getEmail()));
                }
            }
            
            model.addAttribute("shipments", assignedShipments);
            return "driver/my-shipments";
        }
        return "redirect:/login";
    }
} 