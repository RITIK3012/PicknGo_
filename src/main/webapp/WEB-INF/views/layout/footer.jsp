    </main>
    <footer class="footer-glass py-4">
        <div class="container">
            <div class="row">
                <div class="col-md-4 mb-3">
                    <h5 class="fw-bold"><i class="fas fa-truck-loading me-2"></i>PicknGo</h5>
                    <p>Smart transportation and logistics platform connecting shippers with drivers for efficient goods transportation.</p>
                </div>
                <div class="col-md-3 mb-3">
                    <h5 class="fw-bold">Quick Links</h5>
                    <ul class="list-unstyled">
                        <li class="mb-2"><a href="/" class="btn-glass btn-sm w-100 text-center"><i class="fas fa-home me-2"></i>Home</a></li>
                        <li class="mb-2"><a href="/services" class="btn-glass btn-sm w-100 text-center"><i class="fas fa-truck me-2"></i>Services</a></li>
                        <li class="mb-2"><a href="/about" class="btn-glass btn-sm w-100 text-center"><i class="fas fa-info-circle me-2"></i>About Us</a></li>
                        <li class="mb-2"><a href="/contact" class="btn-glass btn-sm w-100 text-center"><i class="fas fa-envelope me-2"></i>Contact</a></li>
                    </ul>
                </div>
                <div class="col-md-3 mb-3">
                    <h5 class="fw-bold">Contact Us</h5>
                    <address class="mb-0">
                        <p class="mb-2 d-flex align-items-center">
                            <span class="btn-glass btn-glass-info btn-sm me-2"><i class="fas fa-map-marker-alt"></i></span>
                            123 Transport Street, Logistics City
                        </p>
                        <p class="mb-2 d-flex align-items-center">
                            <span class="btn-glass btn-glass-info btn-sm me-2"><i class="fas fa-phone"></i></span>
                            +91 9999999999
                        </p>
                        <p class="mb-2 d-flex align-items-center">
                            <span class="btn-glass btn-glass-info btn-sm me-2"><i class="fas fa-envelope"></i></span>
                            info@pickngo.com
                        </p>
                    </address>
                </div>
                <div class="col-md-2 mb-3">
                    <h5 class="fw-bold">Follow Us</h5>
                    <div class="social-icons d-flex flex-wrap">
                        <a href="#" class="btn-glass btn-glass-primary m-1"><i class="fab fa-facebook fa-lg"></i></a>
                        <a href="#" class="btn-glass btn-glass-info m-1"><i class="fab fa-twitter fa-lg"></i></a>
                        <a href="#" class="btn-glass btn-glass-danger m-1"><i class="fab fa-instagram fa-lg"></i></a>
                        <a href="#" class="btn-glass btn-glass-primary m-1"><i class="fab fa-linkedin fa-lg"></i></a>
                    </div>
                </div>
            </div>
            <hr class="my-3" style="border-color: rgba(255, 255, 255, 0.2);">
            <div class="text-center">
                <p class="mb-0">&copy; 2023 PicknGo. All rights reserved.</p>
            </div>
        </div>
    </footer>
    
    <!-- Toast Container for Notifications -->
    <div id="toastContainer" class="toast-container position-fixed bottom-0 end-0 p-3"></div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/jquery@3.6.0/dist/jquery.min.js"></script>
    <script src="/resources/js/scripts.js"></script>
    <script src="/resources/js/glass-ui.js"></script>
    <script>
        // Initialize any tooltips
        $(function () {
            const tooltipTriggerList = document.querySelectorAll('[data-bs-toggle="tooltip"]');
            const tooltipList = [...tooltipTriggerList].map(tooltipTriggerEl => new bootstrap.Tooltip(tooltipTriggerEl));
            
            // Add smooth scroll behavior
            document.querySelectorAll('a[href^="#"]').forEach(anchor => {
                anchor.addEventListener('click', function (e) {
                    e.preventDefault();
                    document.querySelector(this.getAttribute('href')).scrollIntoView({
                        behavior: 'smooth'
                    });
                });
            });
        });
    </script>
</body>
</html> 