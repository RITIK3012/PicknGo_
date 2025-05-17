package com.pickngo.service;

import com.pickngo.model.Admin;

import java.util.List;
import java.util.Optional;

public interface AdminService {
    List<Admin> getAllAdmins();
    Optional<Admin> getAdminById(Long id);
    Optional<Admin> getAdminByEmail(String email);
    Admin registerAdmin(Admin admin);
    Admin updateAdmin(Admin admin);
    void deleteAdmin(Long id);
    boolean existsByEmail(String email);
} 