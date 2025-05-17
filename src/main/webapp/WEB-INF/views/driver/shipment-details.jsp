<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="_csrf" content="${_csrf.token}"/>
    <meta name="_csrf_header" content="${_csrf.headerName}"/>
    <title>Shipment Details - PicknGo</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        #locationMap {
            height: 250px;
            width: 100%;
            border-radius: 10px;
            margin-bottom: 20px;
        }
        .highlight-pulse {
            animation: pulse 2s;
        }
        @keyframes pulse {
            0% {
                box-shadow: 0 0 0 0 rgba(0, 123, 255, 0.7);
            }
            70% {
                box-shadow: 0 0 0 10px rgba(0, 123, 255, 0);
            }
            100% {
                box-shadow: 0 0 0 0 rgba(0, 123, 255, 0);
            }
        }
    </style>
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
                        
                        <!-- Location Map -->
                        <div class="card mb-4">
                            <div class="card-header bg-light">
                                <h6 class="mb-0"><i class="fas fa-map me-2"></i>Location Tracking</h6>
                            </div>
                            <div class="card-body">
                                <div id="locationMap" class="mb-3"></div>
                                <div class="alert alert-info">
                                    <i class="fas fa-info-circle me-2"></i> Use the map to visualize pickup and delivery locations. Your current position is shown in blue when location access is enabled.
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
                        <form action="/driver/update-shipment-status/${shipment.id}" method="post" class="mb-4" id="updateStatusForm">
                            <div class="row g-3 align-items-center">
                                <div class="col-md-4">
                                    <select name="status" class="form-select" required id="statusSelect">
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
                                    <input type="number" step="0.000001" name="latitude" class="form-control" placeholder="Latitude" required id="latitudeInput">
                                </div>
                                <div class="col-md-4">
                                    <input type="number" step="0.000001" name="longitude" class="form-control" placeholder="Longitude" required id="longitudeInput">
                                </div>
                                <div class="col-12">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <button type="button" id="getLocationBtn" class="btn btn-secondary">
                                            <i class="fas fa-crosshairs me-2"></i>Get Current Location
                                        </button>
                                        <button type="submit" class="btn btn-primary" id="updateStatusBtn">
                                            <i class="fas fa-sync-alt me-2"></i>Update Status
                                        </button>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- CSRF token -->
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
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
    
    <!-- Notification Template -->
    <div id="notification" class="toast align-items-center text-white bg-primary border-0" role="alert" aria-atomic="true" style="position: fixed; top: 20px; right: 20px; z-index: 1050;">
        <div class="d-flex">
            <div class="toast-body">
                <i class="fas fa-info-circle me-2"></i>
                <span id="notification-message"></span>
            </div>
            <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
        </div>
    </div>
    
    <jsp:include page="../layout/footer.jsp" />
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.5.1/sockjs.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
    <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBoQ6FN55NtAUucLWKMDW5s1CricaJ8UdE&callback=initMap" async defer></script>
    
    <script>
        // Global variables
        let map;
        let originMarker;
        let destinationMarker;
        let currentLocationMarker;
        let directionsService;
        let directionsRenderer;
        let watchPositionId;
        let stompClient = null;
        const shipmentId = ${shipment.id};
        
        // Initialize map
        function initMap() {
            // Setup variables for coordinates
            const hasOrigin = ${shipment.pickupLatitude != null && shipment.pickupLongitude != null};
            const hasDestination = ${shipment.deliveryLatitude != null && shipment.deliveryLongitude != null};
            
            // Default center (India)
            let mapCenter = {lat: 20.5937, lng: 78.9629};
            
            // Set center based on available coordinates
            if (hasOrigin) {
                mapCenter = {
                    lat: Number(${shipment.pickupLatitude}),
                    lng: Number(${shipment.pickupLongitude})
                };
            } else if (hasDestination) {
                mapCenter = {
                    lat: Number(${shipment.deliveryLatitude}),
                    lng: Number(${shipment.deliveryLongitude})
                };
            }
            
            // Create map
            map = new google.maps.Map(document.getElementById("locationMap"), {
                zoom: 12,
                center: mapCenter
            });
            
            // Setup directions service
            directionsService = new google.maps.DirectionsService();
            directionsRenderer = new google.maps.DirectionsRenderer({
                suppressMarkers: true,
                polylineOptions: {
                    strokeColor: '#007bff',
                    strokeWeight: 5
                }
            });
            directionsRenderer.setMap(map);
            
            // Add markers
            if (hasOrigin) {
                originMarker = new google.maps.Marker({
                    position: {
                        lat: Number(${shipment.pickupLatitude}),
                        lng: Number(${shipment.pickupLongitude})
                    },
                    map: map,
                    title: "Pickup: ${shipment.pickupAddress}",
                    icon: "http://maps.google.com/mapfiles/ms/icons/green-dot.png"
                });
            }
            
            if (hasDestination) {
                destinationMarker = new google.maps.Marker({
                    position: {
                        lat: Number(${shipment.deliveryLatitude}),
                        lng: Number(${shipment.deliveryLongitude})
                    },
                    map: map,
                    title: "Delivery: ${shipment.deliveryAddress}",
                    icon: "http://maps.google.com/mapfiles/ms/icons/red-dot.png"
                });
            }
            
            // If both origin and destination exist, draw route
            if (hasOrigin && hasDestination) {
                calculateAndDisplayRoute();
            }
        }
        
        function calculateAndDisplayRoute() {
            directionsService.route({
                origin: {
                    lat: Number(${shipment.pickupLatitude}),
                    lng: Number(${shipment.pickupLongitude})
                },
                destination: {
                    lat: Number(${shipment.deliveryLatitude}),
                    lng: Number(${shipment.deliveryLongitude})
                },
                travelMode: google.maps.TravelMode.DRIVING
            })
            .then(response => {
                directionsRenderer.setDirections(response);
            })
            .catch(error => {
                console.error("Directions request failed:", error);
            });
        }
        
        // Handle getting current location
        function getCurrentLocation() {
            if (navigator.geolocation) {
                navigator.geolocation.getCurrentPosition(
                    // Success callback
                    (position) => {
                        const coords = {
                            lat: position.coords.latitude,
                            lng: position.coords.longitude
                        };
                        
                        // Update form inputs
                        document.getElementById('latitudeInput').value = coords.lat;
                        document.getElementById('longitudeInput').value = coords.lng;
                        
                        // Update marker on map
                        if (currentLocationMarker) {
                            currentLocationMarker.setPosition(coords);
                        } else {
                            currentLocationMarker = new google.maps.Marker({
                                position: coords,
                                map: map,
                                title: "Your Current Location",
                                icon: "http://maps.google.com/mapfiles/ms/icons/blue-dot.png",
                                animation: google.maps.Animation.DROP
                            });
                        }
                        
                        // Center map on current location
                        map.setCenter(coords);
                        map.setZoom(15);
                        
                        // Show success notification
                        showNotification("Location acquired successfully");
                    },
                    // Error callback
                    (error) => {
                        console.error("Error getting location:", error);
                        showNotification("Error getting location. Please check location permissions.", "danger");
                    },
                    // Options
                    {
                        enableHighAccuracy: true,
                        timeout: 10000,
                        maximumAge: 0
                    }
                );
            } else {
                showNotification("Geolocation is not supported by this browser", "danger");
            }
        }
        
        function startWatchingPosition() {
            if (navigator.geolocation) {
                watchPositionId = navigator.geolocation.watchPosition(
                    (position) => {
                        const coords = {
                            lat: position.coords.latitude,
                            lng: position.coords.longitude
                        };
                        
                        // Update form inputs
                        document.getElementById('latitudeInput').value = coords.lat;
                        document.getElementById('longitudeInput').value = coords.lng;
                        
                        // Update marker on map
                        if (currentLocationMarker) {
                            currentLocationMarker.setPosition(coords);
                        } else {
                            currentLocationMarker = new google.maps.Marker({
                                position: coords,
                                map: map,
                                title: "Your Current Location",
                                icon: "http://maps.google.com/mapfiles/ms/icons/blue-dot.png"
                            });
                        }
                    },
                    (error) => {
                        console.error("Error watching position:", error);
                    },
                    {
                        enableHighAccuracy: true,
                        timeout: 10000,
                        maximumAge: 0
                    }
                );
            }
        }
        
        function stopWatchingPosition() {
            if (watchPositionId) {
                navigator.geolocation.clearWatch(watchPositionId);
                watchPositionId = null;
            }
        }
        
        function showNotification(message, type = "primary") {
            const notification = document.getElementById('notification');
            const messageEl = document.getElementById('notification-message');
            
            // Update notification color based on type
            notification.className = `toast align-items-center text-white bg-${type} border-0`;
            
            // Set message
            messageEl.textContent = message;
            
            // Show notification
            const toast = new bootstrap.Toast(notification, {
                autohide: true,
                delay: 3000
            });
            
            toast.show();
        }
        
        // Setup event listeners
        document.addEventListener('DOMContentLoaded', function() {
            // Get current location button
            document.getElementById('getLocationBtn').addEventListener('click', getCurrentLocation);
            
            // Start watching position when the page loads
            startWatchingPosition();
            
            // Form submission
            document.getElementById('updateStatusForm').addEventListener('submit', function(e) {
                const latitude = document.getElementById('latitudeInput').value;
                const longitude = document.getElementById('longitudeInput').value;
                
                if (!latitude || !longitude) {
                    e.preventDefault();
                    showNotification("Please provide location coordinates", "danger");
                    return;
                }
                
                // Show loading state
                const submitBtn = document.getElementById('updateStatusBtn');
                submitBtn.disabled = true;
                submitBtn.innerHTML = '<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> Updating...';
            });
        });
        
        // Cleanup when leaving the page
        window.addEventListener('beforeunload', function() {
            stopWatchingPosition();
        });
    </script>
</body>
</html>