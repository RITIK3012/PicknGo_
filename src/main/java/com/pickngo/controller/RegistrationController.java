package com.pickngo.controller;

import com.pickngo.model.Customer;
import com.pickngo.model.Driver;
import com.pickngo.model.Shipper;
import com.pickngo.model.Vendor;
import com.pickngo.service.CustomerService;
import com.pickngo.service.DriverService;
import com.pickngo.service.ShipperService;
import com.pickngo.service.VendorService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/register")
public class RegistrationController {

    private final ShipperService shipperService;
    private final DriverService driverService;
    private final VendorService vendorService;
    private final CustomerService customerService;

    @Autowired
    public RegistrationController(ShipperService shipperService, DriverService driverService, VendorService vendorService, CustomerService customerService) {
        this.shipperService = shipperService;
        this.driverService = driverService;
        this.vendorService = vendorService;
        this.customerService = customerService;
    }

    @GetMapping
    public String showRegistrationPage() {
        return "register";
    }
    
    @GetMapping("/shipper")
    public String showShipperRegistrationForm(Model model) {
        model.addAttribute("shipper", new Shipper());
        return "register-shipper";
    }
    
    @PostMapping("/shipper")
    public String registerShipper(@ModelAttribute Shipper shipper, RedirectAttributes redirectAttributes) {
        if (shipperService.existsByEmail(shipper.getEmail())) {
            redirectAttributes.addFlashAttribute("error", "Email already in use");
            return "redirect:/register/shipper";
        }
        
        shipperService.registerShipper(shipper);
        redirectAttributes.addFlashAttribute("success", "Registration successful. Please login.");
        return "redirect:/login";
    }
    
    @GetMapping("/driver")
    public String showDriverRegistrationForm(Model model) {
        model.addAttribute("driver", new Driver());
        return "register-driver";
    }
    
    @PostMapping("/driver")
    public String registerDriver(@ModelAttribute Driver driver, RedirectAttributes redirectAttributes) {
        if (driverService.existsByEmail(driver.getEmail())) {
            redirectAttributes.addFlashAttribute("error", "Email already in use");
            return "redirect:/register/driver";
        }
        
        driverService.registerDriver(driver);
        redirectAttributes.addFlashAttribute("success", "Registration successful. Please login and complete your KYC verification.");
        return "redirect:/login";
    }
    
    @GetMapping("/vendor")
    public String showVendorRegistrationForm(Model model) {
        model.addAttribute("vendor", new Vendor());
        return "register-vendor";
    }
    
    @PostMapping("/vendor")
    public String registerVendor(@ModelAttribute Vendor vendor, RedirectAttributes redirectAttributes) {
        if (vendorService.existsByEmail(vendor.getEmail())) {
            redirectAttributes.addFlashAttribute("error", "Email already in use");
            return "redirect:/register/vendor";
        }
        
        vendorService.registerVendor(vendor);
        redirectAttributes.addFlashAttribute("success", "Registration successful. Please login.");
        return "redirect:/login";
    }

    @GetMapping("/customer")
    public String showCustomerRegistrationForm(Model model) {
        model.addAttribute("customer", new Customer());
        return "register-customer";
    }
    
    @PostMapping("/customer")
    public String registerCustomer(@ModelAttribute Customer customer, RedirectAttributes redirectAttributes) {
        if (customerService.existsByEmail(customer.getEmail())) {
            redirectAttributes.addFlashAttribute("error", "Email already in use");
            return "redirect:/register/customer";
        }
        
        customerService.registerCustomer(customer);
        redirectAttributes.addFlashAttribute("success", "Registration successful. Please login.");
        return "redirect:/login";
    }
} 