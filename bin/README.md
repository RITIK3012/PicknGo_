# PicknGo - Smart Transportation & Logistics Platform

PicknGo is a comprehensive web-based transportation and logistics service platform designed to streamline the movement of goods from one location to another. The platform caters to three main user roles — Shipper, Driver, and Vendor (Fleet Owner) — along with an Admin Dashboard for management and monitoring.

## Features

### Shipper (Customer)
- Shipper Registration & Login
- Create New Shipment with details (Goods Type, Quantity, Weight, Price)
- Define Pickup & Delivery Addresses
- Track Shipments in Real-Time
- View Shipment History

### Driver (Transporter)
- Driver Registration & Login
- Submit Basic Details (License, Contact Info)
- Add Vehicle Details (Truck Type, Number, Load Capacity)
- Add Bank Details (for Payments)
- Upload Video KYC for Verification
- View Assigned Shipments
- Update Shipment Status (In Transit, Delivered)

### Vendor (Fleet Owner)
- Vendor Registration & Login
- Manage Driver Profiles
- Assign Shipments to Drivers
- Live Location Tracking of All Trucks
- Monitor Delivery Status & Reports

### Admin Dashboard
- Manage Shippers, Drivers, and Vendors
- Approve/Reject Driver KYC
- View All Shipments and Statuses
- Monitor Real-Time Tracking
- Generate Reports
- Block/Activate Accounts

## Technologies Used

- **Backend**: Spring Boot
- **Frontend**: JSP, CSS, JavaScript
- **Database**: MySQL
- **Authentication**: Spring Security
- **APIs**: Google Maps API for location tracking

## Setup and Installation

1. Clone the repository:
   ```
   git clone https://github.com/yourusername/pickngo.git
   cd pickngo
   ```

2. Configure MySQL database in `application.properties`:
   ```
   spring.datasource.url=jdbc:mysql://localhost:3306/pickngo?createDatabaseIfNotExist=true
   spring.datasource.username=your_username
   spring.datasource.password=your_password
   ```

3. Build and run the application:
   ```
   mvn clean install
   mvn spring-boot:run
   ```

4. Access the application at: http://localhost:8080

## Default Login Credentials

- **Admin**:
  - Email: admin@pickngo.com
  - Password: admin123

- **Shipper**:
  - Email: shipper@pickngo.com
  - Password: shipper123

- **Driver**:
  - Email: driver@pickngo.com
  - Password: driver123

- **Vendor**:
  - Email: vendor@pickngo.com
  - Password: vendor123 