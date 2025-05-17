<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="title" value="Home" />
<%@ include file="layout/header.jsp" %>

<!-- Hero Section -->
<section class="hero-section">
    <div class="container">
        <div class="row align-items-center">
            <div class="col-lg-6">
                <h1 class="mb-4">We Provide Best Transport Service</h1>
                <p class="lead mb-4">We provide the best transportation services with a focus on reliability, safety, and efficiency. Our solutions are designed to meet your needs, ensuring timely deliveries, optimized routes, and exceptional customer satisfaction.</p>
                <a href="/register" class="btn btn-primary btn-lg">Get Started</a>
                <a href="/services" class="btn btn-outline-light btn-lg ms-2">Learn More</a>
            </div>
            <div class="col-lg-6 d-none d-lg-block">
                <img src="/images/hero-truck.png" alt="Transport Service" class="img-fluid">
            </div>
        </div>
    </div>
</section>

<!-- Services Section -->
<section class="py-5">
    <div class="container">
        <div class="text-center mb-5">
            <h2 class="fw-bold">Our Services</h2>
            <p class="lead">The system is designed to streamline the logistics process by connecting shippers who need goods transported with available truck drivers.</p>
        </div>
        
        <div class="row g-4">
            <div class="col-md-3">
                <div class="card feature-card text-center p-4">
                    <div class="feature-icon mx-auto mb-4">
                        <i class="fas fa-box"></i>
                    </div>
                    <h5 class="card-title">Shipper</h5>
                    <p class="card-text">Person who wants to transfer their goods from one place to another.</p>
                    <a href="/register/shipper" class="btn btn-sm btn-primary mt-auto">Register as Shipper</a>
                </div>
            </div>
            
            <div class="col-md-3">
                <div class="card feature-card text-center p-4">
                    <div class="feature-icon mx-auto mb-4">
                        <i class="fas fa-truck"></i>
                    </div>
                    <h5 class="card-title">Driver</h5>
                    <p class="card-text">A truck driver who owns or drives a vehicle for transporting goods.</p>
                    <a href="/register/driver" class="btn btn-sm btn-primary mt-auto">Register as Driver</a>
                </div>
            </div>
            
            <div class="col-md-3">
                <div class="card feature-card text-center p-4">
                    <div class="feature-icon mx-auto mb-4">
                        <i class="fas fa-building"></i>
                    </div>
                    <h5 class="card-title">Vendor</h5>
                    <p class="card-text">This is the third party man which is the owner of the truck drivers.</p>
                    <a href="/register/vendor" class="btn btn-sm btn-primary mt-auto">Register as Vendor</a>
                </div>
            </div>
            
            <div class="col-md-3">
                <div class="card feature-card text-center p-4">
                    <div class="feature-icon mx-auto mb-4">
                        <i class="fas fa-user"></i>
                    </div>
                    <h5 class="card-title">Customer</h5>
                    <p class="card-text">Register as a customer to order products and get them delivered to your doorstep.</p>
                    <a href="/register/customer" class="btn btn-sm btn-primary mt-auto">Register as Customer</a>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- About Section -->
<section class="py-5 bg-light">
    <div class="container">
        <div class="row align-items-center">
            <div class="col-lg-6">
                <h2 class="fw-bold mb-4">About Us</h2>
                <p>This is a transportation management platform that connects shippers and drivers on a common platform. Shippers can post jobs, load goods for transportation, and drivers (especially truck drivers) can accept jobs to transport goods to their destination, thereby providing work opportunities to drivers.</p>
                <p>Our mission is to revolutionize the logistics industry by creating a seamless, efficient, and transparent platform that benefits both shippers and transporters.</p>
                <a href="/about" class="btn btn-primary">Learn More</a>
            </div>
            <div class="col-lg-6">
                <img src="/images/about-img.jpg" alt="About PicknGo" class="img-fluid rounded shadow">
            </div>
        </div>
    </div>
</section>

<!-- Tracking Section -->
<section class="py-5">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-8 text-center">
                <h2 class="fw-bold mb-4">Track Your Shipment</h2>
                <p class="lead mb-5">Enter your shipment ID to get real-time updates on your shipment status.</p>
                
                <form action="/track" method="get" class="mb-4">
                    <div class="input-group">
                        <input type="text" class="form-control form-control-lg" placeholder="Enter Shipment ID" name="id" required>
                        <button class="btn btn-primary btn-lg" type="submit">Track</button>
                    </div>
                </form>
                
                <div class="row g-4 mt-3">
                    <div class="col-md-6">
                        <div class="card border-0 shadow-sm p-3">
                            <div class="d-flex align-items-center">
                                <div class="me-3 text-primary">
                                    <i class="fas fa-map-marker-alt fa-2x"></i>
                                </div>
                                <div>
                                    <h5 class="mb-1">GPS Tracking</h5>
                                    <p class="mb-0 text-muted">Drivers' locations are tracked and visible to shippers.</p>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="card border-0 shadow-sm p-3">
                            <div class="d-flex align-items-center">
                                <div class="me-3 text-primary">
                                    <i class="fas fa-bell fa-2x"></i>
                                </div>
                                <div>
                                    <h5 class="mb-1">Status Updates</h5>
                                    <p class="mb-0 text-muted">Drivers update the shipment's status with notifications.</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Testimonials Section -->
<section class="py-5 bg-light">
    <div class="container">
        <div class="text-center mb-5">
            <h2 class="fw-bold">What Our Clients Say</h2>
            <p class="lead">Trusted by businesses across the country</p>
        </div>
        
        <div class="row g-4">
            <div class="col-md-6 col-lg-3">
                <div class="card h-100 border-0 shadow-sm">
                    <div class="card-body text-center p-4">
                        <div class="mb-3">
                            <i class="fas fa-quote-left fa-2x text-primary opacity-50"></i>
                        </div>
                        <p class="card-text">PicknGo has revolutionized our logistics operations. The platform is user-friendly and the tracking features are excellent.</p>
                        <div class="mt-3">
                            <h6 class="mb-1">John Smith</h6>
                            <p class="small text-muted mb-0">ABC Enterprises</p>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="col-md-6 col-lg-3">
                <div class="card h-100 border-0 shadow-sm">
                    <div class="card-body text-center p-4">
                        <div class="mb-3">
                            <i class="fas fa-quote-left fa-2x text-primary opacity-50"></i>
                        </div>
                        <p class="card-text">As a driver, I've found more work opportunities through PicknGo than any other platform. The payment system is prompt and reliable.</p>
                        <div class="mt-3">
                            <h6 class="mb-1">Michael Johnson</h6>
                            <p class="small text-muted mb-0">Independent Driver</p>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="col-md-6 col-lg-3">
                <div class="card h-100 border-0 shadow-sm">
                    <div class="card-body text-center p-4">
                        <div class="mb-3">
                            <i class="fas fa-quote-left fa-2x text-primary opacity-50"></i>
                        </div>
                        <p class="card-text">Managing my fleet of trucks has never been easier. The real-time tracking and assignment features save us hours every day.</p>
                        <div class="mt-3">
                            <h6 class="mb-1">Sarah Williams</h6>
                            <p class="small text-muted mb-0">XYZ Logistics</p>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="col-md-6 col-lg-3">
                <div class="card h-100 border-0 shadow-sm">
                    <div class="card-body text-center p-4">
                        <div class="mb-3">
                            <i class="fas fa-quote-left fa-2x text-primary opacity-50"></i>
                        </div>
                        <p class="card-text">Customer support is excellent. Any issues we've had were resolved quickly. PicknGo has become an essential part of our business.</p>
                        <div class="mt-3">
                            <h6 class="mb-1">David Brown</h6>
                            <p class="small text-muted mb-0">Brown Manufacturers</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Call to Action -->
<section class="py-5 bg-primary text-white">
    <div class="container">
        <div class="row align-items-center">
            <div class="col-lg-8 mb-4 mb-lg-0">
                <h2 class="fw-bold mb-3">Ready to get started?</h2>
                <p class="lead mb-0">Join thousands of businesses and drivers who trust PicknGo for their logistics needs.</p>
            </div>
            <div class="col-lg-4 text-lg-end">
                <a href="/register" class="btn btn-light btn-lg">Sign Up Now</a>
                <a href="/contact" class="btn btn-outline-light btn-lg ms-2">Contact Us</a>
            </div>
        </div>
    </div>
</section>

<%@ include file="layout/footer.jsp" %> 