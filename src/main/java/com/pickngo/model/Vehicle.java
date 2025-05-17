package com.pickngo.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.Builder;
import lombok.ToString;

import javax.persistence.*;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Entity
@Table(name = "vehicles")
public class Vehicle {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(nullable = false)
    private String vehicleNumber;
    
    @Column(nullable = false)
    private String vehicleType;
    
    @Column(nullable = false)
    private Double loadCapacity;
    
    private String model;
    private String make;
    private Integer year;
    
    @ManyToOne
    @JoinColumn(name = "driver_id")
    @ToString.Exclude
    private Driver driver;
    
    @Column(nullable = false)
    private boolean active = true;
    
    @Column(updatable = false)
    private LocalDateTime createdAt;
    
    private LocalDateTime updatedAt;
    
    @PrePersist
    protected void onCreate() {
        this.createdAt = LocalDateTime.now();
    }
    
    @PreUpdate
    protected void onUpdate() {
        this.updatedAt = LocalDateTime.now();
    }
} 