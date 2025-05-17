<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Shipment - PicknGo</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .form-card {
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        .form-header {
            background-color: #f8f9fa;
            padding: 20px;
            border-bottom: 1px solid #dee2e6;
        }
        .form-body {
            padding: 20px;
        }
        .section-divider {
            margin: 30px 0;
            border-top: 1px solid #dee2e6;
        }
        .text-danger {
            font-size: 0.875rem;
            margin-top: 0.25rem;
        }
        .loading-spinner {
            display: none;
            vertical-align: middle;
            margin-left: 5px;
        }
        .geocode-btn {
            margin-top: 8px;
        }
    </style>
</head>
<body>
    <jsp:include page="../layout/header.jsp" />
    
    <div class="container py-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1><i class="fas fa-plus-circle me-2"></i>Create New Shipment</h1>
            <a href="/shipper/shipments" class="btn btn-outline-primary">
                <i class="fas fa-arrow-left me-2"></i>Back to Shipments
            </a>
        </div>
        
        <div class="card form-card">
            <div class="form-header">
                <h5 class="mb-0">Shipment Details</h5>
            </div>
            <div class="form-body">
                <form:form action="/shipper/create-shipment" method="post" modelAttribute="shipment">
                    <h5 class="mb-3">Package Information</h5>
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="weight" class="form-label">Weight (kg) *</label>
                                <form:input path="weight" type="number" class="form-control" id="weight" step="0.01" min="0.01" required="true" />
                                <form:errors path="weight" cssClass="text-danger" />
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="quantity" class="form-label">Quantity *</label>
                                <form:input path="quantity" type="number" class="form-control" id="quantity" step="0.01" min="0.01" required="true" />
                                <form:errors path="quantity" cssClass="text-danger" />
                            </div>
                        </div>
                    </div>
                    
                    <div class="mb-3">
                        <label for="goodsType" class="form-label">Goods Type/Description *</label>
                        <form:textarea path="goodsType" class="form-control" id="goodsType" rows="3" required="true" placeholder="Describe the contents of your package" />
                        <form:errors path="goodsType" cssClass="text-danger" />
                    </div>
                    
                    <div class="mb-3">
                        <label for="price" class="form-label">Price *</label>
                        <form:input path="price" type="number" class="form-control" id="price" step="0.01" min="0" required="true" />
                        <form:errors path="price" cssClass="text-danger" />
                    </div>
                    
                    <hr class="section-divider" />
                    
                    <h5 class="mb-3">Origin & Destination</h5>
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <h6>Pickup Location</h6>
                            <div class="mb-3">
                                <label for="pickupAddress" class="form-label">Pickup Address *</label>
                                <div class="input-group">
                                    <form:input path="pickupAddress" type="text" class="form-control" id="pickupAddress" required="true" />
                                    <button type="button" class="btn btn-outline-secondary" id="geocodePickup">
                                        <i class="fas fa-map-marker-alt"></i>
                                        <span class="spinner-border spinner-border-sm loading-spinner" id="pickupSpinner" role="status" aria-hidden="true"></span>
                                    </button>
                                </div>
                                <small class="form-text text-muted">Enter address and click the marker icon to get coordinates</small>
                                <form:errors path="pickupAddress" cssClass="text-danger" />
                            </div>
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="pickupLatitude" class="form-label">Latitude</label>
                                        <form:input path="pickupLatitude" type="number" step="0.000001" class="form-control" id="pickupLatitude" placeholder="Enter decimal value" />
                                        <form:errors path="pickupLatitude" cssClass="text-danger" />
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="pickupLongitude" class="form-label">Longitude</label>
                                        <form:input path="pickupLongitude" type="number" step="0.000001" class="form-control" id="pickupLongitude" placeholder="Enter decimal value" />
                                        <form:errors path="pickupLongitude" cssClass="text-danger" />
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="col-md-6">
                            <h6>Delivery Location</h6>
                            <div class="mb-3">
                                <label for="deliveryAddress" class="form-label">Delivery Address *</label>
                                <div class="input-group">
                                    <form:input path="deliveryAddress" type="text" class="form-control" id="deliveryAddress" required="true" />
                                    <button type="button" class="btn btn-outline-secondary" id="geocodeDelivery">
                                        <i class="fas fa-map-marker-alt"></i>
                                        <span class="spinner-border spinner-border-sm loading-spinner" id="deliverySpinner" role="status" aria-hidden="true"></span>
                                    </button>
                                </div>
                                <small class="form-text text-muted">Enter address and click the marker icon to get coordinates</small>
                                <form:errors path="deliveryAddress" cssClass="text-danger" />
                            </div>
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="deliveryLatitude" class="form-label">Latitude</label>
                                        <form:input path="deliveryLatitude" type="number" step="0.000001" class="form-control" id="deliveryLatitude" placeholder="Enter decimal value" />
                                        <form:errors path="deliveryLatitude" cssClass="text-danger" />
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="deliveryLongitude" class="form-label">Longitude</label>
                                        <form:input path="deliveryLongitude" type="number" step="0.000001" class="form-control" id="deliveryLongitude" placeholder="Enter decimal value" />
                                        <form:errors path="deliveryLongitude" cssClass="text-danger" />
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <hr class="section-divider" />
                    
                    <h5 class="mb-3">Shipping Timeline</h5>
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="pickupTime" class="form-label">Requested Pickup Time</label>
                                <form:input path="pickupTime" type="datetime-local" class="form-control" id="pickupTime" />
                                <small class="form-text text-muted">Choose a date and time for pickup</small>
                                <form:errors path="pickupTime" cssClass="text-danger" />
                            </div>
                        </div>
                    </div>
                    
                    <div class="d-grid gap-2 d-md-flex justify-content-md-end mt-4">
                        <button type="reset" class="btn btn-outline-secondary me-md-2">
                            <i class="fas fa-undo me-2"></i>Reset
                        </button>
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-paper-plane me-2"></i>Create Shipment
                        </button>
                    </div>
                </form:form>
            </div>
        </div>
    </div>
    
    <jsp:include page="../layout/footer.jsp" />
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBoQ6FN55NtAUucLWKMDW5s1CricaJ8UdE&libraries=places" async defer></script>
    
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Geocoding for pickup address
            document.getElementById('geocodePickup').addEventListener('click', function() {
                const address = document.getElementById('pickupAddress').value;
                if (address) {
                    geocodeAddress(address, 'pickup');
                } else {
                    alert('Please enter a pickup address first');
                }
            });
            
            // Geocoding for delivery address
            document.getElementById('geocodeDelivery').addEventListener('click', function() {
                const address = document.getElementById('deliveryAddress').value;
                if (address) {
                    geocodeAddress(address, 'delivery');
                } else {
                    alert('Please enter a delivery address first');
                }
            });
            
            function geocodeAddress(address, type) {
                // Show the spinner
                document.getElementById(type + 'Spinner').style.display = 'inline-block';
                
                // Initialize the geocoder
                const geocoder = new google.maps.Geocoder();
                
                // Perform geocoding
                geocoder.geocode({ 'address': address }, function(results, status) {
                    // Hide the spinner
                    document.getElementById(type + 'Spinner').style.display = 'none';
                    
                    if (status === 'OK') {
                        if (results[0]) {
                            const location = results[0].geometry.location;
                            document.getElementById(type + 'Latitude').value = location.lat();
                            document.getElementById(type + 'Longitude').value = location.lng();
                            
                            // Show success message
                            alert('Coordinates retrieved successfully for ' + type + ' address.');
                        } else {
                            alert('No results found for the address');
                        }
                    } else {
                        alert('Geocode was not successful for the following reason: ' + status);
                    }
                });
            }
        });
    </script>
</body>
</html> 