// WebSocket connection for real-time updates
let stompClient = null;
let currentUserId = null;
let currentUserRole = null;

// Initialize WebSocket connection
function connectWebSocket(userId, userRole) {
    currentUserId = userId;
    currentUserRole = userRole;
    
    const socket = new SockJS('/ws');
    stompClient = Stomp.over(socket);
    
    stompClient.connect({}, function(frame) {
        console.log('Connected to WebSocket: ' + frame);
        
        // Subscribe to global shipment updates
        stompClient.subscribe('/topic/shipments', function(message) {
            handleShipmentUpdate(JSON.parse(message.body));
        });
        
        // Subscribe to role-specific topics
        if (userRole === 'ROLE_ADMIN') {
            // Admin subscribes to all interest updates
            stompClient.subscribe('/topic/admin/interests', function(message) {
                handleInterestUpdate(JSON.parse(message.body));
            });
        } else if (userRole === 'ROLE_SHIPPER') {
            // Shipper subscribes to their specific updates
            stompClient.subscribe('/topic/shipper/' + userId, function(message) {
                const data = JSON.parse(message.body);
                if (data.type === 'INTEREST_UPDATE') {
                    handleInterestUpdate(data);
                } else if (data.type === 'SHIPMENT_UPDATE') {
                    handleShipmentUpdate(data);
                }
            });
        } else if (userRole === 'ROLE_DRIVER') {
            // Driver subscribes to their specific updates
            stompClient.subscribe('/topic/driver/' + userId, function(message) {
                const data = JSON.parse(message.body);
                if (data.type === 'INTEREST_UPDATE') {
                    handleInterestUpdate(data);
                } else if (data.type === 'SHIPMENT_UPDATE') {
                    handleShipmentUpdate(data);
                }
            });
        }
    }, function(error) {
        console.error('Error connecting to WebSocket: ', error);
        // Try to reconnect after 5 seconds
        setTimeout(function() {
            connectWebSocket(userId, userRole);
        }, 5000);
    });
}

// Handle shipment status updates
function handleShipmentUpdate(data) {
    console.log('Received shipment update:', data);
    
    // Update UI based on user role
    if (currentUserRole === 'ROLE_ADMIN') {
        updateAdminShipmentDisplay(data);
    } else if (currentUserRole === 'ROLE_SHIPPER') {
        updateShipperShipmentDisplay(data);
    } else if (currentUserRole === 'ROLE_DRIVER') {
        updateDriverShipmentDisplay(data);
    }
    
    // Show notification toast
    showNotification('Shipment Update', 'Shipment #' + data.shipmentId + ' status updated to ' + data.status);
}

// Handle driver interest updates
function handleInterestUpdate(data) {
    console.log('Received interest update:', data);
    
    // Update UI based on user role
    if (currentUserRole === 'ROLE_ADMIN') {
        updateAdminInterestDisplay(data);
    } else if (currentUserRole === 'ROLE_SHIPPER') {
        updateShipperInterestDisplay(data);
    } else if (currentUserRole === 'ROLE_DRIVER') {
        updateDriverInterestDisplay(data);
    }
    
    // Show notification toast
    showNotification('Interest Update', 'Driver interest for shipment #' + data.shipmentId + ' updated to ' + data.status);
}

// Admin UI updates
function updateAdminShipmentDisplay(data) {
    const shipmentRow = document.querySelector('#shipment-' + data.shipmentId);
    if (shipmentRow) {
        const statusCell = shipmentRow.querySelector('.shipment-status');
        if (statusCell) {
            statusCell.textContent = data.status;
            // Highlight the row to indicate a change
            shipmentRow.classList.add('bg-light');
            setTimeout(() => shipmentRow.classList.remove('bg-light'), 3000);
        }
    }
}

function updateAdminInterestDisplay(data) {
    // Refresh the interests list for this shipment if it's currently displayed
    const interestsList = document.querySelector('#shipment-interests-' + data.shipmentId);
    if (interestsList) {
        // In a real implementation, we would update just the relevant interest
        // For simplicity, we'll just reload the entire section
        window.location.reload();
    }
}

// Shipper UI updates
function updateShipperShipmentDisplay(data) {
    const shipmentRow = document.querySelector('#shipment-' + data.shipmentId);
    if (shipmentRow) {
        const statusCell = shipmentRow.querySelector('.shipment-status');
        if (statusCell) {
            statusCell.textContent = data.status;
            // Highlight the row to indicate a change
            shipmentRow.classList.add('bg-light');
            setTimeout(() => shipmentRow.classList.remove('bg-light'), 3000);
        }
    }
}

function updateShipperInterestDisplay(data) {
    // If we're on the shipment details page with interests displayed
    const interestsList = document.querySelector('#shipment-interests');
    if (interestsList) {
        // In a real implementation, we would update just the relevant interest
        // For simplicity, we'll just reload the page
        window.location.reload();
    }
}

// Driver UI updates
function updateDriverShipmentDisplay(data) {
    // Update assigned shipments or available shipments
    if (data.status === 'ASSIGNED') {
        // If this shipment was just assigned to the current driver, refresh to show it
        window.location.reload();
    } else {
        // Otherwise just update the status if it's visible
        const shipmentElement = document.querySelector('#shipment-' + data.shipmentId);
        if (shipmentElement) {
            const statusElement = shipmentElement.querySelector('.shipment-status');
            if (statusElement) {
                statusElement.textContent = data.status;
                // Highlight the element to indicate a change
                shipmentElement.classList.add('bg-light');
                setTimeout(() => shipmentElement.classList.remove('bg-light'), 3000);
            }
        }
    }
}

function updateDriverInterestDisplay(data) {
    // Update the UI based on interest status
    const interestElement = document.querySelector('#interest-' + data.interestId);
    if (interestElement) {
        if (data.status === 'ACCEPTED') {
            interestElement.classList.add('border-success');
            interestElement.querySelector('.interest-status').textContent = 'Accepted';
        } else if (data.status === 'REJECTED') {
            interestElement.classList.add('border-danger');
            interestElement.querySelector('.interest-status').textContent = 'Rejected';
        }
    }
    
    // If this interest was accepted, the shipment list should be refreshed
    if (data.status === 'ACCEPTED') {
        window.location.reload();
    }
}

// Show a notification toast
function showNotification(title, message) {
    // Check if toast container exists, if not create it
    let toastContainer = document.querySelector('.toast-container');
    if (!toastContainer) {
        toastContainer = document.createElement('div');
        toastContainer.className = 'toast-container position-fixed bottom-0 end-0 p-3';
        document.body.appendChild(toastContainer);
    }
    
    // Create a new toast
    const toastId = 'toast-' + Date.now();
    const toastHtml = `
        <div id="${toastId}" class="toast" role="alert" aria-live="assertive" aria-atomic="true">
            <div class="toast-header">
                <strong class="me-auto">${title}</strong>
                <small>Just now</small>
                <button type="button" class="btn-close" data-bs-dismiss="toast" aria-label="Close"></button>
            </div>
            <div class="toast-body">
                ${message}
            </div>
        </div>
    `;
    
    toastContainer.insertAdjacentHTML('beforeend', toastHtml);
    
    // Initialize and show the toast
    const toast = new bootstrap.Toast(document.getElementById(toastId));
    toast.show();
    
    // Remove toast after it's hidden
    document.getElementById(toastId).addEventListener('hidden.bs.toast', function() {
        this.remove();
    });
}

// Disconnect WebSocket when page unloads
window.addEventListener('beforeunload', function() {
    if (stompClient !== null) {
        stompClient.disconnect();
    }
}); 