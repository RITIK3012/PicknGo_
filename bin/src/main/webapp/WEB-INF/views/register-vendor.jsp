<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<c:set var="title" value="Register as Vendor" />
<%@ include file="layout/header.jsp" %>

<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-md-8">
            <div class="card form-card">
                <div class="card-header bg-success text-white">
                    <h3 class="mb-0"><i class="fas fa-store me-2"></i> Vendor Registration</h3>
                </div>
                <div class="card-body p-4">
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger">
                            <i class="fas fa-exclamation-circle me-2"></i> ${error}
                        </div>
                    </c:if>
                
                    <form:form action="/register/vendor" method="post" modelAttribute="vendor" class="needs-validation" novalidate="true">
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
                            <div class="col-md-12 mb-3">
                                <label for="companyName" class="form-label required">Company/Business Name</label>
                                <form:input path="companyName" type="text" class="form-control" id="companyName" placeholder="Enter your company or business name" required="true" />
                                <div class="invalid-feedback">
                                    Please enter your company or business name
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="businessType" class="form-label required">Business Type</label>
                                <form:select path="businessType" class="form-select" id="businessType" required="true">
                                    <option value="">Select business type</option>
                                    <option value="RESTAURANT">Restaurant</option>
                                    <option value="GROCERY">Grocery Store</option>
                                    <option value="RETAIL">Retail Shop</option>
                                    <option value="WHOLESALE">Wholesale</option>
                                    <option value="ELECTRONICS">Electronics</option>
                                    <option value="OTHER">Other</option>
                                </form:select>
                                <div class="invalid-feedback">
                                    Please select a business type
                                </div>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="taxId" class="form-label required">Tax ID/Business License Number</label>
                                <form:input path="taxId" type="text" class="form-control" id="taxId" placeholder="Enter your tax ID or license number" required="true" />
                                <div class="invalid-feedback">
                                    Please enter your tax ID or business license number
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-12 mb-3">
                                <label for="businessAddress" class="form-label required">Business Address</label>
                                <form:textarea path="businessAddress" class="form-control" id="businessAddress" rows="3" placeholder="Enter your business address" required="true"></form:textarea>
                                <div class="invalid-feedback">
                                    Please enter your business address
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-12 mb-3">
                                <label for="description" class="form-label">Business Description</label>
                                <form:textarea path="description" class="form-control" id="description" rows="3" placeholder="Tell us about your business (optional)"></form:textarea>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="website" class="form-label">Website (Optional)</label>
                                <form:input path="website" type="url" class="form-control" id="website" placeholder="Enter your website URL" />
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="operatingHours" class="form-label required">Operating Hours</label>
                                <form:input path="operatingHours" type="text" class="form-control" id="operatingHours" placeholder="e.g., Mon-Fri: 9am-5pm" required="true" />
                                <div class="invalid-feedback">
                                    Please enter your operating hours
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
                            <button type="submit" class="btn btn-success btn-lg">
                                <i class="fas fa-user-plus me-2"></i> Register as Vendor
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
                
                <h6>3. Vendor Responsibilities</h6>
                <p>Vendors are responsible for the accuracy of their product information and maintaining their availability status.</p>
                
                <h6>4. Payments</h6>
                <p>All payment transactions are processed securely through our platform. Vendor payouts will be processed according to our payment schedule.</p>
                
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