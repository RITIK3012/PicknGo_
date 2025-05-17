// Driver Show Interest JavaScript Logic

document.addEventListener('DOMContentLoaded', function() {
    // Function to show notification
    function showNotification(title, message) {
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
            <div id="${toastId}" class="toast" role="alert" aria-live="assertive" aria-atomic="true" data-bs-delay="5000">
                <div class="toast-header">
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

    // Find all show interest buttons
    const showInterestButtons = document.querySelectorAll('.show-interest-btn');
    
    // Add click event listener to each button
    showInterestButtons.forEach(function(button) {
        button.addEventListener('click', function() {
            const shipmentId = this.getAttribute('data-shipment-id');
            const btn = this;
            
            // Disable button while processing
            btn.disabled = true;
            btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Processing...';
            
            // Make AJAX request to show interest
            fetch('/driver/show-interest/' + shipmentId, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                }
            })
            .then(response => response.json())
            .then(data => {
                if (data.status === 'success') {
                    // Replace button with badge
                    btn.outerHTML = '<span class="badge bg-warning">Interest Pending</span>';
                    showNotification('Success', 'Interest shown successfully');
                } else {
                    // Re-enable button on error
                    btn.disabled = false;
                    btn.innerHTML = 'Show Interest';
                    showNotification('Error', data.message || 'Something went wrong');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                // Re-enable button on error
                btn.disabled = false;
                btn.innerHTML = 'Show Interest';
                showNotification('Error', 'Failed to show interest. Please try again.');
            });
        });
    });
}); 