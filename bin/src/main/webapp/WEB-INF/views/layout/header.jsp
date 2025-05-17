<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PicknGo - ${title}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.2.1/css/all.min.css">
    <link rel="stylesheet" href="/css/styles.css">
</head>
<body>
    <header>
        <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
            <div class="container">
                <a class="navbar-brand" href="/">
                    <strong>PicknGo</strong>
                </a>
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse" id="navbarNav">
                    <ul class="navbar-nav me-auto">
                        <li class="nav-item">
                            <a class="nav-link" href="/"><i class="fas fa-home"></i> Home</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="/services"><i class="fas fa-truck"></i> Services</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="/about"><i class="fas fa-info-circle"></i> About Us</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="/contact"><i class="fas fa-envelope"></i> Contact</a>
                        </li>
                    </ul>
                    <ul class="navbar-nav ms-auto">
                        <sec:authorize access="!isAuthenticated()">
                            <li class="nav-item">
                                <a class="nav-link" href="/register"><i class="fas fa-user-plus"></i> Register</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="/login"><i class="fas fa-sign-in-alt"></i> Login</a>
                            </li>
                        </sec:authorize>
                        <sec:authorize access="isAuthenticated()">
                            <li class="nav-item dropdown">
                                <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" 
                                   data-bs-toggle="dropdown" aria-expanded="false">
                                    <i class="fas fa-user-circle"></i> <sec:authentication property="name" />
                                </a>
                                <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="navbarDropdown">
                                    <sec:authorize access="hasRole('ADMIN')">
                                        <li><a class="dropdown-item" href="/admin/dashboard"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
                                    </sec:authorize>
                                    <sec:authorize access="hasRole('SHIPPER')">
                                        <li><a class="dropdown-item" href="/shipper/dashboard"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
                                    </sec:authorize>
                                    <sec:authorize access="hasRole('DRIVER')">
                                        <li><a class="dropdown-item" href="/driver/dashboard"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
                                    </sec:authorize>
                                    <sec:authorize access="hasRole('VENDOR')">
                                        <li><a class="dropdown-item" href="/vendor/dashboard"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
                                    </sec:authorize>
                                    <sec:authorize access="hasRole('CUSTOMER')">
                                        <li><a class="dropdown-item" href="/customer/dashboard"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
                                    </sec:authorize>
                                    <li><a class="dropdown-item" href="/profile"><i class="fas fa-user-cog"></i> Profile</a></li>
                                    <li><hr class="dropdown-divider"></li>
                                    <li>
                                        <form action="/logout" method="post" id="logoutForm">
                                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                            <button class="dropdown-item" type="submit"><i class="fas fa-sign-out-alt"></i> Logout</button>
                                        </form>
                                    </li>
                                </ul>
                            </li>
                        </sec:authorize>
                    </ul>
                </div>
            </div>
        </nav>
    </header>
    <main class="container my-4"> 