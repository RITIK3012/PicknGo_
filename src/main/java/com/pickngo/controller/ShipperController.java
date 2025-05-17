package com.pickngo.controller;

import com.pickngo.config.CustomUserDetails;
import com.pickngo.model.*;
import com.pickngo.service.DriverInterestService;
import com.pickngo.service.DriverService;
import com.pickngo.service.ShipperService;
import com.pickngo.service.ShipmentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.*;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.beans.PropertyEditorSupport;
import java.security.Principal;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/shipper")
public class ShipperController {

    private final ShipperService shipperService;
    private final ShipmentService shipmentService;
    private final DriverInterestService driverInterestService;
    private final DriverService driverService;
    private final SimpMessagingTemplate simpMessagingTemplate;

    @Autowired
    public ShipperController(ShipperService shipperService, ShipmentService shipmentService,
                           DriverInterestService driverInterestService, DriverService driverService,
                           SimpMessagingTemplate simpMessagingTemplate) {
        this.shipperService = shipperService;
        this.shipmentService = shipmentService;
        this.driverInterestService = driverInterestService;
        this.driverService = driverService;
        this.simpMessagingTemplate = simpMessagingTemplate;
    }
    
    @InitBinder
    public void initBinder(WebDataBinder binder) {
        binder.registerCustomEditor(LocalDateTime.class, new PropertyEditorSupport() {
            @Override
            public void setAsText(String text) {
                if (text == null || text.trim().isEmpty()) {
                    setValue(null);
                } else {
                    // Make sure seconds are added if missing
                    if (text.matches("\\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}")) {
                        text = text + ":00";
                    }
                    setValue(LocalDateTime.parse(text, DateTimeFormatter.ISO_LOCAL_DATE_TIME));
                }
            }
        });
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
    public String shipperDashboard(Model model) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        CustomUserDetails userDetails = (CustomUserDetails) auth.getPrincipal();
        Shipper shipper = (Shipper) userDetails.getUser();
        
        List<Shipment> shipments = shipperService.getShipmentsByShipperId(shipper.getId());
        
        // Get shipments with driver interests for this shipper
        Map<Long, List<DriverInterest>> shipmentInterestsMap = new HashMap<>();
        for (Shipment shipment : shipments) {
            if (shipment.getStatus() == ShipmentStatus.INTEREST_SHOWN) {
                List<DriverInterest> interests = driverInterestService.getInterestsByShipmentId(shipment.getId());
                if (!interests.isEmpty()) {
                    shipmentInterestsMap.put(shipment.getId(), interests);
                }
            }
        }
        
        model.addAttribute("shipper", shipper);
        model.addAttribute("shipments", shipments);
        model.addAttribute("shipmentInterestsMap", shipmentInterestsMap);
        return "shipper/dashboard";
    }
    
    @GetMapping("/profile")
    public String viewProfile(Model model) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        CustomUserDetails userDetails = (CustomUserDetails) auth.getPrincipal();
        Shipper shipper = (Shipper) userDetails.getUser();
        
        model.addAttribute("shipper", shipper);
        return "shipper/profile";
    }
    
    @GetMapping("/create-shipment")
    public String showCreateShipmentForm(Model model) {
        model.addAttribute("shipment", new Shipment());
        return "shipper/create-shipment";
    }
    
    @PostMapping("/create-shipment")
    public String createShipment(@ModelAttribute Shipment shipment) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        CustomUserDetails userDetails = (CustomUserDetails) auth.getPrincipal();
        Shipper shipper = (Shipper) userDetails.getUser();
        
        shipment.setShipper(shipper);
        shipmentService.createShipment(shipment);
        return "redirect:/shipper/shipments";
    }
    
    @GetMapping("/shipments")
    public String viewShipments(Model model) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        CustomUserDetails userDetails = (CustomUserDetails) auth.getPrincipal();
        Shipper shipper = (Shipper) userDetails.getUser();
        
        List<Shipment> shipments = shipmentService.getShipmentsByShipperId(shipper.getId());
        
        // Add masked emails to driver data if available
        for (Shipment shipment : shipments) {
            if (shipment.getDriver() != null && shipment.getDriver().getEmail() != null) {
                model.addAttribute("maskedDriverEmail_" + shipment.getDriver().getId(), 
                                  maskEmail(shipment.getDriver().getEmail()));
            }
        }
        
        // Get shipments with driver interests for this shipper
        Map<Long, List<DriverInterest>> shipmentInterestsMap = new HashMap<>();
        for (Shipment shipment : shipments) {
            if (shipment.getStatus() == ShipmentStatus.INTEREST_SHOWN) {
                List<DriverInterest> interests = driverInterestService.getInterestsByShipmentId(shipment.getId());
                if (!interests.isEmpty()) {
                    shipmentInterestsMap.put(shipment.getId(), interests);
                }
            }
        }
        
        model.addAttribute("shipments", shipments);
        model.addAttribute("shipmentInterestsMap", shipmentInterestsMap);
        return "shipper/shipments";
    }
    
    @GetMapping("/shipment/{id}")
    public String viewShipmentDetails(@PathVariable Long id, Model model) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        CustomUserDetails userDetails = (CustomUserDetails) auth.getPrincipal();
        Shipper shipper = (Shipper) userDetails.getUser();
        
        Optional<Shipment> optionalShipment = shipmentService.getShipmentById(id);
        
        if (optionalShipment.isPresent()) {
            Shipment shipment = optionalShipment.get();
            
            // Check if this shipment belongs to the logged-in shipper
            if (shipment.getShipper().getId().equals(shipper.getId())) {
                // Get all driver interests for this shipment
                List<DriverInterest> interests = driverInterestService.getInterestsByShipmentId(id);
                
                // Extract the drivers from the interests
                List<Driver> interestedDrivers = interests.stream()
                                             .map(DriverInterest::getDriver)
                                             .collect(Collectors.toList());
                
                // Add masked emails for all interested drivers
                for (Driver driver : interestedDrivers) {
                    model.addAttribute("maskedDriverEmail_" + driver.getId(), 
                                     maskEmail(driver.getEmail()));
                }
                
                model.addAttribute("shipment", shipment);
                model.addAttribute("interestedDrivers", interestedDrivers);
                return "shipper/shipment-details";
            }
        }
        return "redirect:/shipper/shipments";
    }
    
    @PostMapping("/accept-driver/{interestId}")
    @ResponseBody
    public ResponseEntity<?> acceptDriver(@PathVariable Long interestId) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        CustomUserDetails userDetails = (CustomUserDetails) auth.getPrincipal();
        Shipper shipper = (Shipper) userDetails.getUser();
        
        Optional<DriverInterest> optionalInterest = driverInterestService.getInterestById(interestId);
        if (optionalInterest.isPresent()) {
            DriverInterest interest = optionalInterest.get();
            Shipment shipment = interest.getShipment();
            
            // Make sure this shipment belongs to the shipper
            if (shipment.getShipper().getId().equals(shipper.getId())) {
                // Update interest status
                DriverInterest updatedInterest = driverInterestService.updateInterestStatus(
                    interestId, DriverInterestStatus.ACCEPTED);
                
                if (updatedInterest != null) {
                    Map<String, Object> response = new HashMap<>();
                    response.put("status", "success");
                    response.put("message", "Driver accepted successfully");
                    return ResponseEntity.ok(response);
                }
            }
        }
        
        Map<String, Object> response = new HashMap<>();
        response.put("status", "error");
        response.put("message", "Failed to accept driver");
        return ResponseEntity.badRequest().body(response);
    }
    
    @PostMapping("/reject-driver/{interestId}")
    @ResponseBody
    public ResponseEntity<?> rejectDriver(@PathVariable Long interestId) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        CustomUserDetails userDetails = (CustomUserDetails) auth.getPrincipal();
        Shipper shipper = (Shipper) userDetails.getUser();
        
        Optional<DriverInterest> optionalInterest = driverInterestService.getInterestById(interestId);
        if (optionalInterest.isPresent()) {
            DriverInterest interest = optionalInterest.get();
            Shipment shipment = interest.getShipment();
            
            // Make sure this shipment belongs to the shipper
            if (shipment.getShipper().getId().equals(shipper.getId())) {
                // Update interest status
                DriverInterest updatedInterest = driverInterestService.updateInterestStatus(
                    interestId, DriverInterestStatus.REJECTED);
                
                if (updatedInterest != null) {
                    Map<String, Object> response = new HashMap<>();
                    response.put("status", "success");
                    response.put("message", "Driver rejected successfully");
                    return ResponseEntity.ok(response);
                }
            }
        }
        
        Map<String, Object> response = new HashMap<>();
        response.put("status", "error");
        response.put("message", "Failed to reject driver");
        return ResponseEntity.badRequest().body(response);
    }
} 