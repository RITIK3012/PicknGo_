<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Shipment Tracking - Admin Dashboard - PicknGo</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        #map {
            height: 400px;
            width: 100%;
            border-radius: 10px;
            margin-bottom: 20px;
        }
        .timeline {
            position: relative;
            max-width: 1200px;
            margin: 0 auto;
        }
        .timeline::after {
            content: '';
            position: absolute;
            width: 6px;
            background-color: #007bff;
            top: 0;
            bottom: 0;
            left: 50%;
            margin-left: -3px;
        }
        .container-timeline {
            padding: 10px 40px;
            position: relative;
            background-color: inherit;
            width: 50%;
        }
        .container-timeline::after {
            content: '';
            position: absolute;
            width: 25px;
            height: 25px;
            right: -17px;
            background-color: white;
            border: 4px solid #007bff;
            top: 15px;
            border-radius: 50%;
            z-index: 1;
        }
        .left {
            left: 0;
        }
        .right {
            left: 50%;
        }
        .left::before {
            content: " ";
            height: 0;
            position: absolute;
            top: 22px;
            width: 0;
            z-index: 1;
            right: 30px;
            border: medium solid #fff;
            border-width: 10px 0 10px 10px;
            border-color: transparent transparent transparent #fff;
        }
        .right::before {
            content: " ";
            height: 0;
            position: absolute;
            top: 22px;
            width: 0;
            z-index: 1;
            left: 30px;
            border: medium solid #fff;
            border-width: 10px 10px 10px 0;
            border-color: transparent #fff transparent transparent;
        }
        .right::after {
            left: -16px;
        }
        .content {
            padding: 20px 30px;
            background-color: white;
            position: relative;
            border-radius: 6px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
        .tracking-status {
            font-size: 1.5rem;
            margin-bottom: 20px;
            padding: 10px 20px;
            border-radius: 5px;
        }
    </style>
</head>
<body>
    <jsp:include page="../layout/header.jsp" />
    
    <div class="container py-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1><i class="fas fa-map-marker-alt me-2"></i>Shipment Tracking</h1>
            <a href="/admin/shipments" class="btn btn-outline-primary">
                <i class="fas fa-arrow-left me-2"></i>Back to Shipments
            </a>
        </div>
        
        <div class="row">
            <div class="col-md-8">
                <div class="card mb-4">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0">Location Tracking</h5>
                    </div>
                    <div class="card-body">
                        <div id="map"></div>
                        <div class="alert alert-primary text-center" role="alert">
                            <c:choose>
                                <c:when test="${latestLocation != null}">
                                    <strong>Last Updated:</strong> ${latestLocation.timestamp}
                                </c:when>
                                <c:otherwise>
                                    No location data available yet.
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
                
                <div class="card">
                    <div class="card-header bg-info text-white">
                        <h5 class="mb-0">Shipment Timeline</h5>
                    </div>
                    <div class="card-body">
                        <div class="timeline">
                            <div class="container-timeline left">
                                <div class="content">
                                    <h2>Order Created</h2>
                                    <p><c:if test="${not empty shipment.createdAt}">
                                        ${shipment.createdAt}
                                    </c:if></p>
                                    <p>Shipment #${shipment.trackingNumber} was created by ${shipment.shipper.name}</p>
                                </div>
                            </div>
                            <c:if test="${shipment.status != 'PENDING'}">
                                <div class="container-timeline right">
                                    <div class="content">
                                        <h2>Driver Assigned</h2>
                                        <p><c:if test="${not empty shipment.updatedAt}">
                                            ${shipment.updatedAt}
                                        </c:if></p>
                                        <p>Driver ${shipment.driver.name} has been assigned to this shipment</p>
                                    </div>
                                </div>
                            </c:if>
                            <c:if test="${shipment.status == 'PICKED_UP' || shipment.status == 'IN_TRANSIT' || shipment.status == 'DELIVERED'}">
                                <div class="container-timeline left">
                                    <div class="content">
                                        <h2>Picked Up</h2>
                                        <p><c:if test="${not empty shipment.pickupTime}">
                                            ${shipment.pickupTime}
                                        </c:if></p>
                                        <p>Package has been picked up from ${shipment.pickupAddress}</p>
                                    </div>
                                </div>
                            </c:if>
                            <c:if test="${shipment.status == 'DELIVERED'}">
                                <div class="container-timeline right">
                                    <div class="content">
                                        <h2>Delivered</h2>
                                        <p><c:if test="${not empty shipment.deliveryTime}">
                                            ${shipment.deliveryTime}
                                        </c:if></p>
                                        <p>Package has been delivered to ${shipment.deliveryAddress}</p>
                                    </div>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="col-md-4">
                <div class="card mb-4">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0">Shipment Details</h5>
                    </div>
                    <div class="card-body">
                        <div class="tracking-status ${shipment.status == 'DELIVERED' ? 'bg-success text-white' : 
                            shipment.status == 'IN_TRANSIT' ? 'bg-warning' : 
                            shipment.status == 'PICKED_UP' ? 'bg-info text-white' : 'bg-primary text-white'}">
                            Status: ${shipment.status}
                        </div>
                        <dl class="row">
                            <dt class="col-sm-5">Tracking Number:</dt>
                            <dd class="col-sm-7">${shipment.trackingNumber}</dd>
                            
                            <dt class="col-sm-5">Goods Type:</dt>
                            <dd class="col-sm-7">${shipment.goodsType}</dd>
                            
                            <dt class="col-sm-5">Weight:</dt>
                            <dd class="col-sm-7">${shipment.weight} kg</dd>
                            
                            <dt class="col-sm-5">Price:</dt>
                            <dd class="col-sm-7">$${shipment.price}</dd>
                            
                            <dt class="col-sm-5">Origin:</dt>
                            <dd class="col-sm-7">${shipment.pickupAddress}</dd>
                            
                            <dt class="col-sm-5">Destination:</dt>
                            <dd class="col-sm-7">${shipment.deliveryAddress}</dd>
                            
                            <dt class="col-sm-5">Shipper:</dt>
                            <dd class="col-sm-7">${shipment.shipper.name}</dd>
                            
                            <dt class="col-sm-5">Driver:</dt>
                            <dd class="col-sm-7">${shipment.driver != null ? shipment.driver.name : 'Not assigned yet'}</dd>
                        </dl>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <jsp:include page="../layout/footer.jsp" />
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://maps.googleapis.com/maps/api/js?key=YOUR_API_KEY&callback=initMap" async defer></script>
    <script>
        function initMap() {
            // Default location - can be the pickup location if no tracking data
            let mapCenter = {
                lat: ${latestLocation != null ? latestLocation.latitude : shipment.pickupLatitude != null ? shipment.pickupLatitude : 0},
                lng: ${latestLocation != null ? latestLocation.longitude : shipment.pickupLongitude != null ? shipment.pickupLongitude : 0}
            };
            
            // Create map
            const map = new google.maps.Map(document.getElementById("map"), {
                zoom: 13,
                center: mapCenter,
            });
            
            // Create markers
            <c:if test="${shipment.pickupLatitude != null && shipment.pickupLongitude != null}">
                new google.maps.Marker({
                    position: { lat: ${shipment.pickupLatitude}, lng: ${shipment.pickupLongitude} },
                    map,
                    title: "Pickup Location",
                    icon: "http://maps.google.com/mapfiles/ms/icons/green-dot.png"
                });
            </c:if>
            
            <c:if test="${shipment.deliveryLatitude != null && shipment.deliveryLongitude != null}">
                new google.maps.Marker({
                    position: { lat: ${shipment.deliveryLatitude}, lng: ${shipment.deliveryLongitude} },
                    map,
                    title: "Delivery Location",
                    icon: "http://maps.google.com/mapfiles/ms/icons/red-dot.png"
                });
            </c:if>
            
            <c:if test="${latestLocation != null}">
                new google.maps.Marker({
                    position: { lat: ${latestLocation.latitude}, lng: ${latestLocation.longitude} },
                    map,
                    title: "Current Location",
                    icon: "http://maps.google.com/mapfiles/ms/icons/blue-dot.png"
                });
            </c:if>
        }
    </script>
</body>
</html> 