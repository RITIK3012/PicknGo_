package com.pickngo.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;
import lombok.experimental.SuperBuilder;
import lombok.ToString;

import javax.persistence.Entity;
import javax.persistence.OneToMany;
import javax.persistence.Table;
import java.util.ArrayList;
import java.util.List;

@Data
@EqualsAndHashCode(callSuper = true, exclude = {"shipments"})
@ToString(exclude = {"shipments"})
@NoArgsConstructor
@AllArgsConstructor
@SuperBuilder
@Entity
@Table(name = "shippers")
public class Shipper extends User {

    private String companyName;
    private String address;
    
    @OneToMany(mappedBy = "shipper")
    private List<Shipment> shipments = new ArrayList<>();
} 