package com.pickngo.controller;

import com.pickngo.config.CustomUserDetails;
import com.pickngo.model.*;
import com.pickngo.service.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/admin")
public class AdminController {

    private final ShipperService shipperService;
    private final DriverService driverService;
    private final VendorService vendorService;
    private final ShipmentService shipmentService;
    private final DriverInterestService driverInterestService;
    private final AdminService adminService;

    @Autowired
    public AdminController(ShipperService shipperService, DriverService driverService,
                           VendorService vendorService, ShipmentService shipmentService,
                           DriverInterestService driverInterestService, AdminService adminService) {
        this.shipperService = shipperService;
        this.driverService = driverService;
        this.vendorService = vendorService;
        this.shipmentService = shipmentService;
        this.driverInterestService = driverInterestService;
        this.adminService = adminService;
    }
    
    @GetMapping("")
    public String redirectToDashboard() {
        return "redirect:/admin/dashboard";
    }

    @GetMapping("/dashboard")
    public String adminDashboard(Model model) {
        // Get all data without requiring authentication
        List<Shipper> shippers = shipperService.getAllShippers();
        List<Driver> drivers = driverService.getAllDrivers();
        List<Vendor> vendors = vendorService.getAllVendors();
        List<Shipment> shipments = shipmentService.getAllShipments();
        
        // Get shipments with driver interests
        Map<Long, List<DriverInterest>> shipmentInterestsMap = new HashMap<>();
        for (Shipment shipment : shipments) {
            if (shipment.getStatus() == ShipmentStatus.INTEREST_SHOWN) {
                List<DriverInterest> interests = driverInterestService.getInterestsByShipmentId(shipment.getId());
                if (!interests.isEmpty()) {
                    shipmentInterestsMap.put(shipment.getId(), interests);
                }
            }
        }
        
        model.addAttribute("shippers", shippers);
        model.addAttribute("drivers", drivers);
        model.addAttribute("vendors", vendors);
        model.addAttribute("shipments", shipments);
        model.addAttribute("shipmentInterestsMap", shipmentInterestsMap);
        
        return "admin/dashboard";
    }
    
    @GetMapping("/shippers")
    public String viewShippers(Model model) {
        model.addAttribute("shippers", shipperService.getAllShippers());
        return "admin/shippers";
    }
    
    @GetMapping("/drivers")
    public String viewDrivers(Model model) {
        model.addAttribute("drivers", driverService.getAllDrivers());
        return "admin/drivers";
    }
    
    @GetMapping("/vendors")
    public String viewVendors(Model model) {
        model.addAttribute("vendors", vendorService.getAllVendors());
        return "admin/vendors";
    }
    
    @GetMapping("/shipments")
    public String viewShipments(Model model) {
        List<Shipment> shipments = shipmentService.getAllShipments();
        List<Driver> verifiedDrivers = driverService.getVerifiedDrivers();
        
        // Get shipments with driver interests
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
        model.addAttribute("drivers", verifiedDrivers);
        model.addAttribute("shipmentInterestsMap", shipmentInterestsMap);
        return "admin/shipments";
    }
    
    @GetMapping("/pending-kyc")
    public String viewPendingKYC(Model model) {
        // Get all drivers who have uploaded KYC but are not verified yet
        List<Driver> driversWithPendingKYC = driverService.getAllDrivers().stream()
                .filter(driver -> driver.getKycVideoUrl() != null && !driver.isVerified())
                .collect(Collectors.toList());
        
        model.addAttribute("drivers", driversWithPendingKYC);
        return "admin/pending-kyc";
    }
    
    @PostMapping("/verify-driver/{id}")
    public String verifyDriver(@PathVariable Long id) {
        driverService.verifyDriver(id);
        return "redirect:/admin/pending-kyc";
    }
    
    @GetMapping("/tracking/{id}")
    public String trackShipment(@PathVariable Long id, Model model) {
        Optional<Shipment> optionalShipment = shipmentService.getShipmentById(id);
        
        if (optionalShipment.isPresent()) {
            Shipment shipment = optionalShipment.get();
            model.addAttribute("shipment", shipment);
            model.addAttribute("latestLocation", shipmentService.getLatestLocationByShipmentId(id).orElse(null));
            return "admin/tracking";
        }
        
        return "redirect:/admin/shipments";
    }
    
    @PostMapping("/assign-driver")
    @ResponseBody
    public ResponseEntity<?> assignDriver(@RequestParam Long shipmentId, @RequestParam Long driverId) {
        Shipment updatedShipment = shipmentService.assignDriverToShipment(shipmentId, driverId);
        
        if (updatedShipment != null) {
            Map<String, Object> response = new HashMap<>();
            response.put("status", "success");
            response.put("message", "Driver assigned successfully");
            return ResponseEntity.ok(response);
        } else {
            Map<String, Object> response = new HashMap<>();
            response.put("status", "error");
            response.put("message", "Failed to assign driver");
            return ResponseEntity.badRequest().body(response);
        }
    }
    
    @PostMapping("/toggle-account/{type}/{id}")
    public String toggleAccountStatus(@PathVariable String type, @PathVariable Long id) {
        switch (type) {
            case "shipper":
                shipperService.getShipperById(id).ifPresent(shipper -> {
                    shipper.setActive(!shipper.isActive());
                    shipperService.updateShipper(shipper);
                });
                return "redirect:/admin/shippers";
            case "driver":
                driverService.getDriverById(id).ifPresent(driver -> {
                    driver.setActive(!driver.isActive());
                    driverService.updateDriver(driver);
                });
                return "redirect:/admin/drivers";
            case "vendor":
                vendorService.getVendorById(id).ifPresent(vendor -> {
                    vendor.setActive(!vendor.isActive());
                    vendorService.updateVendor(vendor);
                });
                return "redirect:/admin/vendors";
            default:
                return "redirect:/admin/dashboard";
        }
    }
} 