<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Driver Dashboard - PicknGo</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link href="/css/styles.css" rel="stylesheet">
    <style>
        .dashboard-card {
            transition: transform 0.3s ease;
            margin-bottom: 20px;
        }
        .dashboard-card:hover {
            transform: translateY(-5px);
        }
        .stats-icon {
            font-size: 3rem;
            opacity: 0.8;
        }
    </style>
</head>
<body>
    <jsp:include page="../layout/header.jsp" />
    
    <div class="container py-5">
        <h1 class="mb-4"><i class="fas fa-tachometer-alt me-2"></i>Driver Dashboard</h1>
        
        <div class="row mb-4">
            <div class="col-md-6 col-lg-3">
                <div class="card dashboard-card bg-primary text-white">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="card-title">Assigned Shipments</h6>
                                <h2 class="mb-0">${shipments.size()}</h2>
                            </div>
                            <div class="stats-icon">
                                <i class="fas fa-box"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-6 col-lg-3">
                <div class="card dashboard-card bg-success text-white">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="card-title">Completed Deliveries</h6>
                                <h2 class="mb-0">
                                    <c:set var="completedCount" value="0" />
                                    <c:forEach items="${shipments}" var="shipment">
                                        <c:if test="${shipment.status eq 'DELIVERED'}">
                                            <c:set var="completedCount" value="${completedCount + 1}" />
                                        </c:if>
                                    </c:forEach>
                                    ${completedCount}
                                </h2>
                            </div>
                            <div class="stats-icon">
                                <i class="fas fa-check-circle"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-6 col-lg-3">
                <div class="card dashboard-card bg-warning text-dark">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="card-title">Vehicles</h6>
                                <h2 class="mb-0">${vehicles.size()}</h2>
                            </div>
                            <div class="stats-icon">
                                <i class="fas fa-truck"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-6 col-lg-3">
                <div class="card dashboard-card bg-info text-white">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="card-title">Account Status</h6>
                                <h2 class="mb-0">
                                    <c:choose>
                                        <c:when test="${driver.verified}">Verified</c:when>
                                        <c:otherwise>Pending</c:otherwise>
                                    </c:choose>
                                </h2>
                            </div>
                            <div class="stats-icon">
                                <i class="fas fa-user-check"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Available Shipments Section -->
        <div class="card mb-4">
            <div class="card-header bg-primary text-white">
                <div class="d-flex justify-content-between align-items-center">
                    <h5 class="mb-0"><i class="fas fa-boxes me-2"></i>Available Shipments</h5>
                    <a href="/driver/available-shipments" class="btn btn-sm btn-light">View All</a>
                </div>
            </div>
            <div class="card-body">
                <c:choose>
                    <c:when test="${not empty availableShipments}">
                        <div class="table-responsive">
                            <table class="table table-striped table-hover">
                                <thead>
                                    <tr>
                                        <th>Tracking #</th>
                                        <th>Origin</th>
                                        <th>Destination</th>
                                        <th>Shipper</th>
                                        <th>Created</th>
                                        <th>Status</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${availableShipments}" var="shipment" begin="0" end="4">
                                        <tr id="shipment-${shipment.id}">
                                            <td>${shipment.trackingNumber}</td>
                                            <td>${shipment.pickupAddress}</td>
                                            <td>${shipment.deliveryAddress}</td>
                                            <td>${shipment.shipper.companyName}</td>
                                            <td>
                                                <fmt:parseDate value="${shipment.createdAt}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate" type="both" />
                                                <fmt:formatDate value="${parsedDate}" pattern="dd-MM-yyyy" />
                                            </td>
                                            <td class="shipment-status">${shipment.status}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${interestStatusMap[shipment.id] eq 'PENDING'}">
                                                        <span class="badge bg-warning">Interest Pending</span>
                                                    </c:when>
                                                    <c:when test="${interestStatusMap[shipment.id] eq 'ACCEPTED'}">
                                                        <span class="badge bg-success">Interest Accepted</span>
                                                    </c:when>
                                                    <c:when test="${interestStatusMap[shipment.id] eq 'REJECTED'}">
                                                        <span class="badge bg-danger">Interest Rejected</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <button class="btn btn-primary btn-sm show-interest-btn" 
                                                                data-shipment-id="${shipment.id}">
                                                            Show Interest
                                                        </button>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="alert alert-info mb-0">
                            <i class="fas fa-info-circle me-2"></i>No available shipments at the moment. Please check back later.
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
        
        <!-- Current Shipments Section -->
        <div class="card mb-4">
            <div class="card-header bg-success text-white">
                <div class="d-flex justify-content-between align-items-center">
                    <h5 class="mb-0"><i class="fas fa-truck-loading me-2"></i>Current Shipments</h5>
                    <a href="/driver/shipments" class="btn btn-sm btn-light">View All</a>
                </div>
            </div>
            <div class="card-body">
                <c:choose>
                    <c:when test="${not empty shipments}">
                        <div class="table-responsive">
                            <table class="table table-striped table-hover">
                                <thead>
                                    <tr>
                                        <th>Tracking #</th>
                                        <th>Origin</th>
                                        <th>Destination</th>
                                        <th>Shipper</th>
                                        <th>Status</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${shipments}" var="shipment" begin="0" end="4">
                                        <tr>
                                            <td>${shipment.trackingNumber}</td>
                                            <td>${shipment.pickupAddress}</td>
                                            <td>${shipment.deliveryAddress}</td>
                                            <td>${shipment.shipper.companyName}</td>
                                            <td>${shipment.status}</td>
                                            <td>
                                                <div class="btn-group" role="group">
                                                    <a href="/driver/shipment/${shipment.id}" class="btn btn-info btn-sm">
                                                        <i class="fas fa-eye"></i> View
                                                    </a>
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
                            <i class="fas fa-info-circle me-2"></i>You have no assigned shipments at the moment.
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
    
    <jsp:include page="../layout/footer.jsp" />
    
    <!-- Bootstrap & jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- WebSocket Libraries -->
    <script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/stomp-websocket@2.3.4/lib/stomp.min.js"></script>
    
    <!-- Custom Scripts -->
    <script src="/resources/js/realtime.js"></script>
    <script src="/resources/js/showInterest.js"></script>
    
    <script>
        $(document).ready(function() {
            <sec:authentication property="principal" var="user" />
            connectWebSocket(${user.id}, '${user.authorities[0]}');
        });
    </script>
</body>
</html> 