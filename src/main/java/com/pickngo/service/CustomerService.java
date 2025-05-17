package com.pickngo.service;

import com.pickngo.model.Customer;

import java.util.List;
import java.util.Optional;

public interface CustomerService {
    Customer registerCustomer(Customer customer);
    Optional<Customer> getCustomerById(Long id);
    Optional<Customer> getCustomerByEmail(String email);
    List<Customer> getAllCustomers();
    Customer updateCustomer(Customer customer);
    boolean existsByEmail(String email);
} 