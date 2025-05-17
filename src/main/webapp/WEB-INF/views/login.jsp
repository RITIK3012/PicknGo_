<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="title" value="Login" />
<%@ include file="layout/header.jsp" %>

<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-md-6">
            <div class="card auth-card">
                <div class="auth-header text-center py-4">
                    <h3 class="mb-0"><i class="fas fa-sign-in-alt me-2"></i> Login to PicknGo</h3>
                </div>
                <div class="card-body p-4">
                    <c:if test="${param.error != null}">
                        <div class="alert alert-danger">
                            <i class="fas fa-exclamation-circle me-2"></i> Invalid email or password
                        </div>
                    </c:if>
                    <c:if test="${param.logout != null}">
                        <div class="alert alert-success">
                            <i class="fas fa-check-circle me-2"></i> You have been logged out successfully
                        </div>
                    </c:if>
                    <c:if test="${not empty success}">
                        <div class="alert alert-success">
                            <i class="fas fa-check-circle me-2"></i> ${success}
                        </div>
                    </c:if>
                    
                    <form action="/login" method="post" class="needs-validation" novalidate>
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                        
                        <div class="mb-3">
                            <label for="email" class="form-label required">Email</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fas fa-envelope"></i></span>
                                <input type="email" class="form-control" id="email" name="username" placeholder="Enter your email" required>
                            </div>
                            <div class="invalid-feedback">
                                Please enter a valid email address
                            </div>
                        </div>
                        
                        <div class="mb-3">
                            <label for="password" class="form-label required">Password</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fas fa-lock"></i></span>
                                <input type="password" class="form-control" id="password" name="password" placeholder="Enter your password" required>
                                <button class="btn btn-outline-secondary password-toggle" type="button">
                                    <i class="fas fa-eye"></i>
                                </button>
                            </div>
                            <div class="invalid-feedback">
                                Please enter your password
                            </div>
                        </div>
                        
                        <div class="mb-3 form-check">
                            <input type="checkbox" class="form-check-input" id="remember-me" name="remember-me">
                            <label class="form-check-label" for="remember-me">Remember Me</label>
                        </div>
                        
                        <div class="d-grid gap-2">
                            <button type="submit" class="btn btn-primary btn-lg">
                                <i class="fas fa-sign-in-alt me-2"></i> Login
                            </button>
                        </div>
                    </form>
                    
                    <div class="text-center mt-4">
                        <p>Don't have an account yet? <a href="/register">Register Now</a></p>
                    </div>
                    
                    <hr class="my-4">
                    
                    <div class="row g-2">
                        <div class="col-md-6 mb-2">
                            <a href="/register/shipper" class="btn btn-outline-primary d-block">
                                <i class="fas fa-box me-2"></i> Register as Shipper
                            </a>
                        </div>
                        <div class="col-md-6 mb-2">
                            <a href="/register/driver" class="btn btn-outline-primary d-block">
                                <i class="fas fa-truck me-2"></i> Register as Driver
                            </a>
                        </div>
                        <div class="col-md-6 mb-2">
                            <a href="/register/vendor" class="btn btn-outline-primary d-block">
                                <i class="fas fa-building me-2"></i> Register as Vendor
                            </a>
                        </div>
                        <div class="col-md-6 mb-2">
                            <a href="/register/customer" class="btn btn-outline-primary d-block">
                                <i class="fas fa-user me-2"></i> Register as Customer
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="layout/footer.jsp" %> 