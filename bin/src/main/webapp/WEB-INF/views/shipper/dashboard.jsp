<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Shipper Dashboard - PicknGo</title>
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
        <h1 class="mb-4"><i class="fas fa-tachometer-alt me-2"></i>Shipper Dashboard</h1>
        
        <div class="row mb-4">
            <div class="col-md-6 col-lg-3">
                <div class="card dashboard-card bg-primary text-white">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="card-title">Total Shipments</h6>
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
                                <h6 class="card-title">In Transit</h6>
                                <h2 class="mb-0">
                                    <c:set var="inTransitCount" value="0" />
                                    <c:forEach items="${shipments}" var="shipment">
                                        <c:if test="${shipment.status eq 'IN_TRANSIT'}">
                                            <c:set var="inTransitCount" value="${inTransitCount + 1}" />
                                        </c:if>
                                    </c:forEach>
                                    ${inTransitCount}
                                </h2>
                            </div>
                            <div class="stats-icon">
                                <i class="fas fa-truck-moving"></i>
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
                                <h6 class="card-title">Pending Shipments</h6>
                                <h2 class="mb-0">
                                    <c:set var="pendingCount" value="0" />
                                    <c:forEach items="${shipments}" var="shipment">
                                        <c:if test="${shipment.status eq 'PENDING' || shipment.status eq 'INTEREST_SHOWN'}">
                                            <c:set var="pendingCount" value="${pendingCount + 1}" />
                                        </c:if>
                                    </c:forEach>
                                    ${pendingCount}
                                </h2>
                            </div>
                            <div class="stats-icon">
                                <i class="fas fa-hourglass-half"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Shipments with Driver Interests -->
        <c:if test="${not empty shipmentInterestsMap}">
            <div class="card mb-4">
                <div class="card-header bg-warning text-dark">
                    <div class="d-flex justify-content-between align-items-center">
                        <h5 class="mb-0"><i class="fas fa-users me-2"></i>Shipments with Driver Interests</h5>
                    </div>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-striped table-hover">
                            <thead>
                                <tr>
                                    <th>Tracking #</th>
                                    <th>Origin</th>
                                    <th>Destination</th>
                                    <th>Created At</th>
                                    <th>Interested Drivers</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${shipmentInterestsMap}" var="entry">
                                    <c:set var="shipmentId" value="${entry.key}" />
                                    <c:set var="interests" value="${entry.value}" />
                                    
                                    <c:forEach items="${shipments}" var="shipment">
                                        <c:if test="${shipment.id eq shipmentId}">
                                            <tr>
                                                <td>${shipment.trackingNumber}</td>
                                                <td>${shipment.pickupAddress}</td>
                                                <td>${shipment.deliveryAddress}</td>
                                                <td>
                                                    <fmt:parseDate value="${shipment.createdAt}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate" type="both" />
                                                    <fmt:formatDate value="${parsedDate}" pattern="dd-MM-yyyy" />
                                                </td>
                                                <td>
                                                    <span class="badge bg-primary">${interests.size()} Drivers</span>
                                                </td>
                                                <td>
                                                    <a href="/shipper/shipment/${shipment.id}" class="btn btn-primary btn-sm">
                                                        <i class="fas fa-eye me-1"></i>View Details
                                                    </a>
                                                </td>
                                            </tr>
                                        </c:if>
                                    </c:forEach>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </c:if>
        
        <!-- Assigned Shipments Section -->
        <div class="card mb-4">
            <div class="card-header bg-info text-white">
                <div class="d-flex justify-content-between align-items-center">
                    <h5 class="mb-0"><i class="fas fa-truck-loading me-2"></i>Assigned Shipments</h5>
                </div>
            </div>
            <div class="card-body">
                <c:set var="hasAssignedShipments" value="false" />
                <c:forEach items="${shipments}" var="shipment">
                    <c:if test="${shipment.status eq 'ASSIGNED' || shipment.status eq 'PICKED_UP' || shipment.status eq 'IN_TRANSIT'}">
                        <c:set var="hasAssignedShipments" value="true" />
                    </c:if>
                </c:forEach>
                
                <c:choose>
                    <c:when test="${hasAssignedShipments}">
                        <div class="table-responsive">
                            <table class="table table-striped table-hover">
                                <thead>
                                    <tr>
                                        <th>Tracking #</th>
                                        <th>Origin</th>
                                        <th>Destination</th>
                                        <th>Driver</th>
                                        <th>Status</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${shipments}" var="shipment">
                                        <c:if test="${shipment.status eq 'ASSIGNED' || shipment.status eq 'PICKED_UP' || shipment.status eq 'IN_TRANSIT'}">
                                            <tr id="shipment-${shipment.id}">
                                                <td>${shipment.trackingNumber}</td>
                                                <td>${shipment.pickupAddress}</td>
                                                <td>${shipment.deliveryAddress}</td>
                                                <td>
                                                    <c:if test="${shipment.driver != null}">
                                                        <span class="badge bg-info">
                                                            <i class="fas fa-user-check me-1"></i>${shipment.driver.name}
                                                        </span>
                                                    </c:if>
                                                </td>
                                                <td class="shipment-status">
                                                    <span class="badge ${shipment.status eq 'ASSIGNED' ? 'bg-info' : shipment.status eq 'PICKED_UP' ? 'bg-primary' : 'bg-warning text-dark'}">
                                                        ${shipment.status}
                                                    </span>
                                                </td>
                                                <td>
                                                    <div class="btn-group" role="group">
                                                        <a href="/shipper/shipment/${shipment.id}" class="btn btn-info btn-sm">
                                                            <i class="fas fa-eye"></i> View
                                                        </a>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:if>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="alert alert-info mb-0">
                            <i class="fas fa-info-circle me-2"></i>You don't have any assigned shipments yet.
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
        
        <!-- Recent Shipments -->
        <div class="card mb-4">
            <div class="card-header bg-primary text-white">
                <div class="d-flex justify-content-between align-items-center">
                    <h5 class="mb-0"><i class="fas fa-boxes me-2"></i>Recent Shipments</h5>
                    <a href="/shipper/shipments" class="btn btn-sm btn-light">View All</a>
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
                                        <th>Driver</th>
                                        <th>Status</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${shipments}" var="shipment" begin="0" end="4">
                                        <tr id="shipment-${shipment.id}">
                                            <td>${shipment.trackingNumber}</td>
                                            <td>${shipment.pickupAddress}</td>
                                            <td>${shipment.deliveryAddress}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${shipment.driver != null}">
                                                        <span class="badge bg-success">
                                                            <i class="fas fa-user-check me-1"></i>${shipment.driver.name}
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-secondary">Not Assigned</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="shipment-status">${shipment.status}</td>
                                            <td>
                                                <div class="btn-group" role="group">
                                                    <a href="/shipper/shipment/${shipment.id}" class="btn btn-info btn-sm">
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
                            <i class="fas fa-info-circle me-2"></i>You haven't created any shipments yet.
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
            <div class="card-footer">
                <a href="/shipper/create-shipment" class="btn btn-success">
                    <i class="fas fa-plus-circle me-2"></i>Create New Shipment
                </a>
            </div>
        </div>
    </div>
    
    <jsp:include page="../layout/footer.jsp" />
    
    <!-- Bootstrap & jQuery Scripts -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- WebSocket Libraries -->
    <script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/stomp-websocket@2.3.4/lib/stomp.min.js"></script>
    
    <!-- Custom Scripts -->
    <script src="/resources/js/realtime.js"></script>
    
    <script>
        $(document).ready(function() {
            <sec:authentication property="principal" var="user" />
            connectWebSocket(${user.id}, '${user.authorities[0]}');
        });
    </script>
</body>
</html> 