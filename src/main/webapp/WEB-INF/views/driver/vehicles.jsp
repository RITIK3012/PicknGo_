<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Vehicles - PicknGo</title>
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
                        <a href="/driver/shipments" class="list-group-item list-group-item-action">
                            <i class="fas fa-box me-2"></i>Shipments
                        </a>
                        <a href="/driver/vehicles" class="list-group-item list-group-item-action active">
                            <i class="fas fa-truck me-2"></i>Vehicles
                        </a>
                    </div>
                </div>
            </div>
            <div class="col-md-9">
                <div class="card mb-4">
                    <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
                        <h5 class="mb-0"><i class="fas fa-truck me-2"></i>My Vehicles</h5>
                        <button class="btn btn-light btn-sm" data-bs-toggle="modal" data-bs-target="#addVehicleModal">
                            <i class="fas fa-plus me-2"></i>Add Vehicle
                        </button>
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
                        
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th>Vehicle No.</th>
                                        <th>Type</th>
                                        <th>Make & Model</th>
                                        <th>Load Capacity</th>
                                        <th>Status</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${empty vehicles}">
                                            <tr>
                                                <td colspan="6" class="text-center">No vehicles added yet</td>
                                            </tr>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach items="${vehicles}" var="vehicle">
                                                <tr>
                                                    <td>${vehicle.vehicleNumber}</td>
                                                    <td>${vehicle.vehicleType}</td>
                                                    <td>${vehicle.make} ${vehicle.model} ${vehicle.year}</td>
                                                    <td>${vehicle.loadCapacity} kg</td>
                                                    <td>
                                                        <span class="badge ${vehicle.active ? 'bg-success' : 'bg-secondary'}">
                                                            ${vehicle.active ? 'Active' : 'Inactive'}
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <button class="btn btn-sm btn-primary edit-vehicle" 
                                                                data-id="${vehicle.id}" 
                                                                data-vehicle-number="${vehicle.vehicleNumber}"
                                                                data-vehicle-type="${vehicle.vehicleType}"
                                                                data-make="${vehicle.make}"
                                                                data-model="${vehicle.model}"
                                                                data-year="${vehicle.year}"
                                                                data-load-capacity="${vehicle.loadCapacity}"
                                                                data-active="${vehicle.active}"
                                                                data-bs-toggle="modal" 
                                                                data-bs-target="#editVehicleModal">
                                                            <i class="fas fa-edit"></i>
                                                        </button>
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
    
    <!-- Add Vehicle Modal -->
    <div class="modal fade" id="addVehicleModal" tabindex="-1" aria-labelledby="addVehicleModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <form:form action="/driver/add-vehicle" method="post" modelAttribute="newVehicle" class="needs-validation" novalidate="true">
                    <div class="modal-header">
                        <h5 class="modal-title" id="addVehicleModalLabel">Add New Vehicle</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="vehicleNumber" class="form-label">Vehicle Number</label>
                                <form:input path="vehicleNumber" type="text" class="form-control" id="vehicleNumber" required="true" />
                                <div class="invalid-feedback">Please enter vehicle number</div>
                            </div>
                            <div class="col-md-6">
                                <label for="vehicleType" class="form-label">Vehicle Type</label>
                                <form:select path="vehicleType" class="form-select" id="vehicleType" required="true">
                                    <form:option value="" label="Select vehicle type" />
                                    <form:option value="TRUCK" label="Truck" />
                                    <form:option value="VAN" label="Van" />
                                    <form:option value="PICKUP" label="Pickup" />
                                    <form:option value="CAR" label="Car" />
                                </form:select>
                                <div class="invalid-feedback">Please select vehicle type</div>
                            </div>
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-4">
                                <label for="make" class="form-label">Make</label>
                                <form:input path="make" type="text" class="form-control" id="make" />
                            </div>
                            <div class="col-md-4">
                                <label for="model" class="form-label">Model</label>
                                <form:input path="model" type="text" class="form-control" id="model" />
                            </div>
                            <div class="col-md-4">
                                <label for="year" class="form-label">Year</label>
                                <form:input path="year" type="number" class="form-control" id="year" />
                            </div>
                        </div>
                        <div class="mb-3">
                            <label for="loadCapacity" class="form-label">Load Capacity (kg)</label>
                            <form:input path="loadCapacity" type="number" step="0.01" class="form-control" id="loadCapacity" required="true" />
                            <div class="invalid-feedback">Please enter load capacity</div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">Add Vehicle</button>
                    </div>
                </form:form>
            </div>
        </div>
    </div>
    
    <!-- Edit Vehicle Modal -->
    <div class="modal fade" id="editVehicleModal" tabindex="-1" aria-labelledby="editVehicleModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <form action="/driver/update-vehicle" method="post" class="needs-validation" novalidate="true">
                    <div class="modal-header">
                        <h5 class="modal-title" id="editVehicleModalLabel">Edit Vehicle</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <input type="hidden" name="id" id="edit-id">
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="edit-vehicleNumber" class="form-label">Vehicle Number</label>
                                <input name="vehicleNumber" type="text" class="form-control" id="edit-vehicleNumber" required>
                                <div class="invalid-feedback">Please enter vehicle number</div>
                            </div>
                            <div class="col-md-6">
                                <label for="edit-vehicleType" class="form-label">Vehicle Type</label>
                                <select name="vehicleType" class="form-select" id="edit-vehicleType" required>
                                    <option value="">Select vehicle type</option>
                                    <option value="TRUCK">Truck</option>
                                    <option value="VAN">Van</option>
                                    <option value="PICKUP">Pickup</option>
                                    <option value="CAR">Car</option>
                                </select>
                                <div class="invalid-feedback">Please select vehicle type</div>
                            </div>
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-4">
                                <label for="edit-make" class="form-label">Make</label>
                                <input name="make" type="text" class="form-control" id="edit-make">
                            </div>
                            <div class="col-md-4">
                                <label for="edit-model" class="form-label">Model</label>
                                <input name="model" type="text" class="form-control" id="edit-model">
                            </div>
                            <div class="col-md-4">
                                <label for="edit-year" class="form-label">Year</label>
                                <input name="year" type="number" class="form-control" id="edit-year">
                            </div>
                        </div>
                        <div class="mb-3">
                            <label for="edit-loadCapacity" class="form-label">Load Capacity (kg)</label>
                            <input name="loadCapacity" type="number" step="0.01" class="form-control" id="edit-loadCapacity" required>
                            <div class="invalid-feedback">Please enter load capacity</div>
                        </div>
                        <div class="mb-3 form-check">
                            <input name="active" type="checkbox" class="form-check-input" id="edit-active">
                            <label class="form-check-label" for="edit-active">Active</label>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">Save Changes</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <jsp:include page="../layout/footer.jsp" />
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Form validation
        (function() {
            'use strict';
            var forms = document.querySelectorAll('.needs-validation');
            Array.from(forms).forEach(function(form) {
                form.addEventListener('submit', function(event) {
                    if (!form.checkValidity()) {
                        event.preventDefault();
                        event.stopPropagation();
                    }
                    form.classList.add('was-validated');
                }, false);
            });
        })();
        
        // Edit vehicle modal data population
        document.querySelectorAll('.edit-vehicle').forEach(button => {
            button.addEventListener('click', function() {
                const id = this.getAttribute('data-id');
                const vehicleNumber = this.getAttribute('data-vehicle-number');
                const vehicleType = this.getAttribute('data-vehicle-type');
                const make = this.getAttribute('data-make');
                const model = this.getAttribute('data-model');
                const year = this.getAttribute('data-year');
                const loadCapacity = this.getAttribute('data-load-capacity');
                const active = this.getAttribute('data-active') === 'true';
                
                document.getElementById('edit-id').value = id;
                document.getElementById('edit-vehicleNumber').value = vehicleNumber;
                document.getElementById('edit-vehicleType').value = vehicleType;
                document.getElementById('edit-make').value = make;
                document.getElementById('edit-model').value = model;
                document.getElementById('edit-year').value = year;
                document.getElementById('edit-loadCapacity').value = loadCapacity;
                document.getElementById('edit-active').checked = active;
            });
        });
    </script>
</body>
</html> 