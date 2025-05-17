<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<c:set var="title" value="Register as Driver" />
<%@ include file="layout/header.jsp" %>

<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-md-8">
            <div class="card form-card">
                <div class="card-header bg-primary text-white">
                    <h3 class="mb-0"><i class="fas fa-truck me-2"></i> Driver Registration</h3>
                </div>
                <div class="card-body p-4">
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger">
                            <i class="fas fa-exclamation-circle me-2"></i> ${error}
                        </div>
                    </c:if>
                
                    <form:form action="/register/driver" method="post" modelAttribute="driver" class="needs-validation" novalidate="true">
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
                                <form:password path="password" class="form-control" id="password" placeholder="Create a password" required="true" />
                                <div class="invalid-feedback">
                                    Please create a password
                                </div>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="confirmPassword" class="form-label required">Confirm Password</label>
                                <input type="password" class="form-control" id="confirmPassword" placeholder="Confirm your password" required>
                                <div class="invalid-feedback">
                                    Please confirm your password
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="contactNumber" class="form-label required">Contact Number</label>
                                <form:input path="contactNumber" type="tel" class="form-control" id="contactNumber" placeholder="Enter your contact number" required="true" />
                                <div class="invalid-feedback">
                                    Please enter a valid contact number
                                </div>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="licenseNumber" class="form-label required">Driver License Number</label>
                                <form:input path="licenseNumber" type="text" class="form-control" id="licenseNumber" placeholder="Enter your license number" required="true" />
                                <div class="invalid-feedback">
                                    Please enter your license number
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-12 mb-3">
                                <label for="address" class="form-label required">Address</label>
                                <form:textarea path="address" class="form-control" id="address" rows="3" placeholder="Enter your address" required="true"></form:textarea>
                                <div class="invalid-feedback">
                                    Please enter your address
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-4 mb-3">
                                <label for="bankName" class="form-label">Bank Name</label>
                                <form:input path="bankName" type="text" class="form-control" id="bankName" placeholder="Enter bank name" />
                            </div>
                            <div class="col-md-4 mb-3">
                                <label for="bankAccountNumber" class="form-label">Bank Account Number</label>
                                <form:input path="bankAccountNumber" type="text" class="form-control" id="bankAccountNumber" placeholder="Enter account number" />
                            </div>
                            <div class="col-md-4 mb-3">
                                <label for="ifscCode" class="form-label">IFSC Code</label>
                                <form:input path="ifscCode" type="text" class="form-control" id="ifscCode" placeholder="Enter IFSC code" />
                            </div>
                        </div>

                        <h5 class="my-4">Vehicle Information</h5>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="vehicles[0].vehicleNumber" class="form-label required">Vehicle Registration Number</label>
                                <input name="vehicles[0].vehicleNumber" type="text" class="form-control" placeholder="Enter registration number" required />
                                <div class="invalid-feedback">
                                    Please enter the vehicle registration number
                                </div>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="vehicles[0].vehicleType" class="form-label required">Vehicle Type</label>
                                <select name="vehicles[0].vehicleType" class="form-select" required>
                                    <option value="">Select vehicle type</option>
                                    <option value="TRUCK">Truck</option>
                                    <option value="VAN">Van</option>
                                    <option value="PICKUP">Pickup</option>
                                    <option value="CAR">Car</option>
                                </select>
                                <div class="invalid-feedback">
                                    Please select a vehicle type
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-4 mb-3">
                                <label for="vehicles[0].model" class="form-label">Vehicle Model</label>
                                <input name="vehicles[0].model" type="text" class="form-control" placeholder="Enter vehicle model" />
                            </div>
                            <div class="col-md-4 mb-3">
                                <label for="vehicles[0].make" class="form-label">Vehicle Make</label>
                                <input name="vehicles[0].make" type="text" class="form-control" placeholder="Enter vehicle make" />
                            </div>
                            <div class="col-md-4 mb-3">
                                <label for="vehicles[0].year" class="form-label">Year</label>
                                <input name="vehicles[0].year" type="number" class="form-control" placeholder="Enter vehicle year" />
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="vehicles[0].loadCapacity" class="form-label required">Load Capacity (kg)</label>
                                <input name="vehicles[0].loadCapacity" type="number" step="0.01" class="form-control" placeholder="Enter capacity in kg" required />
                                <div class="invalid-feedback">
                                    Please enter the vehicle load capacity
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
                        
                        <button type="submit" class="btn btn-primary btn-lg w-100">Register</button>
                    </form:form>
                    
                    <div class="text-center mt-4">
                        <p>Already have an account? <a href="/login">Login Now</a></p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Terms and Conditions Modal -->
<div class="modal fade" id="termsModal" tabindex="-1" aria-labelledby="termsModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="termsModalLabel">Terms and Conditions for Drivers</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <h6>1. General Terms</h6>
                <p>
                    By registering as a driver on the PicknGo platform, you agree to adhere to all applicable laws, regulations, and the terms set forth in this agreement. PicknGo reserves the right to modify these terms at any time, with notification to all registered drivers.
                </p>
                
                <h6>2. Driver Responsibilities</h6>
                <p>
                    As a registered driver, you agree to:
                </p>
                <ul>
                    <li>Maintain a valid driver's license and all required permits</li>
                    <li>Keep your vehicle in good working condition</li>
                    <li>Maintain appropriate insurance coverage</li>
                    <li>Complete KYC verification as required by PicknGo</li>
                    <li>Handle all shipments with care and professionalism</li>
                    <li>Follow delivery instructions provided by shippers and the platform</li>
                </ul>
                
                <h6>3. Payment Processing</h6>
                <p>
                    Payments will be processed according to the following terms:
                </p>
                <ul>
                    <li>Payments will be transferred to your registered bank account</li>
                    <li>Payment cycles are typically weekly, subject to change</li>
                    <li>All applicable taxes and platform fees will be deducted as required by law</li>
                    <li>You are responsible for reporting income and paying taxes as required by local regulations</li>
                </ul>
                
                <h6>4. Privacy Policy</h6>
                <p>
                    Your personal information will be collected and processed in accordance with our Privacy Policy. This includes sharing necessary information with shippers, vendors, and customers to facilitate deliveries.
                </p>
                
                <h6>5. Termination</h6>
                <p>
                    PicknGo reserves the right to terminate your driver account for violations of these terms, consistently poor service, or any illegal activities. You may also terminate your account at any time by contacting customer support.
                </p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>

<script>
// Form validation
(function () {
    'use strict'
    var forms = document.querySelectorAll('.needs-validation')
    Array.prototype.slice.call(forms)
        .forEach(function (form) {
            form.addEventListener('submit', function (event) {
                if (!form.checkValidity()) {
                    event.preventDefault()
                    event.stopPropagation()
                }
                
                // Check if passwords match
                var password = document.getElementById('password')
                var confirmPassword = document.getElementById('confirmPassword')
                if (password.value !== confirmPassword.value) {
                    confirmPassword.setCustomValidity('Passwords do not match')
                    event.preventDefault()
                    event.stopPropagation()
                } else {
                    confirmPassword.setCustomValidity('')
                }
                
                form.classList.add('was-validated')
            }, false)
        })
})()
</script>

<%@ include file="layout/footer.jsp" %> 