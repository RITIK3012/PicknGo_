package com.pickngo.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;
import lombok.experimental.SuperBuilder;
import lombok.ToString;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.List;

@Data
@EqualsAndHashCode(callSuper = true)
@NoArgsConstructor
@AllArgsConstructor
@SuperBuilder
@Entity
@Table(name = "drivers")
public class Driver extends User {

    @Column(nullable = false)
    private String licenseNumber;

    private String bankAccountNumber;
    private String bankName;
    private String ifscCode;
    
    private String kycVideoUrl;
    
    @Column
    private String address;
    
    @Column(nullable = false)
    private boolean verified = false;
    
    @ManyToOne
    @JoinColumn(name = "vendor_id")
    @ToString.Exclude
    private Vendor vendor;
    
    @OneToMany(mappedBy = "driver")
    @ToString.Exclude
    private List<Vehicle> vehicles = new ArrayList<>();
    
    @OneToMany(mappedBy = "driver")
    @ToString.Exclude
    private List<Shipment> shipments = new ArrayList<>();
} 