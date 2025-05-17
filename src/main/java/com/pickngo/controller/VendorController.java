package com.pickngo.controller;

import com.pickngo.model.Driver;
import com.pickngo.model.Shipment;
import com.pickngo.model.Vendor;
import com.pickngo.service.DriverService;
import com.pickngo.service.ShipmentService;
import com.pickngo.service.VendorService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.security.Principal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/vendor")
public class VendorController {

    private final VendorService vendorService;
    private final DriverService driverService;
    private final ShipmentService shipmentService;
    private final SimpMessagingTemplate simpMessagingTemplate;

    @Autowired
    public VendorController(VendorService vendorService, DriverService driverService, ShipmentService shipmentService, SimpMessagingTemplate simpMessagingTemplate) {
        this.vendorService = vendorService;
        this.driverService = driverService;
        this.shipmentService = shipmentService;
        this.simpMessagingTemplate = simpMessagingTemplate;
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
    public String vendorDashboard(Model model, Principal principal) {
        Optional<Vendor> optionalVendor = vendorService.getVendorByEmail(principal.getName());
        if (optionalVendor.isPresent()) {
            Vendor vendor = optionalVendor.get();
            List<Driver> drivers = vendorService.getDriversByVendorId(vendor.getId());
            
            List<Shipment> allShipments = new ArrayList<>();
            for (Driver driver : drivers) {
                allShipments.addAll(driverService.getShipmentsByDriverId(driver.getId()));
            }
            
            model.addAttribute("vendor", vendor);
            model.addAttribute("drivers", drivers);
            model.addAttribute("shipments", allShipments);
            return "vendor/dashboard";
        }
        return "redirect:/login";
    }
    
    @GetMapping("/profile")
    public String viewProfile(Model model, Principal principal) {
        Optional<Vendor> optionalVendor = vendorService.getVendorByEmail(principal.getName());
        if (optionalVendor.isPresent()) {
            model.addAttribute("vendor", optionalVendor.get());
            return "vendor/profile";
        }
        return "redirect:/login";
    }
    
    @GetMapping("/drivers")
    public String viewDrivers(Model model, Principal principal) {
        Optional<Vendor> optionalVendor = vendorService.getVendorByEmail(principal.getName());
        if (optionalVendor.isPresent()) {
            List<Driver> drivers = driverService.getAllDrivers();
            
            // Mask driver emails for privacy
            for (Driver driver : drivers) {
                if (driver.getEmail() != null) {
                    model.addAttribute("maskedDriverEmail_" + driver.getId(), 
                                     maskEmail(driver.getEmail()));
                }
            }
            
            model.addAttribute("drivers", drivers);
            return "vendor/drivers";
        }
        return "redirect:/login";
    }
    
    @GetMapping("/assign-driver")
    public String showAssignDriverForm(Model model, Principal principal) {
        Optional<Vendor> optionalVendor = vendorService.getVendorByEmail(principal.getName());
        if (optionalVendor.isPresent()) {
            // Get all verified drivers without a vendor
            List<Driver> availableDrivers = driverService.getVerifiedDrivers().stream()
                    .filter(driver -> driver.getVendor() == null)
                    .collect(Collectors.toList());
            
            model.addAttribute("availableDrivers", availableDrivers);
            return "vendor/assign-driver";
        }
        return "redirect:/login";
    }
    
    @PostMapping("/assign-driver")
    public String assignDriver(@RequestParam Long driverId, Principal principal) {
        Optional<Vendor> optionalVendor = vendorService.getVendorByEmail(principal.getName());
        if (optionalVendor.isPresent()) {
            vendorService.assignDriverToVendor(driverId, optionalVendor.get().getId());
            return "redirect:/vendor/drivers";
        }
        return "redirect:/login";
    }
    
    @PostMapping("/bulk-assign-driver")
    public String bulkAssignDriver(@RequestParam Long driverId, Principal principal, RedirectAttributes redirectAttributes) {
        Optional<Vendor> optionalVendor = vendorService.getVendorByEmail(principal.getName());
        if (optionalVendor.isPresent()) {
            Optional<Driver> optionalDriver = driverService.getDriverById(driverId);
            if (optionalDriver.isPresent()) {
                Driver driver = optionalDriver.get();
                
                // Ensure the driver belongs to this vendor
                if (driver.getVendor() != null && driver.getVendor().getId().equals(optionalVendor.get().getId())) {
                    // Get all unassigned shipments
                    List<Shipment> unassignedShipments = shipmentService.getUnassignedShipments();
                    
                    if (!unassignedShipments.isEmpty()) {
                        int count = shipmentService.assignShipmentsToDriver(driver, unassignedShipments);
                        
                        // Send WebSocket notification
                        simpMessagingTemplate.convertAndSend("/topic/driver-assignments", 
                            Map.of(
                                "driverId", driver.getId(),
                                "driverName", driver.getName(),
                                "vendorId", optionalVendor.get().getId(),
                                "shipmentCount", count,
                                "timestamp", LocalDateTime.now().toString()
                            )
                        );
                        
                        redirectAttributes.addFlashAttribute("successMessage", 
                            "Successfully assigned " + count + " shipments to driver " + driver.getName());
                    } else {
                        redirectAttributes.addFlashAttribute("infoMessage", 
                            "No unassigned shipments available for assignment");
                    }
                } else {
                    redirectAttributes.addFlashAttribute("errorMessage", 
                        "The selected driver does not belong to your vendor account");
                }
            } else {
                redirectAttributes.addFlashAttribute("errorMessage", "Driver not found");
            }
            return "redirect:/vendor/drivers";
        }
        return "redirect:/login";
    }
    
    @GetMapping("/tracking")
    public String trackShipments(Model model, Principal principal) {
        Optional<Vendor> optionalVendor = vendorService.getVendorByEmail(principal.getName());
        if (optionalVendor.isPresent()) {
            Vendor vendor = optionalVendor.get();
            List<Driver> drivers = vendorService.getDriversByVendorId(vendor.getId());
            
            List<Shipment> activeShipments = new ArrayList<>();
            for (Driver driver : drivers) {
                activeShipments.addAll(driverService.getShipmentsByDriverId(driver.getId()).stream()
                        .filter(shipment -> shipment.getStatus().toString().equals("IN_TRANSIT"))
                        .collect(Collectors.toList()));
            }
            
            model.addAttribute("shipments", activeShipments);
            return "vendor/tracking";
        }
        return "redirect:/login";
    }

    @GetMapping("/shipments")
    public String viewShipments(Model model, Principal principal) {
        Optional<Vendor> optionalVendor = vendorService.getVendorByEmail(principal.getName());
        if (optionalVendor.isPresent()) {
            Vendor vendor = optionalVendor.get();
            List<Shipment> shipments = shipmentService.getShipmentsByVendorId(vendor.getId());
            
            // Mask emails for privacy
            for (Shipment shipment : shipments) {
                // Mask shipper email
                if (shipment.getShipper() != null && shipment.getShipper().getEmail() != null) {
                    model.addAttribute("maskedShipperEmail_" + shipment.getShipper().getId(), 
                                     maskEmail(shipment.getShipper().getEmail()));
                }
                
                // Mask driver email if assigned
                if (shipment.getDriver() != null && shipment.getDriver().getEmail() != null) {
                    model.addAttribute("maskedDriverEmail_" + shipment.getDriver().getId(), 
                                     maskEmail(shipment.getDriver().getEmail()));
                }
            }
            
            model.addAttribute("shipments", shipments);
            return "vendor/shipments";
        }
        return "redirect:/login";
    }
} 