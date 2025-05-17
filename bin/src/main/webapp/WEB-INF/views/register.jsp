<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="title" value="Register" />
<%@ include file="layout/header.jsp" %>

<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-md-10">
            <div class="card">
                <div class="card-header bg-primary text-white">
                    <h3 class="mb-0 text-center"><i class="fas fa-user-plus me-2"></i> Register for PicknGo</h3>
                </div>
                <div class="card-body p-4">
                    <p class="lead text-center mb-4">Choose your role to get started with PicknGo</p>
                    
                    <div class="row g-4">
                        <div class="col-md-3">
                            <div class="card h-100 feature-card text-center p-4">
                                <div class="feature-icon mx-auto mb-3">
                                    <i class="fas fa-box"></i>
                                </div>
                                <h5 class="card-title">Shipper</h5>
                                <p class="card-text">Register as a shipper to transport your goods from one place to another.</p>
                                <ul class="list-unstyled text-start small mb-4">
                                    <li><i class="fas fa-check text-success me-2"></i> Create shipments</li>
                                    <li><i class="fas fa-check text-success me-2"></i> Track in real-time</li>
                                    <li><i class="fas fa-check text-success me-2"></i> View delivery history</li>
                                </ul>
                                <a href="/register/shipper" class="btn btn-primary mt-auto">
                                    Register as Shipper
                                </a>
                            </div>
                        </div>
                        
                        <div class="col-md-3">
                            <div class="card h-100 feature-card text-center p-4">
                                <div class="feature-icon mx-auto mb-3">
                                    <i class="fas fa-truck"></i>
                                </div>
                                <h5 class="card-title">Driver</h5>
                                <p class="card-text">Register as a driver to transport goods and earn money.</p>
                                <ul class="list-unstyled text-start small mb-4">
                                    <li><i class="fas fa-check text-success me-2"></i> Find shipment jobs</li>
                                    <li><i class="fas fa-check text-success me-2"></i> Manage your vehicles</li>
                                    <li><i class="fas fa-check text-success me-2"></i> Track earnings</li>
                                </ul>
                                <a href="/register/driver" class="btn btn-primary mt-auto">
                                    Register as Driver
                                </a>
                            </div>
                        </div>
                        
                        <div class="col-md-3">
                            <div class="card h-100 feature-card text-center p-4">
                                <div class="feature-icon mx-auto mb-3">
                                    <i class="fas fa-building"></i>
                                </div>
                                <h5 class="card-title">Vendor</h5>
                                <p class="card-text">Register as a vendor to manage multiple drivers and vehicles.</p>
                                <ul class="list-unstyled text-start small mb-4">
                                    <li><i class="fas fa-check text-success me-2"></i> Manage multiple drivers</li>
                                    <li><i class="fas fa-check text-success me-2"></i> Track all shipments</li>
                                    <li><i class="fas fa-check text-success me-2"></i> Business analytics</li>
                                </ul>
                                <a href="/register/vendor" class="btn btn-primary mt-auto">
                                    Register as Vendor
                                </a>
                            </div>
                        </div>
                        
                        <div class="col-md-3">
                            <div class="card h-100 feature-card text-center p-4">
                                <div class="feature-icon mx-auto mb-3">
                                    <i class="fas fa-user"></i>
                                </div>
                                <h5 class="card-title">Customer</h5>
                                <p class="card-text">Register as a customer to order products and get them delivered.</p>
                                <ul class="list-unstyled text-start small mb-4">
                                    <li><i class="fas fa-check text-success me-2"></i> Order products</li>
                                    <li><i class="fas fa-check text-success me-2"></i> Track your orders</li>
                                    <li><i class="fas fa-check text-success me-2"></i> Quick checkout</li>
                                </ul>
                                <a href="/register/customer" class="btn btn-primary mt-auto">
                                    Register as Customer
                                </a>
                            </div>
                        </div>
                    </div>
                    
                    <div class="text-center mt-4">
                        <p>Already have an account? <a href="/login">Login Now</a></p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="layout/footer.jsp" %> 