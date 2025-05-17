<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="_csrf" content="${_csrf.token}"/>
    <meta name="_csrf_header" content="${_csrf.headerName}"/>
    <title>Manage Drivers - PicknGo</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link href="/resources/css/styles.css" rel="stylesheet">
    <style>
        .driver-card {
            transition: transform 0.3s ease;
        }
        .driver-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.1);
        }
        .driver-img {
            height: 150px;
            width: 150px;
            object-fit: cover;
            border-radius: 50%;
            margin: 0 auto;
            border: 5px solid rgba(255, 255, 255, 0.2);
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        }
        .bulk-assign-card {
            border-left: 4px solid var(--primary-color);
            background: rgba(13, 110, 253, 0.05);
            backdrop-filter: blur(10px);
        }
        .notification-badge {
            position: absolute;
            top: -5px;
            right: -5px;
            padding: 0.25rem 0.5rem;
            font-size: 0.75rem;
        }
        .driver-details p {
            background: rgba(0, 0, 0, 0.03);
            padding: 8px 12px;
            border-radius: 8px;
            margin-bottom: 8px;
        }
        .animate-card {
            animation: fadeInUp 0.5s ease forwards;
            opacity: 0;
        }
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        /* Driver image fallback colors */
        .driver-img-fallback {
            height: 150px;
            width: 150px;
            border-radius: 50%;
            margin: 0 auto;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 3rem;
            font-weight: bold;
            color: white;
            background: linear-gradient(45deg, #0d6efd, #0dcaf0);
        }
    </style>
</head>
<body>
    <jsp:include page="../layout/header.jsp" />
    
    <div class="container py-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1 class="fw-bold"><i class="fas fa-users me-2"></i>Manage Drivers</h1>
            <div>
                <a href="/vendor/assign-driver" class="btn btn-glass btn-glass-primary me-2">
                    <i class="fas fa-user-plus me-2"></i>Assign New Driver
                </a>
                <a href="/vendor/dashboard" class="btn btn-glass">
                    <i class="fas fa-tachometer-alt me-2"></i>Dashboard
                </a>
            </div>
        </div>
        
        <!-- Bulk Driver Assignment Section (New) -->
        <div class="glass-card mb-4 bulk-assign-card animate-fade-in">
            <div class="card-header" style="background: rgba(13, 110, 253, 0.15);">
                <h5 class="mb-0 fw-bold"><i class="fas fa-bolt me-2"></i>One-Click Driver Assignment</h5>
            </div>
            <div class="card-body p-4">
                <div class="row align-items-center">
                    <div class="col-md-7">
                        <h6 class="fw-bold">Bulk Assign a Driver to All Unassigned Shipments</h6>
                        <p class="text-muted mb-md-0">
                            Select a driver to instantly assign them to all unassigned shipments. 
                            This action will be synchronized in real-time across all dashboards.
                        </p>
                    </div>
                    <div class="col-md-5">
                        <form id="bulkAssignForm" action="/vendor/bulk-assign-driver" method="post" class="d-flex align-items-center">
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                            <div class="flex-grow-1 me-2">
                                <select class="form-control-glass" name="driverId" id="bulkDriverSelect" required>
                                    <option value="">-- Select Driver --</option>
                                    <c:forEach items="${drivers}" var="driver">
                                        <c:if test="${driver.verified}">
                                            <option value="${driver.id}">${driver.name} (${driver.contactNumber})</option>
                                        </c:if>
                                    </c:forEach>
                                </select>
                            </div>
                            <button type="submit" class="btn btn-glass btn-glass-success">
                                <i class="fas fa-truck-loading me-2"></i>Assign
                            </button>
                        </form>
                        <div class="mt-2 small text-muted">
                            <span class="badge bg-info me-1">Note:</span> Only verified drivers can be assigned to shipments
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="glass-card mb-4 animate-fade-in">
            <div class="card-header" style="background: rgba(13, 110, 253, 0.15);">
                <h5 class="mb-0 fw-bold"><i class="fas fa-list me-2"></i>Your Drivers</h5>
            </div>
            <div class="card-body p-4">
                <c:choose>
                    <c:when test="${not empty drivers}">
                        <div class="row">
                            <c:forEach items="${drivers}" var="driver" varStatus="loop">
                                <div class="col-md-6 col-lg-4 mb-4">
                                    <div class="glass-card driver-card h-100 animate-card" style="animation-delay: ${loop.index * 0.1}s">
                                        <div class="card-body text-center p-4">
                                            <div class="mb-3">
                                                <!-- Using a color-based fallback for driver avatar -->
                                                <div class="driver-img-fallback mb-3">
                                                    ${fn:substring(driver.name, 0, 1)}
                                                </div>
                                                <h5 class="fw-bold">${driver.name}</h5>
                                                <p class="text-muted">
                                                    <!-- Role-based email visibility - only showing partial email -->
                                                    <i class="fas fa-envelope me-1"></i>
                                                    ${fn:substring(driver.email, 0, 3)}...@${fn:substringAfter(driver.email, '@')}
                                                </p>
                                            </div>
                                            <div class="mb-3">
                                                <span class="badge bg-${driver.verified ? 'success' : 'warning'}">
                                                    ${driver.verified ? 'Verified' : 'Pending Verification'}
                                                </span>
                                            </div>
                                            <div class="driver-details mb-3">
                                                <p><i class="fas fa-phone me-2"></i>${driver.contactNumber}</p>
                                                <p><i class="fas fa-id-card me-2"></i>${driver.licenseNumber}</p>
                                            </div>
                                            <div class="d-grid gap-2">
                                                <a href="/vendor/driver/${driver.id}" class="btn btn-glass btn-glass-info btn-sm">
                                                    <i class="fas fa-eye me-2"></i>View Details
                                                </a>
                                                <a href="/vendor/driver/${driver.id}/assignVehicle" class="btn btn-glass btn-glass-success btn-sm">
                                                    <i class="fas fa-truck me-2"></i>Assign Vehicle
                                                </a>
                                                <button class="btn btn-glass btn-glass-primary btn-sm bulk-assign-single" data-driver-id="${driver.id}" data-driver-name="${driver.name}">
                                                    <i class="fas fa-bolt me-2"></i>Bulk Assign Shipments
                                                </button>
                                                <button class="btn btn-glass btn-glass-danger btn-sm remove-driver-btn" data-driver-id="${driver.id}">
                                                    <i class="fas fa-user-minus me-2"></i>Remove Driver
                                                </button>
                                            </div>
                                        </div>
                                        <c:if test="${activeCount > 0}">
                                            <span class="position-absolute top-0 end-0 notification-badge badge rounded-pill bg-danger">
                                                ${activeCount} active
                                            </span>
                                        </c:if>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="alert alert-info">
                            <i class="fas fa-info-circle me-2"></i>You haven't assigned any drivers yet. 
                            <a href="/vendor/assign-driver" class="alert-link">Assign drivers now</a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
        
        <div class="glass-card animate-fade-in">
            <div class="card-header" style="background: rgba(13, 110, 253, 0.15);">
                <h5 class="mb-0 fw-bold"><i class="fas fa-table me-2"></i>Drivers List</h5>
            </div>
            <div class="card-body p-4">
                <c:choose>
                    <c:when test="${not empty drivers}">
                        <div class="table-responsive">
                            <table class="table table-glass">
                                <thead>
                                    <tr>
                                        <th>Name</th>
                                        <th>Contact</th>
                                        <th>License Number</th>
                                        <th>Status</th>
                                        <th>Active Shipments</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${drivers}" var="driver">
                                        <tr>
                                            <td>
                                                <div class="d-flex align-items-center">
                                                    <div class="bg-primary text-white rounded-circle d-flex align-items-center justify-content-center me-2" style="width: 35px; height: 35px; flex-shrink: 0;">
                                                        ${fn:substring(driver.name, 0, 1)}
                                                    </div>
                                                    <div>
                                                        ${driver.name}
                                                        <div class="small text-muted">
                                                            <!-- Role-based email visibility - only showing partial email -->
                                                            <i class="fas fa-envelope me-1"></i>
                                                            ${fn:substring(driver.email, 0, 3)}...@${fn:substringAfter(driver.email, '@')}
                                                        </div>
                                                    </div>
                                                </div>
                                            </td>
                                            <td>${driver.contactNumber}</td>
                                            <td>${driver.licenseNumber}</td>
                                            <td>
                                                <span class="badge bg-${driver.verified ? 'success' : 'warning'}">
                                                    ${driver.verified ? 'Verified' : 'Pending'}
                                                </span>
                                            </td>
                                            <td>
                                                <c:set var="activeCount" value="0" />
                                                <c:forEach items="${shipments}" var="shipment">
                                                    <c:if test="${shipment.driver.id eq driver.id && shipment.status ne 'DELIVERED'}">
                                                        <c:set var="activeCount" value="${activeCount + 1}" />
                                                    </c:if>
                                                </c:forEach>
                                                ${activeCount}
                                            </td>
                                            <td>
                                                <div class="btn-group" role="group">
                                                    <a href="/vendor/driver/${driver.id}" class="btn btn-glass btn-glass-info btn-sm">
                                                        <i class="fas fa-eye"></i>
                                                    </a>
                                                    <a href="/vendor/driver/${driver.id}/assignVehicle" class="btn btn-glass btn-glass-success btn-sm">
                                                        <i class="fas fa-truck"></i>
                                                    </a>
                                                    <button class="btn btn-glass btn-glass-primary btn-sm bulk-assign-single" data-driver-id="${driver.id}" data-driver-name="${driver.name}">
                                                        <i class="fas fa-bolt"></i>
                                                    </button>
                                                    <button class="btn btn-glass btn-glass-danger btn-sm remove-driver-btn" data-driver-id="${driver.id}">
                                                        <i class="fas fa-user-minus"></i>
                                                    </button>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="alert alert-info mb-0">
                            <i class="fas fa-info-circle me-2"></i>You haven't assigned any drivers yet.
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
    
    <!-- Remove Driver Confirmation Modal -->
    <div class="modal fade" id="removeDriverModal" tabindex="-1" aria-labelledby="removeDriverModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content glass-card">
                <div class="modal-header" style="background: rgba(220, 53, 69, 0.25);">
                    <h5 class="modal-title fw-bold" id="removeDriverModalLabel">Confirm Driver Removal</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="text-center mb-3">
                        <div class="bg-danger text-white rounded-circle d-inline-flex align-items-center justify-content-center mb-3" style="width: 80px; height: 80px;">
                            <i class="fas fa-exclamation-triangle fa-2x"></i>
                        </div>
                    </div>
                    <p class="text-center">Are you sure you want to remove this driver from your vendor account?</p>
                    <p class="mb-0 text-danger text-center"><strong>Note:</strong> This action cannot be undone, and all active shipments for this driver will be affected.</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-glass" data-bs-dismiss="modal">Cancel</button>
                    <form id="removeDriverForm" action="/vendor/remove-driver" method="post">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                        <input type="hidden" id="driverIdToRemove" name="driverId" value="" />
                        <button type="submit" class="btn btn-glass btn-glass-danger">Remove Driver</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Bulk Assignment Confirmation Modal -->
    <div class="modal fade" id="bulkAssignModal" tabindex="-1" aria-labelledby="bulkAssignModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content glass-card">
                <div class="modal-header" style="background: rgba(13, 110, 253, 0.25);">
                    <h5 class="modal-title fw-bold" id="bulkAssignModalLabel">Confirm Bulk Assignment</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="text-center mb-3">
                        <div class="bg-primary text-white rounded-circle d-inline-flex align-items-center justify-content-center mb-3" style="width: 80px; height: 80px;">
                            <i class="fas fa-truck-loading fa-2x"></i>
                        </div>
                    </div>
                    <p class="text-center">You are about to assign <strong id="selectedDriverName">this driver</strong> to all unassigned shipments.</p>
                    <p>This action will:</p>
                    <ul>
                        <li>Assign the driver to all shipments currently without a driver</li>
                        <li>Update all dashboards in real-time via WebSocket</li>
                        <li>Send notifications to relevant users</li>
                    </ul>
                    <p class="mb-0 text-primary"><strong>Note:</strong> This action will immediately start the assignment process and cannot be easily reversed.</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-glass" data-bs-dismiss="modal">Cancel</button>
                    <form id="bulkAssignSingleForm" action="/vendor/bulk-assign-driver" method="post">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                        <input type="hidden" id="driverIdToBulkAssign" name="driverId" value="" />
                        <button type="submit" class="btn btn-glass btn-glass-primary">
                            <i class="fas fa-truck-loading me-2"></i>Assign All Shipments
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>
    
    <jsp:include page="../layout/footer.jsp" />
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/stompjs@2.3.3/lib/stomp.min.js"></script>
    <script>
        $(document).ready(function() {
            // Handle remove driver button click
            $('.remove-driver-btn').click(function() {
                const driverId = $(this).data('driver-id');
                $('#driverIdToRemove').val(driverId);
                $('#removeDriverModal').modal('show');
            });
            
            // Handle bulk assign single driver button click
            $('.bulk-assign-single').click(function() {
                const driverId = $(this).data('driver-id');
                const driverName = $(this).data('driver-name');
                $('#driverIdToBulkAssign').val(driverId);
                $('#selectedDriverName').text(driverName);
                $('#bulkAssignModal').modal('show');
            });
            
            // WebSocket connection for real-time updates
            const socket = new SockJS('/ws');
            const stompClient = Stomp.over(socket);
            
            stompClient.connect({}, function(frame) {
                console.log('Connected to WebSocket: ' + frame);
                
                // Subscribe to driver assignment channel
                stompClient.subscribe('/topic/driver-assignments', function(message) {
                    const assignment = JSON.parse(message.body);
                    
                    // Show notification
                    showNotification(`Driver ${assignment.driverName} assigned to ${assignment.shipmentCount} shipments`);
                });
            });
            
            function showNotification(message) {
                // Create toast container if it doesn't exist
                if ($('#toastContainer').length === 0) {
                    $('body').append('<div id="toastContainer" class="toast-container position-fixed bottom-0 end-0 p-3"></div>');
                }
                
                // Create a notification element
                const notification = $(`
                    <div class="toast" role="alert" aria-live="assertive" aria-atomic="true">
                        <div class="toast-header bg-primary text-white">
                            <i class="fas fa-bell me-2"></i>
                            <strong class="me-auto">Notification</strong>
                            <small>Just now</small>
                            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="toast" aria-label="Close"></button>
                        </div>
                        <div class="toast-body">
                            ${message}
                        </div>
                    </div>
                `);
                
                // Add to container
                $('#toastContainer').append(notification);
                
                // Initialize and show toast
                const toast = new bootstrap.Toast(notification);
                toast.show();
                
                // Remove after it's hidden
                notification.on('hidden.bs.toast', function() {
                    notification.remove();
                });
            }
            
            // Submit handlers with loading indicators
            $('#bulkAssignForm, #bulkAssignSingleForm').submit(function() {
                const submitBtn = $(this).find('button[type="submit"]');
                const originalText = submitBtn.html();
                submitBtn.html('<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> Assigning...');
                submitBtn.prop('disabled', true);
                
                // Reset after 10 seconds as a fallback if something goes wrong
                setTimeout(() => {
                    submitBtn.html(originalText);
                    submitBtn.prop('disabled', false);
                }, 10000);
            });
        });
    </script>
</body>
</html> 