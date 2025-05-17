<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PicknGo - Register as Shipper</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary-color: #4361ee;
            --secondary-color: #3f37c9;
            --accent-color: #4cc9f0;
            --light-color: #f8f9fa;
            --dark-color: #212529;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background-image: url('https://api.placeholder.com/1920/1080');
            background-attachment: fixed;
            background-size: cover;
            background-position: center;
            position: relative;
            color: var(--dark-color);
        }

        body::before {
            content: "";
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(135deg, rgba(255, 255, 255, 0.7), rgba(255, 255, 255, 0.3));
            backdrop-filter: blur(5px);
            z-index: -1;
        }

        /* Glassmorphic Card */
        .glass-card {
            background: rgba(255, 255, 255, 0.25);
            backdrop-filter: blur(10px);
            -webkit-backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.18);
            border-radius: 12px;
            box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.15);
            transition: all 0.3s ease;
        }

        .glass-card:hover {
            box-shadow: 0 12px 48px 0 rgba(31, 38, 135, 0.25);
        }

        .glass-card-header {
            background: rgba(67, 97, 238, 0.4);
            backdrop-filter: blur(10px);
            -webkit-backdrop-filter: blur(10px);
            border-bottom: 1px solid rgba(255, 255, 255, 0.18);
            border-radius: 12px 12px 0 0;
            padding: 1.25rem;
            color: white;
        }

        .navbar {
            background: rgba(255, 255, 255, 0.2);
            backdrop-filter: blur(10px);
            -webkit-backdrop-filter: blur(10px);
            border-bottom: 1px solid rgba(255, 255, 255, 0.18);
        }

        .btn-glass {
            background: rgba(67, 97, 238, 0.4);
            backdrop-filter: blur(5px);
            -webkit-backdrop-filter: blur(5px);
            border: 1px solid rgba(255, 255, 255, 0.18);
            color: white;
            transition: all 0.3s ease;
        }

        .btn-glass:hover {
            background: rgba(67, 97, 238, 0.6);
            color: white;
        }

        .btn-glass-light {
            background: rgba(255, 255, 255, 0.25);
            backdrop-filter: blur(5px);
            -webkit-backdrop-filter: blur(5px);
            border: 1px solid rgba(255, 255, 255, 0.18);
            color: var(--dark-color);
            transition: all 0.3s ease;
        }

        .btn-glass-light:hover {
            background: rgba(255, 255, 255, 0.4);
        }

        .form-control, .form-select {
            background: rgba(255, 255, 255, 0.2);
            border: 1px solid rgba(255, 255, 255, 0.3);
            backdrop-filter: blur(5px);
            -webkit-backdrop-filter: blur(5px);
            transition: all 0.3s ease;
        }

        .form-control:focus, .form-select:focus {
            background: rgba(255, 255, 255, 0.3);
            border-color: rgba(67, 97, 238, 0.5);
            box-shadow: 0 0 0 0.25rem rgba(67, 97, 238, 0.25);
        }

        .form-label {
            font-weight: 500;
            color: var(--dark-color);
        }

        .form-label.required::after {
            content: "*";
            color: #dc3545;
            margin-left: 4px;
        }

        .input-group-text {
            background: rgba(255, 255, 255, 0.2);
            border: 1px solid rgba(255, 255, 255, 0.3);
        }

        /* Modal styling */
        .modal-content {
            background: rgba(255, 255, 255, 0.25);
            backdrop-filter: blur(10px);
            -webkit-backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.18);
            border-radius: 12px;
            box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.15);
        }

        .modal-header {
            border-bottom: 1px solid rgba(255, 255, 255, 0.18);
        }

        .modal-footer {
            border-top: 1px solid rgba(255, 255, 255, 0.18);
        }

        /* Form icon styling */
        .input-icon {
            position: absolute;
            top: 50%;
            right: 12px;
            transform: translateY(-50%);
            color: var(--primary-color);
            opacity: 0.7;
        }

        /* Alert styling */
        .alert-glass {
            background: rgba(220, 53, 69, 0.15);
            backdrop-filter: blur(10px);
            -webkit-backdrop-filter: blur(10px);
            border: 1px solid rgba(220, 53, 69, 0.3);
            color: #842029;
        }

        /* Floating elements */
        .floating-shape {
            position: absolute;
            border-radius: 50%;
            opacity: 0.05;
            filter: blur(40px);
            z-index: -1;
        }

        .shape-1 {
            width: 300px;
            height: 300px;
            background: var(--primary-color);
            top: -100px;
            right: 10%;
            animation: float 15s ease-in-out infinite;
        }

        .shape-2 {
            width: 200px;
            height: 200px;
            background: var(--accent-color);
            bottom: 10%;
            left: 5%;
            animation: float 20s ease-in-out infinite reverse;
        }

        @keyframes float {
            0%, 100% { transform: translate(0, 0) rotate(0deg); }
            25% { transform: translate(20px, -20px) rotate(5deg); }
            50% { transform: translate(0, 20px) rotate(0deg); }
            75% { transform: translate(-20px, -20px) rotate(-5deg); }
        }

        footer {
            background: rgba(33, 37, 41, 0.7);
            backdrop-filter: blur(10px);
            -webkit-backdrop-filter: blur(10px);
            border-top: 1px solid rgba(255, 255, 255, 0.1);
        }
    </style>
</head>
<body>
    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg navbar-light fixed-top">
        <div class="container">
            <a class="navbar-brand fw-bold" href="#">PicknGo</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="/">Home</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="/services">Services</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="/about">About</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="/contact">Contact</a>
                    </li>
                    <li class="nav-item ms-lg-3">
                        <a class="btn btn-glass px-4" href="/login">Login</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Registration Form Section -->
    <div class="container py-5 mt-5">
        <div class="floating-shape shape-1"></div>
        <div class="floating-shape shape-2"></div>

        <div class="row justify-content-center">
            <div class="col-lg-8">
                <div class="glass-card overflow-hidden">
                    <div class="glass-card-header">
                        <h3 class="mb-0"><i class="fas fa-box me-2"></i> Shipper Registration</h3>
                        <p class="mb-0 mt-2 opacity-75">Create your shipper account and start shipping goods today</p>
                    </div>
                    <div class="card-body p-4">
                        <!-- Error Message -->
                        <div class="alert alert-glass mb-4" style="display: none;">
                            <div class="d-flex align-items-center">
                                <i class="fas fa-exclamation-circle me-2"></i>
                                <div>Error message goes here</div>
                            </div>
                        </div>

                        <!-- Registration Form -->
                        <form action="/register/shipper" method="post" class="needs-validation" novalidate="true">
                            <!-- Add CSRF token -->
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label for="name" class="form-label required">Full Name</label>
                                    <div class="position-relative">
                                        <input type="text" class="form-control" id="name" name="name" placeholder="Enter your full name" required>
                                        <i class="fas fa-user input-icon"></i>
                                    </div>
                                    <div class="invalid-feedback">
                                        Please enter your full name
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <label for="email" class="form-label required">Email Address</label>
                                    <div class="position-relative">
                                        <input type="email" class="form-control" id="email" name="email" placeholder="Enter your email address" required>
                                        <i class="fas fa-envelope input-icon"></i>
                                    </div>
                                    <div class="invalid-feedback">
                                        Please enter a valid email address
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <label for="password" class="form-label required">Password</label>
                                    <div class="input-group">
                                        <input type="password" class="form-control" id="password" name="password" placeholder="Enter your password" required>
                                        <button class="btn btn-glass-light password-toggle" type="button">
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
                                <div class="col-md-6">
                                    <label for="contactNumber" class="form-label required">Contact Number</label>
                                    <div class="position-relative">
                                        <input type="tel" class="form-control" id="contactNumber" name="contactNumber" placeholder="Enter your contact number" required>
                                        <i class="fas fa-phone input-icon"></i>
                                    </div>
                                    <div class="invalid-feedback">
                                        Please enter your contact number
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <label for="companyName" class="form-label">Company Name</label>
                                    <div class="position-relative">
                                        <input type="text" class="form-control" id="companyName" name="companyName" placeholder="Enter your company name (if applicable)">
                                        <i class="fas fa-building input-icon"></i>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <label for="address" class="form-label required">Address</label>
                                    <div class="position-relative">
                                        <textarea class="form-control" id="address" name="address" rows="3" placeholder="Enter your address" required></textarea>
                                        <i class="fas fa-map-marker-alt input-icon" style="top: 24px;"></i>
                                    </div>
                                    <div class="invalid-feedback">
                                        Please enter your address
                                    </div>
                                </div>
                                <div class="col-12">
                                    <div class="form-check mt-2">
                                        <input class="form-check-input" type="checkbox" id="terms" required>
                                        <label class="form-check-label" for="terms">
                                            I agree to the <a href="#" data-bs-toggle="modal" data-bs-target="#termsModal">Terms and Conditions</a>
                                        </label>
                                        <div class="invalid-feedback">
                                            You must agree to the terms and conditions
                                        </div>
                                    </div>
                                </div>
                                <div class="col-12 mt-4">
                                    <button type="submit" class="btn btn-glass btn-lg w-100">
                                        <i class="fas fa-user-plus me-2"></i> Register as Shipper
                                    </button>
                                </div>
                            </div>
                        </form>

                        <div class="text-center mt-4">
                            <p>Already have an account? <a href="/login" class="fw-bold text-decoration-none">Login Now</a></p>
                        </div>
                    </div>
                </div>

                <div class="text-center mt-4">
                    <p class="text-muted">Interested in a different role?</p>
                    <div class="d-flex justify-content-center gap-2 flex-wrap">
                        <a href="/register/driver" class="btn btn-glass-light btn-sm">
                            <i class="fas fa-truck me-1"></i> Register as Driver
                        </a>
                        <a href="/register/vendor" class="btn btn-glass-light btn-sm">
                            <i class="fas fa-building me-1"></i> Register as Vendor
                        </a>
                        <a href="/register/customer" class="btn btn-glass-light btn-sm">
                            <i class="fas fa-user me-1"></i> Register as Customer
                        </a>
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
                    <div class="mb-4">
                        <h6 class="fw-bold">1. Acceptance of Terms</h6>
                        <p>By accessing and using PicknGo, you agree to be bound by these Terms and Conditions.</p>
                    </div>

                    <div class="mb-4">
                        <h6 class="fw-bold">2. User Accounts</h6>
                        <p>You are responsible for maintaining the confidentiality of your account information and password.</p>
                    </div>

                    <div class="mb-4">
                        <h6 class="fw-bold">3. Shipping Policies</h6>
                        <p>Shippers are responsible for providing accurate information about the goods being transported.</p>
                    </div>

                    <div class="mb-4">
                        <h6 class="fw-bold">4. Payments</h6>
                        <p>All payment transactions are processed securely through our platform.</p>
                    </div>

                    <div class="mb-4">
                        <h6 class="fw-bold">5. Privacy Policy</h6>
                        <p>We collect and process your personal data in accordance with our Privacy Policy.</p>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-glass" data-bs-dismiss="modal">I Understand</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <footer class="py-4 text-white mt-5">
        <div class="container">
            <div class="row">
                <div class="col-md-6">
                    <p class="mb-0">© 2025 PicknGo. All rights reserved.</p>
                </div>
                <div class="col-md-6 text-md-end">
                    <a href="#" class="text-white me-3">Privacy Policy</a>
                    <a href="#" class="text-white me-3">Terms of Service</a>
                    <a href="#" class="text-white">Contact Us</a>
                </div>
            </div>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Form validation
        (function () {
            'use strict'

            // Fetch all the forms we want to apply custom Bootstrap validation styles to
            var forms = document.querySelectorAll('.needs-validation')

            // Loop over them and prevent submission
            Array.prototype.slice.call(forms)
                .forEach(function (form) {
                    form.addEventListener('submit', function (event) {
                        if (!form.checkValidity()) {
                            event.preventDefault()
                            event.stopPropagation()
                        }

                        form.classList.add('was-validated')
                    }, false)
                })
        })()

        // Toggle password visibility
        document.querySelector('.password-toggle').addEventListener('click', function() {
            const passwordInput = document.getElementById('password');
            const icon = this.querySelector('i');

            if (passwordInput.type === 'password') {
                passwordInput.type = 'text';
                icon.classList.remove('fa-eye');
                icon.classList.add('fa-eye-slash');
            } else {
                passwordInput.type = 'password';
                icon.classList.remove('fa-eye-slash');
                icon.classList.add('fa-eye');
            }
        });
    </script>
</body>
</html>