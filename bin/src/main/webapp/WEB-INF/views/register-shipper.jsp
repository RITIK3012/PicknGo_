<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<c:set var="title" value="Register as Shipper" />
<%@ include file="layout/header.jsp" %>

<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-md-8">
            <div class="card form-card">
                <div class="card-header bg-primary text-white">
                    <h3 class="mb-0"><i class="fas fa-box me-2"></i> Shipper Registration</h3>
                </div>
                <div class="card-body p-4">
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger">
                            <i class="fas fa-exclamation-circle me-2"></i> ${error}
                        </div>
                    </c:if>
                
                    <form:form action="/register/shipper" method="post" modelAttribute="shipper" class="needs-validation" novalidate="true">
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="name" class="form-label required">Full Name</label>
                                <form:input path="name" type="text" class="form-control" id="name" placeholder="Enter your full name" required="true" />
                                <div class="invalid-feedback">
                                    Please enter your full name
                                </div>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="email" class="form-label required">Email Address</label>
                                <form:input path="email" type="email" class="form-control" id="email" placeholder="Enter your email address" required="true" />
                                <div class="invalid-feedback">
                                    Please enter a valid email address
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="password" class="form-label required">Password</label>
                                <div class="input-group">
                                    <form:password path="password" class="form-control" id="password" placeholder="Enter your password" required="true" />
                                    <button class="btn btn-outline-secondary password-toggle" type="button">
                                        <i class="fas fa-eye"></i>
                                    </button>
                                </div>
                                <div class="invalid-feedback">
                                    Please enter a password
                                </div>
                                <small class="form-text text-muted">
                                    Password must be at least 8 characters long
                                </small>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="contactNumber" class="form-label required">Contact Number</label>
                                <form:input path="contactNumber" type="tel" class="form-control" id="contactNumber" placeholder="Enter your contact number" required="true" />
                                <div class="invalid-feedback">
                                    Please enter your contact number
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="companyName" class="form-label">Company Name</label>
                                <form:input path="companyName" type="text" class="form-control" id="companyName" placeholder="Enter your company name (if applicable)" />
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="address" class="form-label required">Address</label>
                                <form:textarea path="address" class="form-control" id="address" rows="3" placeholder="Enter your address" required="true"></form:textarea>
                                <div class="invalid-feedback">
                                    Please enter your address
                                </div>
                            </div>
                        </div>

                        <div class="form-check mb-3">
                            <input class="form-check-input" type="checkbox" id="terms" required>
                            <label class="form-check-label" for="terms">
                                I agree to the <a href="#" data-bs-toggle="modal" data-bs-target="#termsModal">Terms and Conditions</a>
                            </label>
                            <div class="invalid-feedback">
                                You must agree to the terms and conditions
                            </div>
                        </div>

                        <div class="d-grid gap-2">
                            <button type="submit" class="btn btn-primary btn-lg">
                                <i class="fas fa-user-plus me-2"></i> Register as Shipper
                            </button>
                        </div>
                    </form:form>
                    
                    <div class="text-center mt-4">
                        <p>Already have an account? <a href="/login">Login Now</a></p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Terms Modal -->
<div class="modal fade" id="termsModal" tabindex="-1" aria-labelledby="termsModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="termsModalLabel">Terms and Conditions</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <h6>1. Acceptance of Terms</h6>
                <p>By accessing and using PicknGo, you agree to be bound by these Terms and Conditions.</p>
                
                <h6>2. User Accounts</h6>
                <p>You are responsible for maintaining the confidentiality of your account information and password.</p>
                
                <h6>3. Shipping Policies</h6>
                <p>Shippers are responsible for providing accurate information about the goods being transported.</p>
                
                <h6>4. Payments</h6>
                <p>All payment transactions are processed securely through our platform.</p>
                
                <h6>5. Privacy Policy</h6>
                <p>We collect and process your personal data in accordance with our Privacy Policy.</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" data-bs-dismiss="modal">I Understand</button>
            </div>
        </div>
    </div>
</div>

<%@ include file="layout/footer.jsp" %> 