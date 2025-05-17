package com.pickngo.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;
import lombok.EqualsAndHashCode;

import javax.persistence.*;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Entity
@Table(name = "shipments")
@ToString(exclude = {"shipper", "driver"})
@EqualsAndHashCode(exclude = {"shipper", "driver"})
public class Shipment {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(unique = true)
    private String trackingNumber;
    
    @Column(nullable = false)
    private String goodsType;
    
    @Column(nullable = false)
    private Double quantity;
    
    @Column(nullable = false)
    private Double weight;
    
    @Column(nullable = false)
    private Double price;
    
    @Column(nullable = false)
    private String pickupAddress;
    
    @Column(nullable = false)
    private String deliveryAddress;
    
    private Double pickupLatitude;
    private Double pickupLongitude;
    private Double deliveryLatitude;
    private Double deliveryLongitude;
    
    @Enumerated(EnumType.STRING)
    private ShipmentStatus status;
    
    @ManyToOne
    @JoinColumn(name = "shipper_id")
    private Shipper shipper;
    
    @ManyToOne
    @JoinColumn(name = "driver_id")
    private Driver driver;
    
    @Column(updatable = false)
    private LocalDateTime createdAt;
    
    private LocalDateTime updatedAt;
    private LocalDateTime pickupTime;
    private LocalDateTime deliveryTime;
    
    @PrePersist
    protected void onCreate() {
        this.createdAt = LocalDateTime.now();
        this.status = ShipmentStatus.PENDING;
    }
    
    @PreUpdate
    protected void onUpdate() {
        this.updatedAt = LocalDateTime.now();
    }
} 