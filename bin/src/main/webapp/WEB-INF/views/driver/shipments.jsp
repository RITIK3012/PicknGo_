<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Shipments - PicknGo</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    <jsp:include page="../layout/header.jsp" />
    
    <div class="container py-5">
        <div class="row">
            <div class="col-md-3">
                <div class="card">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0"><i class="fas fa-user-circle me-2"></i>Menu</h5>
                    </div>
                    <div class="list-group list-group-flush">
                        <a href="/driver/dashboard" class="list-group-item list-group-item-action">
                            <i class="fas fa-tachometer-alt me-2"></i>Dashboard
                        </a>
                        <a href="/driver/profile" class="list-group-item list-group-item-action">
                            <i class="fas fa-user-cog me-2"></i>Profile
                        </a>
                        <a href="/driver/shipments" class="list-group-item list-group-item-action active">
                            <i class="fas fa-box me-2"></i>Shipments
                        </a>
                        <a href="/driver/vehicles" class="list-group-item list-group-item-action">
                            <i class="fas fa-truck me-2"></i>Vehicles
                        </a>
                    </div>
                </div>
            </div>
            <div class="col-md-9">
                <div class="card">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0"><i class="fas fa-box-open me-2"></i>My Shipments</h5>
                    </div>
                    <div class="card-body">
                        <c:if test="${not empty success}">
                            <div class="alert alert-success" role="alert">
                                <i class="fas fa-check-circle me-2"></i>${success}
                            </div>
                        </c:if>
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger" role="alert">
                                <i class="fas fa-exclamation-circle me-2"></i>${error}
                            </div>
                        </c:if>
                        
                        <ul class="nav nav-tabs mb-4" id="shipmentsTab" role="tablist">
                            <li class="nav-item" role="presentation">
                                <button class="nav-link active" id="active-tab" data-bs-toggle="tab" data-bs-target="#active-shipments" type="button" role="tab" aria-controls="active-shipments" aria-selected="true">Active</button>
                            </li>
                            <li class="nav-item" role="presentation">
                                <button class="nav-link" id="delivered-tab" data-bs-toggle="tab" data-bs-target="#delivered-shipments" type="button" role="tab" aria-controls="delivered-shipments" aria-selected="false">Delivered</button>
                            </li>
                            <li class="nav-item" role="presentation">
                                <button class="nav-link" id="all-tab" data-bs-toggle="tab" data-bs-target="#all-shipments" type="button" role="tab" aria-controls="all-shipments" aria-selected="false">All Shipments</button>
                            </li>
                        </ul>
                        
                        <div class="tab-content" id="shipmentsTabContent">
                            <div class="tab-pane fade show active" id="active-shipments" role="tabpanel" aria-labelledby="active-tab">
                                <div class="table-responsive">
                                    <table class="table table-hover">
                                        <thead>
                                            <tr>
                                                <th>ID</th>
                                                <th>Tracking Number</th>
                                                <th>Pickup</th>
                                                <th>Delivery</th>
                                                <th>Status</th>
                                                <th>Date</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:set var="hasActive" value="false" />
                                            <c:forEach items="${shipments}" var="shipment">
                                                <c:if test="${shipment.status != 'DELIVERED'}">
                                                    <c:set var="hasActive" value="true" />
                                                    <tr>
                                                        <td>${shipment.id}</td>
                                                        <td>${shipment.trackingNumber}</td>
                                                        <td>${shipment.pickupAddress}</td>
                                                        <td>${shipment.deliveryAddress}</td>
                                                        <td>
                                                            <span class="badge ${shipment.status == 'IN_TRANSIT' ? 'bg-warning text-dark' : 'bg-primary'}">
                                                                ${shipment.status}
                                                            </span>
                                                        </td>
                                                        <td>
                                                            <c:if test="${not empty shipment.createdAt}">
                                                                ${shipment.createdAt.toLocalDate()}
                                                            </c:if>
                                                        </td>
                                                        <td>
                                                            <a href="/driver/shipments/${shipment.id}" class="btn btn-sm btn-info">
                                                                <i class="fas fa-info-circle"></i> Details
                                                            </a>
                                                        </td>
                                                    </tr>
                                                </c:if>
                                            </c:forEach>
                                            <c:if test="${!hasActive}">
                                                <tr>
                                                    <td colspan="7" class="text-center">No active shipments found</td>
                                                </tr>
                                            </c:if>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                            
                            <div class="tab-pane fade" id="delivered-shipments" role="tabpanel" aria-labelledby="delivered-tab">
                                <div class="table-responsive">
                                    <table class="table table-hover">
                                        <thead>
                                            <tr>
                                                <th>ID</th>
                                                <th>Tracking Number</th>
                                                <th>Pickup</th>
                                                <th>Delivery</th>
                                                <th>Status</th>
                                                <th>Date</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:set var="hasDelivered" value="false" />
                                            <c:forEach items="${shipments}" var="shipment">
                                                <c:if test="${shipment.status == 'DELIVERED'}">
                                                    <c:set var="hasDelivered" value="true" />
                                                    <tr>
                                                        <td>${shipment.id}</td>
                                                        <td>${shipment.trackingNumber}</td>
                                                        <td>${shipment.pickupAddress}</td>
                                                        <td>${shipment.deliveryAddress}</td>
                                                        <td>
                                                            <span class="badge bg-success">
                                                                ${shipment.status}
                                                            </span>
                                                        </td>
                                                        <td>
                                                            <c:if test="${not empty shipment.createdAt}">
                                                                ${shipment.createdAt.toLocalDate()}
                                                            </c:if>
                                                        </td>
                                                        <td>
                                                            <a href="/driver/shipments/${shipment.id}" class="btn btn-sm btn-info">
                                                                <i class="fas fa-info-circle"></i> Details
                                                            </a>
                                                        </td>
                                                    </tr>
                                                </c:if>
                                            </c:forEach>
                                            <c:if test="${!hasDelivered}">
                                                <tr>
                                                    <td colspan="7" class="text-center">No delivered shipments found</td>
                                                </tr>
                                            </c:if>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                            
                            <div class="tab-pane fade" id="all-shipments" role="tabpanel" aria-labelledby="all-tab">
                                <div class="table-responsive">
                                    <table class="table table-hover">
                                        <thead>
                                            <tr>
                                                <th>ID</th>
                                                <th>Tracking Number</th>
                                                <th>Pickup</th>
                                                <th>Delivery</th>
                                                <th>Status</th>
                                                <th>Date</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:choose>
                                                <c:when test="${empty shipments}">
                                                    <tr>
                                                        <td colspan="7" class="text-center">No shipments found</td>
                                                    </tr>
                                                </c:when>
                                                <c:otherwise>
                                                    <c:forEach items="${shipments}" var="shipment">
                                                        <tr>
                                                            <td>${shipment.id}</td>
                                                            <td>${shipment.trackingNumber}</td>
                                                            <td>${shipment.pickupAddress}</td>
                                                            <td>${shipment.deliveryAddress}</td>
                                                            <td>
                                                                <span class="badge ${shipment.status == 'DELIVERED' ? 'bg-success' : shipment.status == 'IN_TRANSIT' ? 'bg-warning text-dark' : 'bg-primary'}">
                                                                    ${shipment.status}
                                                                </span>
                                                            </td>
                                                            <td>
                                                                <c:if test="${not empty shipment.createdAt}">
                                                                    ${shipment.createdAt.toLocalDate()}
                                                                </c:if>
                                                            </td>
                                                            <td>
                                                                <a href="/driver/shipments/${shipment.id}" class="btn btn-sm btn-info">
                                                                    <i class="fas fa-info-circle"></i> Details
                                                                </a>
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
                </div>
            </div>
        </div>
    </div>
    
    <jsp:include page="../layout/footer.jsp" />
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 