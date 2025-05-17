<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Shipment Details - PicknGo</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    <jsp:include page="../layout/header.jsp" />
    
    <div class="container py-5">
        <div class="row">
            <div class="col-md-3">
                <div class="card">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0"><i class="fas fa-user-circle me-2"></i>Menu</h5>
                    </div>
                    <div class="list-group list-group-flush">
                        <a href="/driver/dashboard" class="list-group-item list-group-item-action">
                            <i class="fas fa-tachometer-alt me-2"></i>Dashboard
                        </a>
                        <a href="/driver/profile" class="list-group-item list-group-item-action">
                            <i class="fas fa-user-cog me-2"></i>Profile
                        </a>
                        <a href="/driver/shipments" class="list-group-item list-group-item-action active">
                            <i class="fas fa-box me-2"></i>Shipments
                        </a>
                        <a href="/driver/vehicles" class="list-group-item list-group-item-action">
                            <i class="fas fa-truck me-2"></i>Vehicles
                        </a>
                    </div>
                </div>
            </div>
            <div class="col-md-9">
                <div class="card mb-4">
                    <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
                        <h5 class="mb-0"><i class="fas fa-box me-2"></i>Shipment #${shipment.trackingNumber}</h5>
                        <span class="badge ${shipment.status == 'DELIVERED' ? 'bg-success' : shipment.status == 'IN_TRANSIT' ? 'bg-warning text-dark' : 'bg-primary'}">
                            ${shipment.status}
                        </span>
                    </div>
                    <div class="card-body">
                        <div class="row mb-4">
                            <div class="col-md-6">
                                <h6 class="fw-bold">Shipper Information</h6>
                                <p>
                                    <i class="fas fa-user me-2"></i> ${shipment.shipper.name}<br>
                                    <i class="fas fa-envelope me-2"></i> ${shipment.shipper.email}<br>
                                    <i class="fas fa-phone me-2"></i> ${shipment.shipper.contactNumber}
                                </p>
                            </div>
                            <div class="col-md-6">
                                <h6 class="fw-bold">Shipment Details</h6>
                                <p>
                                    <strong>Weight:</strong> ${shipment.weight} kg<br>
                                    <strong>Volume:</strong> ${shipment.volume} m³<br>
                                    <strong>Created:</strong> ${shipment.createdAt}<br>
                                    <strong>Expected Delivery:</strong> ${shipment.expectedDeliveryDate}
                                </p>
                            </div>
                        </div>
                        
                        <div class="row mb-4">
                            <div class="col-md-6">
                                <div class="card h-100">
                                    <div class="card-header bg-light">
                                        <h6 class="mb-0"><i class="fas fa-map-marker-alt me-2"></i>Pickup Location</h6>
                                    </div>
                                    <div class="card-body">
                                        <address>
                                            ${shipment.pickupAddress}
                                        </address>
                                        <p class="mb-0">
                                            <strong>Contact:</strong> ${shipment.pickupContactName}<br>
                                            <strong>Phone:</strong> ${shipment.pickupContactPhone}
                                        </p>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="card h-100">
                                    <div class="card-header bg-light">
                                        <h6 class="mb-0"><i class="fas fa-map-marker-alt me-2"></i>Delivery Location</h6>
                                    </div>
                                    <div class="card-body">
                                        <address>
                                            ${shipment.deliveryAddress}
                                        </address>
                                        <p class="mb-0">
                                            <strong>Contact:</strong> ${shipment.deliveryContactName}<br>
                                            <strong>Phone:</strong> ${shipment.deliveryContactPhone}
                                        </p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <h6 class="fw-bold mb-3">Shipment Items</h6>
                        <div class="table-responsive mb-4">
                            <table class="table table-bordered">
                                <thead class="table-light">
                                    <tr>
                                        <th>Item Description</th>
                                        <th>Quantity</th>
                                        <th>Weight (kg)</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${shipment.items}" var="item">
                                        <tr>
                                            <td>${item.description}</td>
                                            <td>${item.quantity}</td>
                                            <td>${item.weight}</td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                        
                        <h6 class="fw-bold mb-3">Update Shipment Status</h6>
                        <form action="/driver/update-shipment-status/${shipment.id}" method="post" class="mb-4">
                            <div class="row g-3 align-items-center">
                                <div class="col-md-4">
                                    <select name="status" class="form-select" required>
                                        <option value="">Select Status</option>
                                        <option value="PENDING" ${shipment.status == 'PENDING' ? 'selected' : ''}>Pending</option>
                                        <option value="ACCEPTED" ${shipment.status == 'ACCEPTED' ? 'selected' : ''}>Accepted</option>
                                        <option value="PICKED_UP" ${shipment.status == 'PICKED_UP' ? 'selected' : ''}>Picked Up</option>
                                        <option value="IN_TRANSIT" ${shipment.status == 'IN_TRANSIT' ? 'selected' : ''}>In Transit</option>
                                        <option value="OUT_FOR_DELIVERY" ${shipment.status == 'OUT_FOR_DELIVERY' ? 'selected' : ''}>Out for Delivery</option>
                                        <option value="DELIVERED" ${shipment.status == 'DELIVERED' ? 'selected' : ''}>Delivered</option>
                                    </select>
                                </div>
                                <div class="col-md-4">
                                    <input type="number" step="0.000001" name="latitude" class="form-control" placeholder="Latitude" required>
                                </div>
                                <div class="col-md-4">
                                    <input type="number" step="0.000001" name="longitude" class="form-control" placeholder="Longitude" required>
                                </div>
                                <div class="col-12 text-end">
                                    <button type="submit" class="btn btn-primary">
                                        <i class="fas fa-sync-alt me-2"></i>Update Status
                                    </button>
                                </div>
                            </div>
                        </form>
                        
                        <div class="text-end">
                            <a href="/driver/shipments" class="btn btn-secondary">
                                <i class="fas fa-arrow-left me-2"></i>Back to Shipments
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <jsp:include page="../layout/footer.jsp" />
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Could add geolocation API to get current coordinates
        if (navigator.geolocation) {
            document.querySelector('button[type="submit"]').addEventListener('click', function(e) {
                e.preventDefault();
                navigator.geolocation.getCurrentPosition(function(position) {
                    document.querySelector('input[name="latitude"]').value = position.coords.latitude;
                    document.querySelector('input[name="longitude"]').value = position.coords.longitude;
                    document.querySelector('form').submit();
                }, function(error) {
                    console.error("Error getting location: ", error);
                    alert("Please enable location services or enter coordinates manually.");
                });
            });
        }
    </script>
</body>
</html>