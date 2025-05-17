<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PicknGo - Transport Services</title>
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
            transform: translateY(-5px);
            box-shadow: 0 12px 48px 0 rgba(31, 38, 135, 0.25);
        }

        .navbar {
            background: rgba(255, 255, 255, 0.2);
            backdrop-filter: blur(10px);
            -webkit-backdrop-filter: blur(10px);
            border-bottom: 1px solid rgba(255, 255, 255, 0.18);
        }

        .hero-section {
            padding: 120px 0 80px;
            position: relative;
            overflow: hidden;
        }

        .hero-content {
            position: relative;
            z-index: 1;
        }

        .section-padding {
            padding: 100px 0;
        }

        .feature-icon {
            width: 80px;
            height: 80px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: rgba(67, 97, 238, 0.15);
            border-radius: 50%;
            margin-bottom: 20px;
        }

        .feature-icon i {
            font-size: 32px;
            color: var(--primary-color);
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

        .section-title {
            position: relative;
            margin-bottom: 50px;
        }

        .section-title::after {
            content: "";
            position: absolute;
            bottom: -15px;
            left: 50%;
            transform: translateX(-50%);
            width: 70px;
            height: 4px;
            background: var(--primary-color);
            border-radius: 2px;
        }

        .testimonial-card {
            height: 100%;
        }

        .cta-section {
            background: linear-gradient(135deg, rgba(67, 97, 238, 0.8), rgba(63, 55, 201, 0.8));
            backdrop-filter: blur(5px);
            border-top: 1px solid rgba(255, 255, 255, 0.18);
            border-bottom: 1px solid rgba(255, 255, 255, 0.18);
        }

        .tracking-input {
            background: rgba(255, 255, 255, 0.25);
            backdrop-filter: blur(5px);
            -webkit-backdrop-filter: blur(5px);
            border: 1px solid rgba(255, 255, 255, 0.18);
            border-radius: 0.375rem 0 0 0.375rem;
        }

        .tracking-input:focus {
            background: rgba(255, 255, 255, 0.4);
            box-shadow: 0 0 0 0.25rem rgba(67, 97, 238, 0.25);
            border-color: rgba(67, 97, 238, 0.5);
        }

        footer {
            background: rgba(33, 37, 41, 0.7);
            backdrop-filter: blur(10px);
            -webkit-backdrop-filter: blur(10px);
            border-top: 1px solid rgba(255, 255, 255, 0.1);
        }

        /* Floating elements */
        .floating-shape {
            position: absolute;
            border-radius: 50%;
            opacity: 0.05;
            filter: blur(40px);
            z-index: 0;
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
        .big-truck-icon {
              font-size: 300px; /* Make the icon big */
              color: #333;     /* Optional: dark color */
              margin: 10px;    /* Optional: spacing */
              margin-left: 100px;
           }
        .big-about-icon{
                      font-size: 250px; /* Make the icon big */
                      color: #333;     /* Optional: dark color */
                      margin: 10px;    /* Optional: spacing */
                      margin-left: 150px;

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
                        <a class="nav-link active" href="#">Home</a>
                    </li>
              <!--
                    <li class="nav-item">
                        <a class="nav-link" href="/services">Services</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#">About</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#">Contact</a>
                    </li>
               -->
                    <li class="nav-item ms-lg-3">
                        <a class="btn btn-glass px-4" href="/login">Login</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Hero Section -->
    <section class="hero-section">
        <div class="floating-shape shape-1"></div>
        <div class="floating-shape shape-2"></div>
        <div class="container">
            <div class="row align-items-center">
                <div class="col-lg-6 hero-content">
                    <h1 class="display-4 fw-bold mb-4">We Provide Best Transport Service</h1>
                    <p class="lead mb-4">We provide the best transportation services with a focus on reliability, safety, and efficiency. Our solutions are designed to meet your needs, ensuring timely deliveries, optimized routes, and exceptional customer satisfaction.</p>
                    <div class="d-flex flex-wrap gap-3">
                        <a href="/register" class="btn btn-glass btn-lg px-4 py-2">Get Started</a>
                        <a href="/services" class="btn btn-glass-light btn-lg px-4 py-2">Learn More</a>
                    </div>
                </div>
                <div class="col-lg-6 d-none d-lg-block">
                <div class="glass-card p-3">
                   <i class="fa-solid fa-truck-moving big-truck-icon"></i>

                 </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Services Section -->
    <section class="section-padding">
        <div class="container">
            <div class="text-center mb-5">
                <h2 class="fw-bold section-title">Our Services</h2>
                <p class="lead mt-4">The system is designed to streamline the logistics process by connecting shippers who need goods transported with available truck drivers.</p>
            </div>

            <div class="row g-4">
                <div class="col-md-3">
                    <div class="glass-card h-100 text-center p-4">
                        <div class="feature-icon mx-auto">
                            <i class="fas fa-box"></i>
                        </div>
                        <h5 class="card-title mb-3">Shipper</h5>
                        <p class="card-text mb-4">Person who wants to transfer their goods from one place to another.</p>
                        <a href="/register/shipper" class="btn btn-glass mt-auto">Register as Shipper</a>
                    </div>
                </div>

                <div class="col-md-3">
                    <div class="glass-card h-100 text-center p-4">
                        <div class="feature-icon mx-auto">
                            <i class="fas fa-truck"></i>
                        </div>
                        <h5 class="card-title mb-3">Driver</h5>
                        <p class="card-text mb-4">A truck driver who owns or drives a vehicle for transporting goods.</p>
                        <a href="/register/driver" class="btn btn-glass mt-auto">Register as Driver</a>
                    </div>
                </div>

                <div class="col-md-3">
                    <div class="glass-card h-100 text-center p-4">
                        <div class="feature-icon mx-auto">
                            <i class="fas fa-building"></i>
                        </div>
                        <h5 class="card-title mb-3">Vendor</h5>
                        <p class="card-text mb-4">This is the third party man which is the owner of the truck drivers.</p>
                        <a href="/register/vendor" class="btn btn-glass mt-auto">Register as Vendor</a>
                    </div>
                </div>

                 <div class="col-md-3">
                    <div class="glass-card h-100 text-center p-4">
                        <div class="feature-icon mx-auto">
                            <i class="fas fa-user"></i>
                        </div>
                        <h5 class="card-title mb-3">Customer</h5>
                        <p class="card-text mb-4">Register as a customer to order products and get them delivered to your doorstep.</p>
                        <a href="/register/customer" class="btn btn-glass mt-auto">Register as Customer</a>
                    </div>
                </div>

            </div>
        </div>
    </section>

    <!-- About Section -->
    <section class="section-padding">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-lg-6 mb-5 mb-lg-0">
                    <h2 class="fw-bold mb-4">About Us</h2>
                    <p class="mb-4">This is a transportation management platform that connects shippers and drivers on a common platform. Shippers can post jobs, load goods for transportation, and drivers (especially truck drivers) can accept jobs to transport goods to their destination, thereby providing work opportunities to drivers.</p>
                    <p class="mb-4">Our mission is to revolutionize the logistics industry by creating a seamless, efficient, and transparent platform that benefits both shippers and transporters.</p>
                    <a href="/about" class="btn btn-glass px-4 py-2">Learn More</a>
                </div>
                <div class="col-lg-6">
                    <div class="glass-card p-3">
                       <i class="fa-solid fa-address-card big-about-icon"></i>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Tracking Section -->
    <section class="section-padding">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-lg-8 text-center">
                    <h2 class="fw-bold section-title">Track Your Shipment</h2>
                    <p class="lead mt-4 mb-5">Enter your shipment ID to get real-time updates on your shipment status.</p>

                    <form action="/track" method="get" class="mb-5">
                        <div class="input-group">
                            <input type="text" class="form-control form-control-lg tracking-input" placeholder="Enter Shipment ID" name="id" required>
                            <button class="btn btn-glass btn-lg" type="submit">Track</button>
                        </div>
                    </form>

                    <div class="row g-4 mt-3">
                        <div class="col-md-6">
                            <div class="glass-card p-4">
                                <div class="d-flex align-items-center">
                                    <div class="me-3 text-primary">
                                        <i class="fas fa-map-marker-alt fa-2x"></i>
                                    </div>
                                    <div class="text-start">
                                        <h5 class="mb-1">GPS Tracking</h5>
                                        <p class="mb-0 text-muted">Drivers' locations are tracked and visible to shippers.</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="glass-card p-4">
                                <div class="d-flex align-items-center">
                                    <div class="me-3 text-primary">
                                        <i class="fas fa-bell fa-2x"></i>
                                    </div>
                                    <div class="text-start">
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
    <section class="section-padding">
        <div class="container">
            <div class="text-center mb-5">
                <h2 class="fw-bold section-title">What Our Clients Say</h2>
                <p class="lead mt-4">Trusted by businesses across the country</p>
            </div>

            <div class="row g-4">
                <div class="col-md-6 col-lg-3">
                    <div class="glass-card testimonial-card p-4">
                        <div class="mb-3 text-center">
                            <i class="fas fa-quote-left fa-2x text-primary opacity-50"></i>
                        </div>
                        <p class="card-text">PicknGo has revolutionized our logistics operations. The platform is user-friendly and the tracking features are excellent.</p>
                        <div class="mt-3 text-center">
                            <h6 class="mb-1">Ramlal</h6>
                            <p class="small text-muted mb-0">TATA Enterprises</p>
                        </div>
                    </div>
                </div>

                <div class="col-md-6 col-lg-3">
                    <div class="glass-card testimonial-card p-4">
                        <div class="mb-3 text-center">
                            <i class="fas fa-quote-left fa-2x text-primary opacity-50"></i>
                        </div>
                        <p class="card-text">As a driver, I've found more work opportunities through PicknGo than any other platform. The payment system is good.</p>
                        <div class="mt-3 text-center">
                            <h6 class="mb-1">Lalu jii</h6>
                            <p class="small text-muted mb-0">Independent Driver</p>
                        </div>
                    </div>
                </div>

                <div class="col-md-6 col-lg-3">
                    <div class="glass-card testimonial-card p-4">
                        <div class="mb-3 text-center">
                            <i class="fas fa-quote-left fa-2x text-primary opacity-50"></i>
                        </div>
                        <p class="card-text">Managing my fleet of trucks has never been easier. The real-time tracking and assignment features save us hours every day.</p>
                        <div class="mt-3 text-center">
                            <h6 class="mb-1">Ramu kaka</h6>
                            <p class="small text-muted mb-0">Mahindra Logistics</p>
                        </div>
                    </div>
                </div>

                <div class="col-md-6 col-lg-3">
                    <div class="glass-card testimonial-card p-4">
                        <div class="mb-3 text-center">
                            <i class="fas fa-quote-left fa-2x text-primary opacity-50"></i>
                        </div>
                        <p class="card-text">Customer support is excellent. Any issues we've had were resolved quickly. PicknGo has become an essential part of our business.</p>
                        <div class="mt-3 text-center">
                            <h6 class="mb-1">Nitish jii</h6>
                            <p class="small text-muted mb-0">Bihar Manufacturers</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Call to Action -->
    <section class="py-5 cta-section text-white">
        <div class="container py-4">
            <div class="row align-items-center">
                <div class="col-lg-8 mb-4 mb-lg-0">
                    <h2 class="fw-bold mb-3">Ready to get started?</h2>
                    <p class="lead mb-0">Join thousands of businesses and drivers who trust PicknGo for their logistics needs.</p>
                </div>
                <div class="col-lg-4 text-lg-end">
                    <a href="/register" class="btn btn-glass-light btn-lg">Sign Up Now</a>
                </div>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <footer class="bg-dark text-white py-5">
        <div class="container">
            <div class="row g-5">
                <!-- Company Info -->
                <div class="col-md-6 col-lg-4">
                    <h5 class="fw-bold mb-3">PicknGo</h5>
                    <p class="text-light">Revolutionizing logistics with our innovative platform connecting shippers and drivers.</p>
                    <div class="d-flex gap-3 mt-3">
                        <a href="#" class="text-white fs-5" aria-label="Facebook"><i class="fab fa-facebook-f"></i></a>
                        <a href="#" class="text-white fs-5" aria-label="Twitter"><i class="fab fa-twitter"></i></a>
                        <a href="#" class="text-white fs-5" aria-label="Instagram"><i class="fab fa-instagram"></i></a>
                        <a href="#" class="text-white fs-5" aria-label="LinkedIn"><i class="fab fa-linkedin-in"></i></a>
                    </div>
                </div>

                <!-- Quick Links -->
                <div class="col-md-6 col-lg-2">
                    <h6 class="fw-bold mb-3">Quick Links</h6>
                    <ul class="list-unstyled">
                        <li><a href="#" class="text-white text-decoration-none d-block py-1">Home</a></li>
                        <li><a href="#" class="text-white text-decoration-none d-block py-1">About</a></li>
                        <li><a href="#" class="text-white text-decoration-none d-block py-1">Services</a></li>
                        <li><a href="#" class="text-white text-decoration-none d-block py-1">Contact</a></li>
                    </ul>
                </div>

                <!-- Contact Info -->
                <div class="col-md-6 col-lg-3">
                    <h6 class="fw-bold mb-3">Contact</h6>
                    <ul class="list-unstyled">
                        <li class="mb-2"><i class="fas fa-map-marker-alt me-2"></i> Indore Madhya pradesh,India</li>
                        <li class="mb-2"><i class="fas fa-phone me-2"></i>+916207465041</li>
                        <li class="mb-2"><i class="fas fa-envelope me-2"></i>info@pickngo.com</li>
                    </ul>
                </div>

                <!-- Newsletter -->


                <div class="col-md-6 col-lg-3">
                    <h6 class="fw-bold mb-3">Newsletter</h6>
                    <p>Subscribe to our newsletter for the latest updates.</p>
                    <form>
                        <div class="input-group">
                            <input type="email" class="form-control" placeholder="Your Email" aria-label="Your email">
                            <button class="btn btn-primary" type="submit">Subscribe</button>
                        </div>
                    </form>
                </div>

            </div>

            <!-- Divider -->
            <hr class="mt-5 mb-3 border-light opacity-25">

            <!-- Copyright -->
            <div class="text-center">
                <small>&copy; 2025 PicknGo. All rights reserved.</small>
            </div>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>