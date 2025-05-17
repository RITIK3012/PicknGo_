package com.pickngo.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;
import lombok.experimental.SuperBuilder;

import javax.persistence.Entity;
import javax.persistence.OneToMany;
import javax.persistence.Table;
import javax.persistence.Column;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import java.util.ArrayList;
import java.util.List;

@Data
@EqualsAndHashCode(callSuper = true)
@NoArgsConstructor
@AllArgsConstructor
@SuperBuilder
@Entity
@Table(name = "vendors")
public class Vendor extends User {

    private String companyName;
    private String businessRegistrationNumber;
    
    @Enumerated(EnumType.STRING)
    private BusinessType businessType;
    
    private String taxId;
    
    @Column(columnDefinition = "TEXT")
    private String businessAddress;
    
    @Column(columnDefinition = "TEXT")
    private String description;
    
    private String website;
    
    private String operatingHours;
    
    private String address;
    
    @OneToMany(mappedBy = "vendor")
    private List<Driver> drivers = new ArrayList<>();
} 