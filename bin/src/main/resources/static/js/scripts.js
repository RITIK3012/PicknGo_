$(document).ready(function() {
    // Bootstrap form validation
    (function() {
        'use strict';
        window.addEventListener('load', function() {
            // Fetch all the forms we want to apply custom Bootstrap validation styles to
            var forms = document.getElementsByClassName('needs-validation');
            // Loop over them and prevent submission
            var validation = Array.prototype.filter.call(forms, function(form) {
                form.addEventListener('submit', function(event) {
                    if (form.checkValidity() === false) {
                        event.preventDefault();
                        event.stopPropagation();
                    }
                    form.classList.add('was-validated');
                }, false);
            });
        }, false);
    })();

    // Password visibility toggle
    $('.password-toggle').on('click', function() {
        const passwordField = $(this).siblings('input');
        const passwordFieldType = passwordField.attr('type');
        
        if (passwordFieldType === 'password') {
            passwordField.attr('type', 'text');
            $(this).html('<i class="fa fa-eye-slash"></i>');
        } else {
            passwordField.attr('type', 'password');
            $(this).html('<i class="fa fa-eye"></i>');
        }
    });

    // Initialize tooltips
    var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
        return new bootstrap.Tooltip(tooltipTriggerEl);
    });
    
    // Initialize map for tracking if element exists
    if (document.getElementById('map')) {
        initMap();
    }

    // Status update confirmation
    $('.status-update-form').on('submit', function(e) {
        if (!confirm('Are you sure you want to update this shipment status?')) {
            e.preventDefault();
        }
    });

    // Live search functionality for tables
    $("#searchInput").on("keyup", function() {
        var value = $(this).val().toLowerCase();
        $("#searchTable tbody tr").filter(function() {
            $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1);
        });
    });
});

// Google Maps API initialization for tracking
function initMap() {
    if (typeof google === 'undefined') {
        console.log('Google Maps API not loaded');
        return;
    }
    
    const mapElement = document.getElementById('map');
    
    if (!mapElement) {
        return;
    }
    
    // Default center (India)
    const defaultCenter = { lat: 20.5937, lng: 78.9629 };
    
    // Create map
    const map = new google.maps.Map(mapElement, {
        zoom: 5,
        center: defaultCenter,
    });
    
    // If we have shipment data
    if (typeof shipmentData !== 'undefined') {
        // If we have current location
        if (shipmentData.currentLat && shipmentData.currentLng) {
            const currentPosition = {
                lat: parseFloat(shipmentData.currentLat),
                lng: parseFloat(shipmentData.currentLng)
            };
            
            // Create marker for current position
            const marker = new google.maps.Marker({
                position: currentPosition,
                map: map,
                icon: {
                    url: '/images/truck-icon.png',
                    scaledSize: new google.maps.Size(40, 40)
                },
                title: 'Current Location'
            });
            
            // Center map on current position
            map.setCenter(currentPosition);
            map.setZoom(12);
            
            // Create info window
            const infoWindow = new google.maps.InfoWindow({
                content: `
                    <div>
                        <h6>Shipment #${shipmentData.id}</h6>
                        <p>Status: ${shipmentData.status}</p>
                        <p>Driver: ${shipmentData.driverName}</p>
                    </div>
                `
            });
            
            // Open info window when marker is clicked
            marker.addListener('click', function() {
                infoWindow.open(map, marker);
            });
            
            // Draw route if pickup and delivery coordinates are available
            if (shipmentData.pickupLat && shipmentData.pickupLng && 
                shipmentData.deliveryLat && shipmentData.deliveryLng) {
                
                const pickupPosition = {
                    lat: parseFloat(shipmentData.pickupLat),
                    lng: parseFloat(shipmentData.pickupLng)
                };
                
                const deliveryPosition = {
                    lat: parseFloat(shipmentData.deliveryLat),
                    lng: parseFloat(shipmentData.deliveryLng)
                };
                
                // Add pickup marker
                new google.maps.Marker({
                    position: pickupPosition,
                    map: map,
                    icon: {
                        url: '/images/pickup-icon.png',
                        scaledSize: new google.maps.Size(32, 32)
                    },
                    title: 'Pickup Location'
                });
                
                // Add delivery marker
                new google.maps.Marker({
                    position: deliveryPosition,
                    map: map,
                    icon: {
                        url: '/images/delivery-icon.png',
                        scaledSize: new google.maps.Size(32, 32)
                    },
                    title: 'Delivery Location'
                });
                
                // Draw route
                const directionsService = new google.maps.DirectionsService();
                const directionsRenderer = new google.maps.DirectionsRenderer({
                    map: map,
                    suppressMarkers: true,
                    polylineOptions: {
                        strokeColor: '#0d6efd',
                        strokeWeight: 5
                    }
                });
                
                directionsService.route({
                    origin: pickupPosition,
                    destination: deliveryPosition,
                    travelMode: google.maps.TravelMode.DRIVING
                }, function(response, status) {
                    if (status === 'OK') {
                        directionsRenderer.setDirections(response);
                    } else {
                        console.log('Directions request failed due to ' + status);
                    }
                });
            }
        }
    }
} 