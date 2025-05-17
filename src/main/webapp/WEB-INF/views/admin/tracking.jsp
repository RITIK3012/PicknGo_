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
    <title>Shipment Tracking - Admin Dashboard - PicknGo</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        #map {
            height: 400px;
            width: 100%;
            border-radius: 10px;
            margin-bottom: 20px;
        }
        .timeline {
            position: relative;
            max-width: 1200px;
            margin: 0 auto;
        }
        .timeline::after {
            content: '';
            position: absolute;
            width: 6px;
            background-color: #007bff;
            top: 0;
            bottom: 0;
            left: 50%;
            margin-left: -3px;
        }
        .container-timeline {
            padding: 10px 40px;
            position: relative;
            background-color: inherit;
            width: 50%;
        }
        .container-timeline::after {
            content: '';
            position: absolute;
            width: 25px;
            height: 25px;
            right: -17px;
            background-color: white;
            border: 4px solid #007bff;
            top: 15px;
            border-radius: 50%;
            z-index: 1;
        }
        .left {
            left: 0;
        }
        .right {
            left: 50%;
        }
        .left::before {
            content: " ";
            height: 0;
            position: absolute;
            top: 22px;
            width: 0;
            z-index: 1;
            right: 30px;
            border: medium solid #fff;
            border-width: 10px 0 10px 10px;
            border-color: transparent transparent transparent #fff;
        }
        .right::before {
            content: " ";
            height: 0;
            position: absolute;
            top: 22px;
            width: 0;
            z-index: 1;
            left: 30px;
            border: medium solid #fff;
            border-width: 10px 10px 10px 0;
            border-color: transparent #fff transparent transparent;
        }
        .right::after {
            left: -16px;
        }
        .content {
            padding: 20px 30px;
            background-color: white;
            position: relative;
            border-radius: 6px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
        .tracking-status {
            font-size: 1.5rem;
            margin-bottom: 20px;
            padding: 10px 20px;
            border-radius: 5px;
        }
        
        /* Notification styles */
        .notification {
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 1050;
            opacity: 0;
            transform: translateY(-20px);
            transition: all 0.3s ease-in-out;
            max-width: 350px;
        }
        
        .notification.show {
            opacity: 1;
            transform: translateY(0);
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
        
        /* Location simulation panel */
        #simulationPanel {
            margin-top: 20px;
            display: none;
        }
    </style>
</head>
<body>
    <jsp:include page="../layout/header.jsp" />
    
    <div class="container py-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1><i class="fas fa-map-marker-alt me-2"></i>Shipment Tracking</h1>
            <a href="/admin/shipments" class="btn btn-outline-primary">
                <i class="fas fa-arrow-left me-2"></i>Back to Shipments
            </a>
        </div>
        
        <div class="row">
            <div class="col-md-8">
                <div class="card mb-4">
                    <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
                        <h5 class="mb-0">Location Tracking</h5>
                        <button id="toggleSimulationBtn" class="btn btn-sm btn-light">
                            <i class="fas fa-truck me-1"></i> Simulate Movement
                        </button>
                    </div>
                    <div class="card-body">
                        <div id="map"></div>
                        <div class="alert alert-primary text-center" role="alert" id="locationInfo">
                            <c:choose>
                                <c:when test="${latestLocation != null}">
                                    <strong>Last Updated:</strong> <span id="lastUpdated">${latestLocation.timestamp}</span>
                                </c:when>
                                <c:otherwise>
                                    No location data available yet.
                                </c:otherwise>
                            </c:choose>
                        </div>
                        
                        <!-- Location Simulation Panel -->
                        <div id="simulationPanel" class="card">
                            <div class="card-header bg-light">
                                <h5 class="mb-0">Location Simulation</h5>
                            </div>
                            <div class="card-body">
                                <div class="mb-3">
                                    <label class="form-label">Simulation Speed</label>
                                    <select id="simulationSpeed" class="form-select">
                                        <option value="slow">Slow</option>
                                        <option value="medium" selected>Medium</option>
                                        <option value="fast">Fast</option>
                                    </select>
                                </div>
                                <div class="d-flex gap-2">
                                    <button id="startSimulationBtn" class="btn btn-primary">
                                        <i class="fas fa-play me-1"></i> Start
                                    </button>
                                    <button id="pauseSimulationBtn" class="btn btn-warning" disabled>
                                        <i class="fas fa-pause me-1"></i> Pause
                                    </button>
                                    <button id="stopSimulationBtn" class="btn btn-danger" disabled>
                                        <i class="fas fa-stop me-1"></i> Stop
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="card">
                    <div class="card-header bg-info text-white">
                        <h5 class="mb-0">Shipment Timeline</h5>
                    </div>
                    <div class="card-body">
                        <div class="timeline">
                            <div class="container-timeline left">
                                <div class="content">
                                    <h2>Order Created</h2>
                                    <p><c:if test="${not empty shipment.createdAt}">
                                        ${shipment.createdAt}
                                    </c:if></p>
                                    <p>Shipment #${shipment.trackingNumber} was created by ${shipment.shipper.name}</p>
                                </div>
                            </div>
                            <c:if test="${shipment.status != 'PENDING'}">
                                <div class="container-timeline right">
                                    <div class="content">
                                        <h2>Driver Assigned</h2>
                                        <p><c:if test="${not empty shipment.updatedAt}">
                                            ${shipment.updatedAt}
                                        </c:if></p>
                                        <p>Driver ${shipment.driver.name} has been assigned to this shipment</p>
                                    </div>
                                </div>
                            </c:if>
                            <c:if test="${shipment.status == 'PICKED_UP' || shipment.status == 'IN_TRANSIT' || shipment.status == 'DELIVERED'}">
                                <div class="container-timeline left">
                                    <div class="content">
                                        <h2>Picked Up</h2>
                                        <p><c:if test="${not empty shipment.pickupTime}">
                                            ${shipment.pickupTime}
                                        </c:if></p>
                                        <p>Package has been picked up from ${shipment.pickupAddress}</p>
                                    </div>
                                </div>
                            </c:if>
                            <c:if test="${shipment.status == 'DELIVERED'}">
                                <div class="container-timeline right">
                                    <div class="content">
                                        <h2>Delivered</h2>
                                        <p><c:if test="${not empty shipment.deliveryTime}">
                                            ${shipment.deliveryTime}
                                        </c:if></p>
                                        <p>Package has been delivered to ${shipment.deliveryAddress}</p>
                                    </div>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="col-md-4">
                <div class="card mb-4">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0">Shipment Details</h5>
                    </div>
                    <div class="card-body">
                        <div class="tracking-status ${shipment.status == 'DELIVERED' ? 'bg-success text-white' : 
                            shipment.status == 'IN_TRANSIT' ? 'bg-warning' : 
                            shipment.status == 'PICKED_UP' ? 'bg-info text-white' : 'bg-primary text-white'}" id="statusDisplay">
                            Status: <span id="shipmentStatus">${shipment.status}</span>
                        </div>
                        <dl class="row">
                            <dt class="col-sm-5">Tracking Number:</dt>
                            <dd class="col-sm-7">${shipment.trackingNumber}</dd>
                            
                            <dt class="col-sm-5">Goods Type:</dt>
                            <dd class="col-sm-7">${shipment.goodsType}</dd>
                            
                            <dt class="col-sm-5">Weight:</dt>
                            <dd class="col-sm-7">${shipment.weight} kg</dd>
                            
                            <dt class="col-sm-5">Price:</dt>
                            <dd class="col-sm-7">₹${shipment.price}</dd>
                            
                            <dt class="col-sm-5">Origin:</dt>
                            <dd class="col-sm-7">${shipment.pickupAddress}</dd>
                            
                            <dt class="col-sm-5">Destination:</dt>
                            <dd class="col-sm-7">${shipment.deliveryAddress}</dd>
                            
                            <dt class="col-sm-5">Shipper:</dt>
                            <dd class="col-sm-7">${shipment.shipper.name}</dd>
                            
                            <dt class="col-sm-5">Driver:</dt>
                            <dd class="col-sm-7">${shipment.driver != null ? shipment.driver.name : 'Not assigned yet'}</dd>
                        </dl>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Notification Template -->
    <div id="notification" class="notification toast align-items-center text-white bg-primary border-0" role="alert" aria-live="assertive" aria-atomic="true">
        <div class="d-flex">
            <div class="toast-body">
                <i class="fas fa-info-circle me-2"></i>
                <span id="notification-message"></span>
            </div>
            <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
        </div>
    </div>
    
    <jsp:include page="../layout/footer.jsp" />
    
    <!-- Load jQuery first, before other scripts -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.5.1/sockjs.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
    
    <!-- Initialize websocket before map -->
    <script>
        // Global variables
        const shipmentId = ${shipment.id};
        let map;
        let originMarker;
        let destinationMarker;
        let currentLocationMarker;
        let directionsService;
        let directionsRenderer;
        let simulationInterval;
        let simulationPath = [];
        let currentPathIndex = 0;
        let isSimulating = false;
        let stompClient = null;
        
        // Initialize WebSocket connection immediately
        $(document).ready(function() {
            connectWebSocket();
            
            // Setup simulation UI events
            setupSimulationEvents();
        });
        
        // WebSocket functions
        function connectWebSocket() {
            if (stompClient && stompClient.connected) {
                console.log('Already connected to WebSocket');
                return;
            }
            
            console.log('Attempting to connect to WebSocket...');
            const socket = new SockJS('/ws');
            stompClient = Stomp.over(socket);
            
            // Disable debug logging
            stompClient.debug = null;
            
            stompClient.connect({}, function(frame) {
                console.log('Connected to WebSocket: ' + frame);
                
                // Subscribe to general shipment updates
                stompClient.subscribe('/topic/shipments', function(message) {
                    console.log('Received shipment update:', message);
                    const data = JSON.parse(message.body);
                    if (data.shipmentId === shipmentId) {
                        updateShipmentStatus(data);
                    }
                });
                
                // Subscribe to admin-specific updates
                stompClient.subscribe('/topic/admin/locations', function(message) {
                    console.log('Received location update:', message);
                    const locationData = JSON.parse(message.body);
                    if (locationData.shipmentId === shipmentId) {
                        updateLocationOnMap(locationData);
                    }
                });
                
                showNotification('WebSocket connection established');
            }, function(error) {
                console.error('WebSocket connection error:', error);
                setTimeout(connectWebSocket, 5000); // Try to reconnect after 5 seconds
            });
        }
        
        function setupSimulationEvents() {
            console.log('Setting up simulation events');
            // Toggle simulation panel
            document.getElementById('toggleSimulationBtn').addEventListener('click', function() {
                const panel = document.getElementById('simulationPanel');
                console.log('Toggle simulation panel button clicked');
                if (panel.style.display === 'block') {
                    panel.style.display = 'none';
                } else {
                    panel.style.display = 'block';
                }
            });
            
            // Start simulation
            document.getElementById('startSimulationBtn').addEventListener('click', function() {
                console.log('Start simulation button clicked');
                startSimulation();
                this.disabled = true;
                document.getElementById('pauseSimulationBtn').disabled = false;
                document.getElementById('stopSimulationBtn').disabled = false;
            });
            
            // Pause simulation
            document.getElementById('pauseSimulationBtn').addEventListener('click', function() {
                pauseSimulation();
                this.disabled = true;
                document.getElementById('startSimulationBtn').disabled = false;
            });
            
            // Stop simulation
            document.getElementById('stopSimulationBtn').addEventListener('click', function() {
                stopSimulation();
                this.disabled = true;
                document.getElementById('pauseSimulationBtn').disabled = true;
                document.getElementById('startSimulationBtn').disabled = false;
            });
        }
    </script>
    
    <!-- Load Google Maps API last -->
    <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBoQ6FN55NtAUucLWKMDW5s1CricaJ8UdE&callback=initMap" async defer></script>
    
    <script>
        function updateShipmentStatus(data) {
            const statusDisplay = document.getElementById('shipmentStatus');
            const statusContainer = document.getElementById('statusDisplay');
            
            if (statusDisplay && data.status) {
                statusDisplay.textContent = data.status;
                
                // Update status class
                statusContainer.className = 'tracking-status';
                
                if (data.status === 'DELIVERED') {
                    statusContainer.classList.add('bg-success', 'text-white');
                } else if (data.status === 'IN_TRANSIT') {
                    statusContainer.classList.add('bg-warning');
                } else if (data.status === 'PICKED_UP') {
                    statusContainer.classList.add('bg-info', 'text-white');
                } else {
                    statusContainer.classList.add('bg-primary', 'text-white');
                }
                
                showNotification('Shipment status updated to: ' + data.status);
            }
        }
        
        function updateLocationOnMap(data) {
            const locationInfo = document.getElementById('locationInfo');
            
            // Update last updated time
            if (data.timestamp) {
                document.getElementById('lastUpdated').textContent = data.timestamp;
            }
            
            // Update or create current location marker
            const position = {
                lat: Number(data.latitude),
                lng: Number(data.longitude)
            };
            
            if (currentLocationMarker) {
                currentLocationMarker.setPosition(position);
            } else {
                currentLocationMarker = new google.maps.Marker({
                    position: position,
                    map: map,
                    title: "Current Location",
                    icon: "http://maps.google.com/mapfiles/ms/icons/blue-dot.png",
                    animation: google.maps.Animation.DROP
                });
            }
            
            // Center map on current location
            map.panTo(position);
            
            // Show notification
            showNotification('Location updated');
            
            // Highlight the info box
            locationInfo.classList.add('highlight-pulse');
            setTimeout(() => {
                locationInfo.classList.remove('highlight-pulse');
            }, 2000);
        }
        
        function sendSimulatedLocation(latitude, longitude) {
            if (!stompClient || !stompClient.connected) {
                console.error('WebSocket not connected');
                showNotification('Error: WebSocket not connected');
                connectWebSocket(); // Try to reconnect
                return;
            }
            
            const token = $("meta[name='_csrf']").attr("content");
            const header = $("meta[name='_csrf_header']").attr("content");
            
            console.log('Sending simulated location data:', {
                shipmentId: shipmentId,
                latitude: latitude,
                longitude: longitude,
                timestamp: new Date().toLocaleString(),
                simulatedBy: 'admin',
                token: token,
                header: header
            });
            
            const locationData = {
                shipmentId: shipmentId,
                latitude: latitude,
                longitude: longitude,
                timestamp: new Date().toLocaleString(),
                simulatedBy: 'admin'
            };
            
            try {
                // Send to backend through WebSocket
                stompClient.send("/app/location", {
                    [header]: token
                }, JSON.stringify(locationData));
                
                console.log('Location data sent successfully');
            } catch (error) {
                console.error('Error sending location data:', error);
                showNotification('Error sending location data: ' + error.message);
            }
        }
        
        function showNotification(message) {
            const notification = document.getElementById('notification');
            const messageEl = document.getElementById('notification-message');
            
            messageEl.textContent = message;
            
            // Create a Bootstrap toast instance and show it
            const toast = new bootstrap.Toast(notification, {
                autohide: true,
                delay: 3000
            });
            
            toast.show();
        }
        
        function initMap() {
            console.log('Initializing map...');
            // Default center point if nothing else is available
            let defaultCenter = {lat: 20.5937, lng: 78.9629}; // Default to center of India
            
            // Try to determine the best map center
            let mapCenter = defaultCenter;
            
            // Check if origin coordinates are available
            let hasOrigin = ${shipment.pickupLatitude != null && shipment.pickupLongitude != null};
            let hasDestination = ${shipment.deliveryLatitude != null && shipment.deliveryLongitude != null};
            let hasCurrentLocation = ${latestLocation != null};
            
            // Set center based on priority: current location > origin > destination > default
            if (hasCurrentLocation) {
                mapCenter = {
                    lat: ${latestLocation.latitude},
                    lng: ${latestLocation.longitude}
                };
            } else if (hasOrigin) {
                mapCenter = {
                    lat: ${shipment.pickupLatitude},
                    lng: ${shipment.pickupLongitude}
                };
            } else if (hasDestination) {
                mapCenter = {
                    lat: ${shipment.deliveryLatitude},
                    lng: ${shipment.deliveryLongitude}
                };
            }
            
            // Create map
            map = new google.maps.Map(document.getElementById("map"), {
                zoom: 10,
                center: mapCenter,
            });
            
            // Setup directions services
            directionsService = new google.maps.DirectionsService();
            directionsRenderer = new google.maps.DirectionsRenderer({
                suppressMarkers: true, // Don't show A, B markers as we already have custom markers
                polylineOptions: {
                    strokeColor: '#007bff',
                    strokeWeight: 5
                }
            });
            
            directionsRenderer.setMap(map);
            
            // Create markers
            if (hasOrigin) {
                try {
                    originMarker = new google.maps.Marker({
                        position: { 
                            lat: Number(${shipment.pickupLatitude}), 
                            lng: Number(${shipment.pickupLongitude}) 
                        },
                        map,
                        title: "Pickup Location: ${shipment.pickupAddress}",
                        icon: "http://maps.google.com/mapfiles/ms/icons/green-dot.png"
                    });
                } catch (e) {
                    console.error("Error creating origin marker:", e);
                }
            }
            
            if (hasDestination) {
                try {
                    destinationMarker = new google.maps.Marker({
                        position: { 
                            lat: Number(${shipment.deliveryLatitude}), 
                            lng: Number(${shipment.deliveryLongitude}) 
                        },
                        map,
                        title: "Delivery Location: ${shipment.deliveryAddress}",
                        icon: "http://maps.google.com/mapfiles/ms/icons/red-dot.png"
                    });
                } catch (e) {
                    console.error("Error creating destination marker:", e);
                }
            }
            
            if (hasCurrentLocation) {
                try {
                    currentLocationMarker = new google.maps.Marker({
                        position: { 
                            lat: Number(${latestLocation.latitude}), 
                            lng: Number(${latestLocation.longitude}) 
                        },
                        map,
                        title: "Current Location",
                        icon: "http://maps.google.com/mapfiles/ms/icons/blue-dot.png"
                    });
                } catch (e) {
                    console.error("Error creating current location marker:", e);
                }
            }
            
            // If we have both origin and destination, draw a route line and generate simulation path
            if (hasOrigin && hasDestination) {
                calculateAndDisplayRoute();
            }
        }
        
        function calculateAndDisplayRoute() {
            const origin = { 
                lat: Number(${shipment.pickupLatitude}), 
                lng: Number(${shipment.pickupLongitude})
            };
            
            const destination = { 
                lat: Number(${shipment.deliveryLatitude}), 
                lng: Number(${shipment.deliveryLongitude})
            };
            
            console.log('Calculating route from:', origin, 'to:', destination);
            
            directionsService.route({
                origin: origin,
                destination: destination,
                travelMode: google.maps.TravelMode.DRIVING
            })
            .then((response) => {
                console.log('Route calculation successful:', response);
                directionsRenderer.setDirections(response);
                
                // Extract the path points for simulation
                const route = response.routes[0];
                const path = route.overview_path;
                simulationPath = path.map(point => ({
                    lat: point.lat(),
                    lng: point.lng()
                }));
                
                console.log('Simulation path generated with', simulationPath.length, 'points');
            })
            .catch((e) => {
                console.error("Directions request failed:", e);
                // Create a simple straight line for the simulation if directions fail
                simulationPath = [
                    origin,
                    {
                        lat: (origin.lat + destination.lat) / 2,
                        lng: (origin.lng + destination.lng) / 2
                    },
                    destination
                ];
                console.log('Using fallback simulation path with 3 points');
            });
        }
        
        function startSimulation() {
            if (simulationPath.length === 0) {
                console.error('No simulation path available');
                showNotification('Error: No route available for simulation');
                return;
            }
            
            console.log('Starting simulation with path of', simulationPath.length, 'points');
            
            if (isSimulating) {
                console.log('Simulation already in progress');
                return;
            }
            
            isSimulating = true;
            
            // If simulation was paused, continue from current position
            // Otherwise start from beginning
            if (currentPathIndex === 0) {
                // Start from origin
                currentPathIndex = 0;
                console.log('Starting simulation from beginning');
            } else {
                console.log('Resuming simulation from index', currentPathIndex);
            }
            
            // Get simulation speed
            const speed = document.getElementById('simulationSpeed').value;
            let interval;
            
            switch (speed) {
                case 'slow':
                    interval = 3000; // Update every 3 seconds
                    break;
                case 'fast':
                    interval = 1000; // Update every 1 second
                    break;
                case 'medium':
                default:
                    interval = 2000; // Update every 2 seconds
            }
            
            console.log('Simulation speed:', speed, 'with interval:', interval, 'ms');
            
            // Start simulation interval
            simulationInterval = setInterval(() => {
                if (currentPathIndex < simulationPath.length) {
                    const position = simulationPath[currentPathIndex];
                    console.log('Simulation step', currentPathIndex + 1, 'of', simulationPath.length, 'position:', position);
                    
                    // Update map marker
                    if (currentLocationMarker) {
                        currentLocationMarker.setPosition(position);
                    } else {
                        currentLocationMarker = new google.maps.Marker({
                            position: position,
                            map: map,
                            title: "Current Location",
                            icon: "http://maps.google.com/mapfiles/ms/icons/blue-dot.png"
                        });
                    }
                    
                    // Send location update via WebSocket
                    sendSimulatedLocation(position.lat, position.lng);
                    
                    // Increment counter
                    currentPathIndex++;
                } else {
                    // End of route reached
                    console.log('Simulation complete - reached end of route');
                    stopSimulation();
                    showNotification('Simulation complete - vehicle has reached destination');
                    
                    // Reset buttons
                    document.getElementById('startSimulationBtn').disabled = false;
                    document.getElementById('pauseSimulationBtn').disabled = true;
                    document.getElementById('stopSimulationBtn').disabled = true;
                }
            }, interval);
            
            showNotification('Simulation started');
        }
        
        function pauseSimulation() {
            if (!isSimulating) return;
            
            clearInterval(simulationInterval);
            isSimulating = false;
            showNotification('Simulation paused');
        }
        
        function stopSimulation() {
            if (simulationInterval) {
                clearInterval(simulationInterval);
            }
            
            isSimulating = false;
            currentPathIndex = 0;
            
            // Reset location marker to origin
            if (currentLocationMarker && originMarker) {
                currentLocationMarker.setPosition(originMarker.getPosition());
            }
            
            showNotification('Simulation stopped');
        }
    </script>
</body>
</html> 