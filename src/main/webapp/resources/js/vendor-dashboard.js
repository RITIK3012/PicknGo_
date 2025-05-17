/**
 * Vendor Dashboard WebSocket and Interactive Features
 */
$(document).ready(function() {
    // CSRF protection for AJAX requests
    const token = $("meta[name='_csrf']").attr("content");
    const header = $("meta[name='_csrf_header']").attr("content");
    
    $(document).ajaxSend(function(e, xhr, options) {
        xhr.setRequestHeader(header, token);
    });
    
    // WebSocket connection setup
    const socket = new SockJS('/ws');
    const stompClient = Stomp.over(socket);
    
    // Get vendor ID from the page
    const vendorId = $('#vendorId').val();
    
    stompClient.connect({}, function(frame) {
        console.log('Connected to WebSocket: ' + frame);
        
        // Subscribe to vendor-specific channel
        if (vendorId) {
            stompClient.subscribe('/topic/vendor/' + vendorId, function(message) {
                handleWebSocketMessage(JSON.parse(message.body));
            });
        }
        
        // Subscribe to global driver assignment channel
        stompClient.subscribe('/topic/driver-assignments', function(message) {
            handleDriverAssignmentMessage(JSON.parse(message.body));
        });
        
        // Subscribe to shipment updates channel
        stompClient.subscribe('/topic/shipments', function(message) {
            handleShipmentUpdateMessage(JSON.parse(message.body));
        });
    });
    
    function handleWebSocketMessage(message) {
        // Check message type and handle accordingly
        if (message.type === 'BULK_ASSIGNMENT') {
            handleBulkAssignmentNotification(message);
        } else if (message.type === 'SHIPMENT_UPDATE') {
            handleShipmentUpdateMessage(message);
        }
    }
    
    function handleBulkAssignmentNotification(message) {
        // Create toast notification
        const toastHtml = `
            <div class="toast align-items-center text-white bg-success border-0" role="alert" aria-live="assertive" aria-atomic="true">
                <div class="d-flex">
                    <div class="toast-body">
                        <i class="fas fa-truck-loading me-2"></i>
                        <strong>${message.driverName}</strong> assigned to ${message.shipmentCount} shipments
                    </div>
                    <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
                </div>
            </div>
        `;
        
        showToast(toastHtml);
        
        // Refresh shipment count stats (could be updated more precisely)
        setTimeout(function() {
            window.location.reload();
        }, 3000);
    }
    
    function handleDriverAssignmentMessage(message) {
        // Handle driver assignment notifications
        const toastHtml = `
            <div class="toast align-items-center text-white bg-primary border-0" role="alert" aria-live="assertive" aria-atomic="true">
                <div class="d-flex">
                    <div class="toast-body">
                        <i class="fas fa-user-check me-2"></i>
                        Driver ${message.driverName} assigned to ${message.shipmentCount} shipments
                    </div>
                    <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
                </div>
            </div>
        `;
        
        showToast(toastHtml);
    }
    
    function handleShipmentUpdateMessage(message) {
        // Handle shipment status updates
        if (message.status) {
            // Update DOM elements with the shipment information
            const shipmentRow = $(`#shipment-${message.shipmentId}`);
            if (shipmentRow.length) {
                shipmentRow.find('.shipment-status').text(message.status);
                
                // Add visual indicator
                shipmentRow.addClass('table-warning');
                setTimeout(() => {
                    shipmentRow.removeClass('table-warning');
                }, 5000);
            }
        }
    }
    
    function showToast(toastHtml) {
        // Create toast container if it doesn't exist
        if ($('#toastContainer').length === 0) {
            $('body').append('<div id="toastContainer" class="toast-container position-fixed bottom-0 end-0 p-3"></div>');
        }
        
        // Add toast to container
        const toastElement = $(toastHtml);
        $('#toastContainer').append(toastElement);
        
        // Initialize and show toast
        const toast = new bootstrap.Toast(toastElement, {
            autohide: true,
            delay: 5000
        });
        toast.show();
    }
    
    // Handle bulk assign button clicks
    $('.bulk-assign-btn').click(function() {
        const driverId = $(this).data('driver-id');
        const driverName = $(this).data('driver-name');
        
        if (confirm(`Are you sure you want to assign all unassigned shipments to ${driverName}?`)) {
            $.ajax({
                url: '/vendor/bulk-assign-driver',
                type: 'POST',
                data: {
                    driverId: driverId
                },
                success: function(response) {
                    if (response.status === 'success') {
                        showToast(`
                            <div class="toast align-items-center text-white bg-success border-0" role="alert" aria-live="assertive" aria-atomic="true">
                                <div class="d-flex">
                                    <div class="toast-body">
                                        <i class="fas fa-check-circle me-2"></i>
                                        ${response.message}
                                    </div>
                                    <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
                                </div>
                            </div>
                        `);
                    } else {
                        showToast(`
                            <div class="toast align-items-center text-white bg-danger border-0" role="alert" aria-live="assertive" aria-atomic="true">
                                <div class="d-flex">
                                    <div class="toast-body">
                                        <i class="fas fa-exclamation-circle me-2"></i>
                                        ${response.message || 'Failed to assign shipments'}
                                    </div>
                                    <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
                                </div>
                            </div>
                        `);
                    }
                },
                error: function() {
                    showToast(`
                        <div class="toast align-items-center text-white bg-danger border-0" role="alert" aria-live="assertive" aria-atomic="true">
                            <div class="d-flex">
                                <div class="toast-body">
                                    <i class="fas fa-exclamation-circle me-2"></i>
                                    Server error occurred. Please try again.
                                </div>
                                <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
                            </div>
                        </div>
                    `);
                }
            });
        }
    });

    function showNotification(message) {
        // Show notification
        showToast(`
            <div class="toast align-items-center text-white bg-success border-0" role="alert" aria-live="assertive" aria-atomic="true">
                <div class="d-flex">
                    <div class="toast-body">
                        <i class="fas fa-check-circle me-2"></i>
                        ${message}
                    </div>
                    <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
                </div>
            </div>
        `);
    }
}); 