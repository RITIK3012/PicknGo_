<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<c:set var="title" value="Register as Customer" />
<%@ include file="layout/header.jsp" %>

<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-md-8">
            <div class="card form-card">
                <div class="card-header bg-primary text-white">
                    <h3 class="mb-0"><i class="fas fa-user me-2"></i> Customer Registration</h3>
                </div>
                <div class="card-body p-4">
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger">
                            <i class="fas fa-exclamation-circle me-2"></i> ${error}
                        </div>
                    </c:if>
                
                    <form:form action="/register/customer" method="post" modelAttribute="customer" class="needs-validation" novalidate="true">
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="firstName" class="form-label required">First Name</label>
                                <form:input path="firstName" type="text" class="form-control" id="firstName" placeholder="Enter your first name" required="true" />
                                <div class="invalid-feedback">
                                    Please enter your first name
                                </div>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="lastName" class="form-label required">Last Name</label>
                                <form:input path="lastName" type="text" class="form-control" id="lastName" placeholder="Enter your last name" required="true" />
                                <div class="invalid-feedback">
                                    Please enter your last name
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-12 mb-3">
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
                                <label for="confirmPassword" class="form-label required">Confirm Password</label>
                                <form:password path="confirmPassword" class="form-control" id="confirmPassword" placeholder="Confirm your password" required="true" />
                                <div class="invalid-feedback">
                                    Passwords do not match
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="phoneNumber" class="form-label required">Phone Number</label>
                                <form:input path="phoneNumber" type="tel" class="form-control" id="phoneNumber" placeholder="Enter your phone number" required="true" />
                                <div class="invalid-feedback">
                                    Please enter your phone number
                                </div>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="dateOfBirth" class="form-label required">Date of Birth</label>
                                <form:input path="dateOfBirth" type="date" class="form-control" id="dateOfBirth" required="true" />
                                <div class="invalid-feedback">
                                    Please enter your date of birth
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-12 mb-3">
                                <label for="address" class="form-label required">Full Address</label>
                                <form:textarea path="address" class="form-control" id="address" rows="3" placeholder="Enter your full address" required="true"></form:textarea>
                                <div class="invalid-feedback">
                                    Please enter your address
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="city" class="form-label required">City</label>
                                <form:input path="city" type="text" class="form-control" id="city" placeholder="Enter your city" required="true" />
                                <div class="invalid-feedback">
                                    Please enter your city
                                </div>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="postalCode" class="form-label required">Postal Code</label>
                                <form:input path="postalCode" type="text" class="form-control" id="postalCode" placeholder="Enter your postal code" required="true" />
                                <div class="invalid-feedback">
                                    Please enter your postal code
                                </div>
                            </div>
                        </div>

                        <div class="form-check mb-3">
                            <input class="form-check-input" type="checkbox" id="marketing" name="marketing">
                            <label class="form-check-label" for="marketing">
                                I would like to receive marketing communications and special offers
                            </label>
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
                                <i class="fas fa-user-plus me-2"></i> Register as Customer
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
                
                <h6>3. Orders and Deliveries</h6>
                <p>All orders are subject to availability of products. Delivery times are estimates and may vary based on factors beyond our control.</p>
                
                <h6>4. Payments</h6>
                <p>All payment transactions are processed securely through our platform. We accept various payment methods as specified in the application.</p>
                
                <h6>5. Privacy Policy</h6>
                <p>We collect and process your personal data in accordance with our Privacy Policy.</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" data-bs-dismiss="modal">I Understand</button>
            </div>
        </div>
    </div>
</div>

<script>
    // Password visibility toggle
    document.querySelectorAll('.password-toggle').forEach(button => {
        button.addEventListener('click', () => {
            const input = button.previousElementSibling;
            const icon = button.querySelector('i');
            
            if (input.type === 'password') {
                input.type = 'text';
                icon.classList.remove('fa-eye');
                icon.classList.add('fa-eye-slash');
            } else {
                input.type = 'password';
                icon.classList.remove('fa-eye-slash');
                icon.classList.add('fa-eye');
            }
        });
    });
    
    // Password match validation
    const password = document.getElementById('password');
    const confirmPassword = document.getElementById('confirmPassword');
    
    function validatePassword() {
        if (password.value != confirmPassword.value) {
            confirmPassword.setCustomValidity("Passwords don't match");
        } else {
            confirmPassword.setCustomValidity('');
        }
    }
    
    password.addEventListener('change', validatePassword);
    confirmPassword.addEventListener('keyup', validatePassword);
    
    // Form validation
    (function() {
        'use strict';
        
        const forms = document.querySelectorAll('.needs-validation');
        
        Array.from(forms).forEach(form => {
            form.addEventListener('submit', event => {
                if (!form.checkValidity()) {
                    event.preventDefault();
                    event.stopPropagation();
                }
                
                form.classList.add('was-validated');
            }, false);
        });
    })();
</script>

<%@ include file="layout/footer.jsp" %> 