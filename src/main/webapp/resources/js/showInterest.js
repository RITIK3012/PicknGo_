// Driver Show Interest JavaScript Logic

$(document).ready(function() {
    console.log('Show Interest script loaded and ready');
    
    // Function to show notification
    function showNotification(title, message, type = 'primary') {
        // Create toast container if it doesn't exist
        let toastContainer = document.querySelector('.toast-container');
        if (!toastContainer) {
            toastContainer = document.createElement('div');
            toastContainer.className = 'toast-container position-fixed top-0 end-0 p-3';
            document.body.appendChild(toastContainer);
        }
        
        // Create toast element
        const toastId = 'toast-' + Date.now();
        const toastHtml = `
            <div id="${toastId}" class="toast toast-glass" role="alert" aria-live="assertive" aria-atomic="true" data-bs-delay="5000">
                <div class="toast-header" style="background: rgba(255, 255, 255, 0.2);">
                    <strong class="me-auto">${title}</strong>
                    <button type="button" class="btn-close" data-bs-dismiss="toast" aria-label="Close"></button>
                </div>
                <div class="toast-body">
                    ${message}
                </div>
            </div>
        `;
        
        // Add toast to container
        toastContainer.insertAdjacentHTML('beforeend', toastHtml);
        
        // Initialize and show the toast
        const toastElement = document.getElementById(toastId);
        const toast = new bootstrap.Toast(toastElement);
        toast.show();
        
        // Remove toast after it's hidden
        toastElement.addEventListener('hidden.bs.toast', function() {
            this.remove();
        });
    }

    // Count buttons on the page
    const buttonCount = $('.show-interest-btn').length;
    console.log(`Found ${buttonCount} show interest buttons on the page`);
    
    // Immediately bind buttons directly
    $('.show-interest-btn').on('click', function(e) {
        console.log('Button clicked via direct binding');
        handleButtonClick($(this), e);
    });

    // Also use delegation for dynamically added buttons
    $(document).on('click', '.show-interest-btn', function(e) {
        console.log('Button clicked via delegation');
        handleButtonClick($(this), e);
    });
    
    // Function to handle the button click
    function handleButtonClick(btn, e) {
        e.preventDefault();
        e.stopPropagation();
        
        const shipmentId = btn.data('shipment-id');
        console.log(`Processing interest for shipment: ${shipmentId}`);
        
        // Check if already processing
        if (btn.prop('disabled')) {
            console.log('Button already disabled, ignoring click');
            return;
        }
        
        // Disable button while processing
        btn.prop('disabled', true)
           .html('<i class="fas fa-spinner fa-spin"></i> Processing...');
        
        console.log('Sending AJAX request...');
        
        // Get CSRF token
        const token = $("meta[name='_csrf']").attr("content");
        const header = $("meta[name='_csrf_header']").attr("content");
        
        // Send AJAX request to show interest
        $.ajax({
            url: '/driver/show-interest/' + shipmentId,
            type: 'POST',
            contentType: 'application/json',
            beforeSend: function(xhr) {
                if (token && header) {
                    xhr.setRequestHeader(header, token);
                }
            },
            success: function(response) {
                console.log('Request successful:', response);
                if (response.status === 'success') {
                    // Replace button with badge
                    btn.replaceWith('<span class="badge bg-warning">Interest Pending</span>');
                    
                    // Show notification
                    showNotification('Success', 'Interest shown successfully', 'success');
                } else {
                    // Re-enable button on error
                    btn.prop('disabled', false).html('Show Interest');
                    showNotification('Error', response.message || 'Something went wrong', 'danger');
                }
            },
            error: function(xhr, status, error) {
                console.error('Request failed:', status, error);
                console.error('Error details:', xhr.responseText);
                
                // Re-enable button on error
                btn.prop('disabled', false).html('Show Interest');
                showNotification('Error', 'Failed to show interest. Please try again.', 'danger');
            }
        });
    }
    
    // WebSocket handlers for real-time updates
    window.updateDriverInterestDisplay = function(data) {
        console.log('Driver interest update received:', data);
        
        // Update the UI based on interest status
        const shipmentRow = document.querySelector(`#shipment-${data.shipmentId}`);
        if (shipmentRow) {
            const actionsCell = shipmentRow.querySelector('td:last-child');
            
            if (actionsCell) {
                // Update the UI based on the new interest status
                if (data.status === 'PENDING') {
                    actionsCell.innerHTML = '<span class="badge bg-warning">Interest Pending</span>';
                } else if (data.status === 'ACCEPTED') {
                    actionsCell.innerHTML = '<span class="badge bg-success">Interest Accepted</span>';
                    
                    // Add highlight animation
                    shipmentRow.classList.add('table-success', 'highlight-pulse');
                    
                    // Show a more detailed notification
                    showNotification(
                        'Interest Accepted', 
                        'Your interest has been accepted for this shipment. The shipment has been assigned to you!',
                        'success'
                    );
                    
                    // Refresh the page after a short delay to show updated shipment list
                    setTimeout(() => window.location.reload(), 3000);
                } else if (data.status === 'REJECTED') {
                    actionsCell.innerHTML = '<span class="badge bg-danger">Interest Rejected</span>';
                    
                    // Show notification
                    showNotification(
                        'Interest Rejected', 
                        'Your interest was rejected for this shipment.',
                        'danger'
                    );
                }
            }
        }
    };
}); 