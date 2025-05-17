// WebSocket connection for real-time updates
let stompClient = null;
let currentUserId = null;
let currentUserRole = null;
let reconnectAttempts = 0;
const MAX_RECONNECT_ATTEMPTS = 5;

// Initialize WebSocket connection
function connectWebSocket(userId, userRole) {
    if (stompClient !== null) {
        console.log('WebSocket connection already exists');
        return;
    }

    currentUserId = userId;
    currentUserRole = userRole;
    
    console.log('Connecting WebSocket with userId:', userId, 'and role:', userRole);
    
    try {
        const socket = new SockJS('/ws');
        stompClient = Stomp.over(socket);
        
        // Disable debug logging
        stompClient.debug = null;
        
        const connectCallback = function(frame) {
            console.log('Connected to WebSocket');
            reconnectAttempts = 0; // Reset reconnect attempts on successful connection
            
            // Subscribe to global shipment updates
            stompClient.subscribe('/topic/shipments', function(message) {
                try {
                    const data = JSON.parse(message.body);
                    console.log('Received global shipment update:', data);
                    handleShipmentUpdate(data);
                } catch (error) {
                    console.error('Error processing shipment update:', error);
                }
            });
            
            // Subscribe to global location updates
            stompClient.subscribe('/topic/shipments/locations', function(message) {
                try {
                    const data = JSON.parse(message.body);
                    console.log('Received location update:', data);
                    handleLocationUpdate(data);
                } catch (error) {
                    console.error('Error processing location update:', error);
                }
            });
            
            // Role-specific subscriptions
            if (userRole === 'ROLE_ADMIN') {
                subscribeToAdminTopics();
            } else if (userRole === 'ROLE_SHIPPER') {
                subscribeToShipperTopics(userId);
            } else if (userRole === 'ROLE_DRIVER') {
                subscribeToDriverTopics(userId);
            }
        };
        
        const errorCallback = function(error) {
            console.error('WebSocket connection error:', error);
            handleReconnection();
        };
        
        // Connect with heartbeat
        stompClient.connect({}, connectCallback, errorCallback);
        
    } catch (error) {
        console.error('Error initializing WebSocket:', error);
        handleReconnection();
    }
}

function handleReconnection() {
    if (stompClient !== null) {
        try {
            stompClient.disconnect();
        } catch (error) {
            console.error('Error disconnecting:', error);
        }
        stompClient = null;
    }
    
    if (reconnectAttempts < MAX_RECONNECT_ATTEMPTS) {
        reconnectAttempts++;
        const timeout = Math.min(1000 * Math.pow(2, reconnectAttempts), 30000);
        console.log(`Attempting to reconnect in ${timeout/1000} seconds... (Attempt ${reconnectAttempts}/${MAX_RECONNECT_ATTEMPTS})`);
        
        setTimeout(() => {
            connectWebSocket(currentUserId, currentUserRole);
        }, timeout);
    } else {
        console.error('Max reconnection attempts reached');
        showNotification('Connection Error', 'Unable to establish WebSocket connection. Please refresh the page.', 'error');
    }
}

function subscribeToAdminTopics() {
    // Admin subscribes to all interest updates
    stompClient.subscribe('/topic/admin/interests', function(message) {
        try {
            const data = JSON.parse(message.body);
            console.log('Received admin interest update:', data);
            handleInterestUpdate(data);
        } catch (error) {
            console.error('Error processing admin interest update:', error);
        }
    });
    
    // Admin subscribes to location updates
    stompClient.subscribe('/topic/admin/locations', function(message) {
        try {
            const data = JSON.parse(message.body);
            console.log('Received admin location update:', data);
            handleLocationUpdate(data);
        } catch (error) {
            console.error('Error processing admin location update:', error);
        }
    });
}

function subscribeToShipperTopics(shipperId) {
    // Shipper subscribes to their specific updates
    stompClient.subscribe('/topic/shipper/' + shipperId, function(message) {
        try {
            const data = JSON.parse(message.body);
            console.log('Received shipper update:', data);
            if (data.type === 'INTEREST_UPDATE') {
                handleInterestUpdate(data);
            } else if (data.type === 'SHIPMENT_UPDATE') {
                handleShipmentUpdate(data);
            }
        } catch (error) {
            console.error('Error processing shipper update:', error);
        }
    });
    
    // Shipper subscribes to location updates
    stompClient.subscribe('/topic/shipper/' + shipperId + '/locations', function(message) {
        try {
            const data = JSON.parse(message.body);
            console.log('Received shipper location update:', data);
            handleLocationUpdate(data);
        } catch (error) {
            console.error('Error processing shipper location update:', error);
        }
    });
}

function subscribeToDriverTopics(driverId) {
    // Driver subscribes to their specific updates
    stompClient.subscribe('/topic/driver/' + driverId, function(message) {
        try {
            const data = JSON.parse(message.body);
            console.log('Received driver update:', data);
            if (data.type === 'INTEREST_UPDATE') {
                handleInterestUpdate(data);
            } else if (data.type === 'SHIPMENT_UPDATE') {
                handleShipmentUpdate(data);
            }
        } catch (error) {
            console.error('Error processing driver update:', error);
        }
    });
    
    // Driver subscribes to location updates
    stompClient.subscribe('/topic/driver/' + driverId + '/locations', function(message) {
        try {
            const data = JSON.parse(message.body);
            console.log('Received driver location update:', data);
            handleLocationUpdate(data);
        } catch (error) {
            console.error('Error processing driver location update:', error);
        }
    });
}

// Handler for shipment status updates
function handleShipmentUpdate(data) {
    if (data.type !== 'SHIPMENT_UPDATE') return;
    
    console.log('Processing shipment update:', data);
    
    // Check if there's a handler function defined in the page
    if (typeof window.updateShipmentDisplay === 'function') {
        window.updateShipmentDisplay(data);
    } else {
        console.log('No updateShipmentDisplay handler found in this page');
        
        // Default handler - update status badges and refresh page if needed
        const statusElements = document.querySelectorAll(`[data-shipment-id="${data.shipmentId}"] .status-badge`);
        
        if (statusElements.length > 0) {
            statusElements.forEach(element => {
                element.textContent = data.status;
                element.className = 'badge status-badge';
                
                if (data.status === 'DELIVERED') {
                    element.classList.add('bg-success');
                } else if (data.status === 'IN_TRANSIT') {
                    element.classList.add('bg-warning', 'text-dark');
                } else if (data.status === 'PICKED_UP') {
                    element.classList.add('bg-info');
                } else {
                    element.classList.add('bg-primary');
                }
            });
            
            // Highlight the row
            const row = document.querySelector(`[data-shipment-id="${data.shipmentId}"]`);
            if (row) {
                row.classList.add('highlight-pulse');
                setTimeout(() => {
                    row.classList.remove('highlight-pulse');
                }, 2000);
            }
            
            // Show notification
            showNotification(
                'Shipment Updated', 
                `Shipment #${data.shipmentId} status changed to ${data.status}`,
                'info'
            );
        }
    }
}

// Handler for interest updates
function handleInterestUpdate(data) {
    if (data.type !== 'INTEREST_UPDATE') return;
    
    console.log('Processing interest update:', data);
    
    // Check if there's a handler function defined in the page
    if (typeof window.updateDriverInterestDisplay === 'function') {
        window.updateDriverInterestDisplay(data);
    } else {
        console.log('No updateDriverInterestDisplay handler found in this page');
    }
}

// Handler for location updates
function handleLocationUpdate(data) {
    if (data.type !== 'LOCATION_UPDATE') return;
    
    console.log('Processing location update:', data);
    
    // Check if there's a handler function defined in the page
    if (typeof window.updateLocationDisplay === 'function') {
        window.updateLocationDisplay(data);
    } else {
        console.log('No updateLocationDisplay handler found in this page');
        
        // If we're on a tracking page for this specific shipment
        const trackingMap = document.getElementById('map');
        if (trackingMap && window.currentShipmentId === data.shipmentId) {
            // If map exists and window.map is defined (Google Maps instance)
            if (window.map && window.updateLocationOnMap) {
                window.updateLocationOnMap(data);
            }
        }
    }
}

// Show notification
function showNotification(title, message, type = 'primary') {
    console.log(`Notification (${type}): ${title} - ${message}`);
    
    // Check if function exists in the page
    if (typeof window.showCustomNotification === 'function') {
        window.showCustomNotification(title, message, type);
        return;
    }
    
    // Check if we have a Bootstrap toast container
    let toastContainer = document.getElementById('toast-container');
    
    // If not, create one
    if (!toastContainer) {
        toastContainer = document.createElement('div');
        toastContainer.id = 'toast-container';
        toastContainer.className = 'toast-container position-fixed top-0 end-0 p-3';
        toastContainer.style.zIndex = '1070';
        document.body.appendChild(toastContainer);
    }
    
    // Create toast element
    const toast = document.createElement('div');
    toast.className = `toast align-items-center text-white bg-${type} border-0`;
    toast.setAttribute('role', 'alert');
    toast.setAttribute('aria-live', 'assertive');
    toast.setAttribute('aria-atomic', 'true');
    
    const toastContent = `
        <div class="d-flex">
            <div class="toast-body">
                <strong>${title}</strong> ${message}
            </div>
            <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
        </div>
    `;
    
    toast.innerHTML = toastContent;
    toastContainer.appendChild(toast);
    
    // Initialize and show Bootstrap toast
    const bsToast = new bootstrap.Toast(toast, {
        autohide: true,
        delay: 5000
    });
    
    bsToast.show();
    
    // Remove from DOM after hiding
    toast.addEventListener('hidden.bs.toast', function () {
        toast.remove();
    });
}

// Disconnect WebSocket when page unloads
window.addEventListener('beforeunload', function() {
    if (stompClient !== null) {
        stompClient.disconnect();
    }
}); 