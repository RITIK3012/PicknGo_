package com.pickngo.repository;

import com.pickngo.model.Driver;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface DriverRepository extends JpaRepository<Driver, Long> {
    Optional<Driver> findByEmail(String email);
    boolean existsByEmail(String email);
    List<Driver> findByVendorId(Long vendorId);
    List<Driver> findByVerifiedTrue();
} 