<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Shipments - Admin Dashboard - PicknGo</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link href="/css/admin.css" rel="stylesheet">
    <style>
        .action-buttons .btn {
            margin-right: 5px;
        }
    </style>
</head>
<body>
    <jsp:include page="../layout/header.jsp" />
    
    <div class="container py-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1><i class="fas fa-box me-2"></i>Manage Shipments</h1>
            <a href="/admin/dashboard" class="btn btn-outline-primary">
                <i class="fas fa-arrow-left me-2"></i>Back to Dashboard
            </a>
        </div>
        
        <div class="card">
            <div class="card-header bg-light d-flex justify-content-between align-items-center">
                <h5 class="mb-0">All Shipments</h5>
                <a href="/admin/util/generate-tracking-numbers" class="btn btn-sm btn-primary">
                    <i class="fas fa-sync me-2"></i>Generate Missing Tracking Numbers
                </a>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-hover table-striped">
                        <thead class="table-dark">
                            <tr>
                                <th>ID</th>
                                <th>Tracking Number</th>
                                <th>Shipper</th>
                                <th>Driver</th>
                                <th>Origin</th>
                                <th>Destination</th>
                                <th>Status</th>
                                <th>Created Date</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty shipments}">
                                    <tr>
                                        <td colspan="9" class="text-center">No shipments found</td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach items="${shipments}" var="shipment">
                                        <tr id="shipment-${shipment.id}">
                                            <td>${shipment.id}</td>
                                            <td>${shipment.trackingNumber}</td>
                                            <td>${shipment.shipper.name}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${shipment.driver != null}">
                                                        ${shipment.driver.name}
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-secondary">Not Assigned</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>${shipment.pickupAddress}</td>
                                            <td>${shipment.deliveryAddress}</td>
                                            <td>
                                                <span class="badge ${shipment.status == 'DELIVERED' ? 'bg-success' : shipment.status == 'IN_TRANSIT' ? 'bg-warning text-dark' : shipment.status == 'ACCEPTED' ? 'bg-info' : 'bg-primary'}">
                                                    ${shipment.status}
                                                </span>
                                            </td>
                                            <td>
                                                <c:if test="${not empty shipment.createdAt}">
                                                    ${shipment.createdAt.toLocalDate()}
                                                </c:if>
                                            </td>
                                            <td class="action-buttons">
                                                <a href="/admin/tracking/${shipment.id}" class="btn btn-sm btn-info">
                                                    <i class="fas fa-map-marker-alt"></i> Track
                                                </a>
                                                
                                                <!-- Manual Driver Assignment -->
                                                <c:if test="${shipment.driver == null}">
                                                    <button type="button" class="btn btn-success btn-sm" 
                                                            data-bs-toggle="modal" 
                                                            data-bs-target="#assignDriverModal" 
                                                            data-shipment-id="${shipment.id}"
                                                            title="Assign Driver">
                                                        <i class="fas fa-user-plus"></i>
                                                    </button>
                                                </c:if>
                                                
                                                <!-- Interest Button -->
                                                <c:if test="${shipmentInterestsMap[shipment.id] != null}">
                                                    <button type="button" class="btn btn-warning btn-sm" 
                                                            data-bs-toggle="modal" 
                                                            data-bs-target="#viewInterestsModal" 
                                                            data-shipment-id="${shipment.id}"
                                                            title="View Driver Interests">
                                                        <i class="fas fa-users"></i>
                                                        <span class="badge bg-light text-dark">${shipmentInterestsMap[shipment.id].size()}</span>
                                                    </button>
                                                </c:if>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Assign Driver Modal -->
    <div class="modal fade" id="assignDriverModal" tabindex="-1" aria-labelledby="assignDriverModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-success text-white">
                    <h5 class="modal-title" id="assignDriverModalLabel"><i class="fas fa-user-plus me-2"></i>Assign Driver to Shipment</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form id="assignDriverForm">
                        <input type="hidden" id="shipmentId" name="shipmentId">
                        <div class="mb-3">
                            <label for="driverId" class="form-label">Select Driver</label>
                            <select class="form-select" id="driverId" name="driverId" required>
                                <option value="">-- Select a Driver --</option>
                                <c:forEach items="${drivers}" var="driver">
                                    <option value="${driver.id}">${driver.name} - ${driver.licenseNumber}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-success" id="assignDriverBtn">Assign Driver</button>
                </div>
            </div>
        </div>
    </div>
    
    <!-- View Interests Modal -->
    <div class="modal fade" id="viewInterestsModal" tabindex="-1" aria-labelledby="viewInterestsModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header bg-warning text-dark">
                    <h5 class="modal-title" id="viewInterestsModalLabel"><i class="fas fa-users me-2"></i>Driver Interests</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div id="interestsContainer">
                        <!-- Will be populated dynamically -->
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>
    
    <jsp:include page="../layout/footer.jsp" />
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/stomp-websocket@2.3.4/lib/stomp.min.js"></script>
    <script src="/js/realtime.js"></script>
    
    <script>
        $(document).ready(function() {
            // Get CSRF token 
            var token = $("meta[name='_csrf']").attr("content");
            var header = $("meta[name='_csrf_header']").attr("content");
            
            // Set shipment ID when opening the assign driver modal
            $('#assignDriverModal').on('show.bs.modal', function(event) {
                const button = $(event.relatedTarget);
                const shipmentId = button.data('shipment-id');
                $('#shipmentId').val(shipmentId);
            });
            
            // Assign driver button click handler
            $('#assignDriverBtn').on('click', function() {
                const shipmentId = $('#shipmentId').val();
                const driverId = $('#driverId').val();
                
                if (!driverId) {
                    showNotification('Error', 'Please select a driver');
                    return;
                }
                
                // Disable button to prevent multiple clicks
                const btn = $(this);
                btn.prop('disabled', true).html('<i class="fas fa-spinner fa-spin"></i> Processing...');
                
                // Send API request to assign driver
                $.ajax({
                    url: '/admin/assign-driver',
                    type: 'POST',
                    beforeSend: function(xhr) {
                        // Add CSRF token to headers
                        if(token && header) {
                            xhr.setRequestHeader(header, token);
                        }
                    },
                    data: {
                        shipmentId: shipmentId,
                        driverId: driverId
                    },
                    success: function(response) {
                        if (response.status === 'success') {
                            // Close modal
                            $('#assignDriverModal').modal('hide');
                            
                            // Show success toast
                            showNotification('Success', 'Driver assigned successfully');
                            
                            // Reload page after a short delay to reflect changes
                            setTimeout(function() {
                                window.location.reload();
                            }, 1500);
                        } else {
                            // Re-enable button on error
                            btn.prop('disabled', false).text('Assign Driver');
                            showNotification('Error', response.message || 'Something went wrong');
                        }
                    },
                    error: function(xhr, status, error) {
                        // Re-enable button on error
                        btn.prop('disabled', false).text('Assign Driver');
                        console.error("AJAX Error:", xhr.responseText);
                        showNotification('Error', 'Failed to assign driver. Please try again.');
                    }
                });
            });
            
            // Set interests data when opening the view interests modal
            $('#viewInterestsModal').on('show.bs.modal', function(event) {
                const button = $(event.relatedTarget);
                const shipmentId = button.data('shipment-id');
                const interestsContainer = $('#interestsContainer');
                
                // Clear previous content
                interestsContainer.empty();
                
                // Create interests list dynamically
                let interestsHtml = '<div class="list-group" id="shipment-interests-' + shipmentId + '">';
                
                <c:forEach items="${shipmentInterestsMap}" var="entry">
                    if (${entry.key} == shipmentId) {
                        <c:forEach items="${entry.value}" var="interest">
                            interestsHtml += `
                                <div id="interest-${interest.id}" class="list-group-item list-group-item-action">
                                    <div class="d-flex w-100 justify-content-between align-items-center">
                                        <div>
                                            <h5 class="mb-1">${interest.driver.name}</h5>
                                            <p class="mb-1">
                                                <i class="fas fa-phone me-1"></i>${interest.driver.contactNumber} |
                                                <i class="fas fa-id-card me-1"></i>${interest.driver.licenseNumber}
                                            </p>
                                            <small>
                                                Interest shown: <fmt:formatDate value="${interest.createdAt}" pattern="dd-MM-yyyy HH:mm" />
                                            </small>
                                        </div>
                                        <div>
                                            <c:choose>
                                                <c:when test="${interest.status eq 'PENDING'}">
                                                    <span class="badge bg-warning">Pending</span>
                                                </c:when>
                                                <c:when test="${interest.status eq 'ACCEPTED'}">
                                                    <span class="badge bg-success">Accepted</span>
                                                </c:when>
                                                <c:when test="${interest.status eq 'REJECTED'}">
                                                    <span class="badge bg-danger">Rejected</span>
                                                </c:when>
                                            </c:choose>
                                        </div>
                                    </div>
                                </div>
                            `;
                        </c:forEach>
                    }
                </c:forEach>
                
                interestsHtml += '</div>';
                interestsContainer.html(interestsHtml);
            });
            
            // Initialize WebSocket connection
            <sec:authentication property="principal" var="user" />
            connectWebSocket(${user.id}, '${user.authorities[0]}');
        });
        
        // Function to show notification toast if it doesn't exist
        function showNotification(title, message, type = 'primary') {
            // Create toast container if it doesn't exist
            let toastContainer = document.querySelector('.toast-container');
            if (!toastContainer) {
                toastContainer = document.createElement('div');
                toastContainer.className = 'toast-container position-fixed bottom-0 end-0 p-3';
                document.body.appendChild(toastContainer);
            }
            
            // Create a unique ID for this toast
            const toastId = 'toast-' + new Date().getTime();
            
            // Create toast HTML
            const toastHtml = `
                <div id="${toastId}" class="toast" role="alert" aria-live="assertive" aria-atomic="true">
                    <div class="toast-header bg-${type} text-white">
                        <strong class="me-auto">${title}</strong>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="toast" aria-label="Close"></button>
                    </div>
                    <div class="toast-body">
                        ${message}
                    </div>
                </div>
            `;
            
            // Add the toast to the container
            toastContainer.insertAdjacentHTML('beforeend', toastHtml);
            
            // Initialize and show the toast
            const toastElement = document.getElementById(toastId);
            const toast = new bootstrap.Toast(toastElement, { delay: 5000 });
            toast.show();
            
            // Remove the toast after it's hidden
            toastElement.addEventListener('hidden.bs.toast', function () {
                toastElement.remove();
            });
        }
    </script>
</body>
</html> 