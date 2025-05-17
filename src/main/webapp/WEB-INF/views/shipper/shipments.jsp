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
    <link rel="stylesheet" href="https://cdn.datatables.net/1.11.5/css/dataTables.bootstrap5.min.css">
    <style>
        .shipment-card {
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
        }
        .shipment-header {
            background-color: #f8f9fa;
            padding: 15px;
            border-bottom: 1px solid #dee2e6;
        }
        .badge-lg {
            font-size: 14px;
            padding: 8px 12px;
        }
    </style>
</head>
<body>
    <jsp:include page="../layout/header.jsp" />
    
    <div class="container py-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1><i class="fas fa-box-open me-2"></i>My Shipments</h1>
            <a href="/shipper/create-shipment" class="btn btn-primary">
                <i class="fas fa-plus me-2"></i>Create New Shipment
            </a>
        </div>
        
        <div class="card shipment-card">
            <div class="card-body">
                <div class="table-responsive">
                    <table id="shipments-table" class="table table-hover">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Tracking Number</th>
                                <th>Origin</th>
                                <th>Destination</th>
                                <th>Weight (kg)</th>
                                <th>Status</th>
                                <th>Created Date</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty shipments}">
                                    <tr>
                                        <td colspan="8" class="text-center">No shipments found</td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach items="${shipments}" var="shipment">
                                        <tr>
                                            <td>${shipment.id}</td>
                                            <td>
                                                <span class="fw-bold">${shipment.trackingNumber}</span>
                                            </td>
                                            <td>${shipment.pickupAddress}</td>
                                            <td>${shipment.deliveryAddress}</td>
                                            <td>${shipment.weight}</td>
                                            <td>
                                                <span class="badge ${shipment.status == 'DELIVERED' ? 'bg-success' : shipment.status == 'IN_TRANSIT' ? 'bg-warning text-dark' : 'bg-primary'} badge-lg">
                                                    ${shipment.status}
                                                </span>
                                            </td>
                                            <td>
                                                <fmt:parseDate value="${shipment.createdAt}" pattern="yyyy-MM-dd'T'HH:mm:ss" var="parsedDate" type="both" />
                                                <fmt:formatDate value="${parsedDate}" pattern="MMM dd, yyyy" />
                                            </td>
                                            <td>
                                                <div class="btn-group" role="group">
                                                <!--
                                                    <a href="/shipper/tracking/${shipment.id}" class="btn btn-sm btn-info">
                                                        <i class="fas fa-map-marker-alt"></i> Track
                                                    </a>
                                                 -->
                                                    <button type="button" class="btn btn-sm btn-secondary" data-bs-toggle="modal" data-bs-target="#detailsModal${shipment.id}">
                                                        <i class="fas fa-info-circle"></i> Details
                                                    </button>
                                                </div>
                                                
                                                <!-- Details Modal -->
                                                <div class="modal fade" id="detailsModal${shipment.id}" tabindex="-1" aria-labelledby="detailsModalLabel${shipment.id}" aria-hidden="true">
                                                    <div class="modal-dialog modal-dialog-centered">
                                                        <div class="modal-content">
                                                            <div class="modal-header">
                                                                <h5 class="modal-title" id="detailsModalLabel${shipment.id}">Shipment Details</h5>
                                                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                            </div>
                                                            <div class="modal-body">
                                                                <div class="mb-3">
                                                                    <h6>Tracking Number:</h6>
                                                                    <p class="fw-bold">${shipment.trackingNumber}</p>
                                                                </div>
                                                                <div class="row mb-3">
                                                                    <div class="col-md-6">
                                                                        <h6>Origin:</h6>
                                                                        <p>${shipment.pickupAddress}</p>
                                                                    </div>
                                                                    <div class="col-md-6">
                                                                        <h6>Destination:</h6>
                                                                        <p>${shipment.deliveryAddress}</p>
                                                                    </div>
                                                                </div>
                                                                <div class="row mb-3">
                                                                    <div class="col-md-6">
                                                                        <h6>Weight (kg):</h6>
                                                                        <p>${shipment.weight}</p>
                                                                    </div>
                                                                    <div class="col-md-6">
                                                                        <h6>Status:</h6>
                                                                        <p><span class="badge ${shipment.status == 'DELIVERED' ? 'bg-success' : shipment.status == 'IN_TRANSIT' ? 'bg-warning text-dark' : 'bg-primary'}">${shipment.status}</span></p>
                                                                    </div>
                                                                </div>
                                                                <div class="row mb-3">
                                                                    <div class="col-md-6">
                                                                        <h6>Created Date:</h6>
                                                                        <p>
                                                                            <fmt:parseDate value="${shipment.createdAt}" pattern="yyyy-MM-dd'T'HH:mm:ss" var="parsedCreatedDate" type="both" />
                                                                            <fmt:formatDate value="${parsedCreatedDate}" pattern="MMM dd, yyyy HH:mm" />
                                                                        </p>
                                                                    </div>
                                                                    <div class="col-md-6">
                                                                        <h6>Last Updated:</h6>
                                                                        <p>
                                                                            <c:if test="${not empty shipment.updatedAt}">
                                                                                <fmt:parseDate value="${shipment.updatedAt}" pattern="yyyy-MM-dd'T'HH:mm:ss" var="parsedUpdatedDate" type="both" />
                                                                                <fmt:formatDate value="${parsedUpdatedDate}" pattern="MMM dd, yyyy HH:mm" />
                                                                            </c:if>
                                                                            <c:if test="${empty shipment.updatedAt}">
                                                                                Not updated yet
                                                                            </c:if>
                                                                        </p>
                                                                    </div>
                                                                </div>
                                                                <div class="mb-3">
                                                                    <h6>Goods Type:</h6>
                                                                    <p>${shipment.goodsType}</p>
                                                                </div>
                                                            </div>
                                                            <div class="modal-footer">
                                                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                                                                <a href="/shipper/tracking/${shipment.id}" class="btn btn-primary">Track Shipment</a>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
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
    
    <jsp:include page="../layout/footer.jsp" />
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.datatables.net/1.11.5/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.11.5/js/dataTables.bootstrap5.min.js"></script>
    <script>
        $(document).ready(function() {
            $('#shipments-table').DataTable({
                "order": [[ 6, "desc" ]],
                "language": {
                    "emptyTable": "No shipments found",
                    "zeroRecords": "No matching shipments found"
                }
            });
        });
    </script>
</body>
</html> 