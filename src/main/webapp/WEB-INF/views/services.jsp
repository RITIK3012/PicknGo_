<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Our Services</title>
    <!-- Font Awesome for icons -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background: #f6f8fb;
            margin: 0;
            padding: 0;
        }

        .section-padding {
            padding: 60px 20px;
        }

        .container {
            max-width: 1200px;
            margin: auto;
        }

        .section-title {
            font-size: 32px;
            font-weight: 700;
            color: #2d2d2d;
            position: relative;
        }

        .section-title::after {
            content: '';
            display: block;
            width: 60px;
            height: 4px;
            background: #6c63ff;
            margin: 10px auto 0;
        }

        .lead {
            color: #555;
            font-size: 18px;
        }

        .row {
            display: flex;
            flex-wrap: wrap;
            justify-content: space-between;
            gap: 20px;
        }

        .col-md-3 {
            flex: 1 1 calc(25% - 20px);
            display: flex;
        }

        .glass-card {
            background: rgba(255, 255, 255, 0.75);
            backdrop-filter: blur(10px);
            border-radius: 15px;
            padding: 30px 20px;
            text-align: center;
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.05);
            transition: transform 0.3s;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            width: 100%;
        }

        .glass-card:hover {
            transform: translateY(-5px);
        }

        .feature-icon {
            background: #e4e7ff;
            border-radius: 50%;
            width: 70px;
            height: 70px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            font-size: 28px;
            color: #6c63ff;
        }

        .btn-glass {
            background-color: #6c63ff;
            color: #fff;
            border: none;
            padding: 10px 18px;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 500;
        }

        .btn-glass:hover {
            background-color: #574fd6;
        }

        @media (max-width: 768px) {
            .col-md-3 {
                flex: 1 1 100%;
            }
        }
    </style>
</head>
<body>

<!-- Services Section -->
<section class="section-padding">
    <div class="container">
        <div class="text-center mb-5">
            <h2 class="section-title">Our Services</h2>
            <p class="lead mt-4">The system is designed to streamline the logistics process by connecting shippers who need goods transported with available truck drivers.</p>
        </div>

        <div class="row">
            <div class="col-md-3">
                <div class="glass-card">
                    <div class="feature-icon">
                        <i class="fas fa-box"></i>
                    </div>
                    <h5>Shipper</h5>
                    <p>Person who wants to transfer their goods from one place to another.</p>
                    <a href="/register/shipper" class="btn-glass">Register as Shipper</a>
                </div>
            </div>

            <div class="col-md-3">
                <div class="glass-card">
                    <div class="feature-icon">
                        <i class="fas fa-truck"></i>
                    </div>
                    <h5>Driver</h5>
                    <p>A truck driver who owns or drives a vehicle for transporting goods.</p>
                    <a href="/register/driver" class="btn-glass">Register as Driver</a>
                </div>
            </div>

            <div class="col-md-3">
                <div class="glass-card">
                    <div class="feature-icon">
                        <i class="fas fa-building"></i>
                    </div>
                    <h5>Vendor</h5>
                    <p>This is the third party man which is the owner of the truck drivers.</p>
                    <a href="/register/vendor" class="btn-glass">Register as Vendor</a>
                </div>
            </div>

            <div class="col-md-3">
                <div class="glass-card">
                    <div class="feature-icon">
                        <i class="fas fa-user"></i>
                    </div>
                    <h5>Customer</h5>
                    <p>Register as a customer to order products and get them delivered to your doorstep.</p>
                    <a href="/register/customer" class="btn-glass">Register as Customer</a>
                </div>
            </div>
        </div>
    </div>
</section>

</body>
</html>
