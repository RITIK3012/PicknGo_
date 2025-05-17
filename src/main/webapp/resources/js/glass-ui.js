/**
 * PicknGo Glassmorphic UI Effects
 */
document.addEventListener('DOMContentLoaded', function() {
    // Glass card interactive effects
    const glassCards = document.querySelectorAll('.glass-card');
    
    glassCards.forEach(card => {
        // Create subtle movement effect on mouse move
        card.addEventListener('mousemove', function(e) {
            const rect = card.getBoundingClientRect();
            const x = e.clientX - rect.left;
            const y = e.clientY - rect.top;
            
            const centerX = rect.width / 2;
            const centerY = rect.height / 2;
            
            const moveX = (x - centerX) / centerX * 5;
            const moveY = (y - centerY) / centerY * 5;
            
            card.style.transform = `perspective(1000px) rotateX(${-moveY}deg) rotateY(${moveX}deg) scale3d(1.02, 1.02, 1.02)`;
            card.style.boxShadow = `0 8px 30px rgba(0, 0, 0, 0.1), ${moveX * 0.5}px ${moveY * 0.5}px 15px rgba(0, 0, 0, 0.05)`;
            
            // Add subtle gradient lighting effect
            const gradientX = (x / rect.width) * 100;
            const gradientY = (y / rect.height) * 100;
            card.style.background = `radial-gradient(circle at ${gradientX}% ${gradientY}%, rgba(255,255,255,0.25) 0%, rgba(255,255,255,0.15) 80%)`;
        });
        
        // Reset effects when mouse leaves
        card.addEventListener('mouseleave', function() {
            card.style.transform = 'perspective(1000px) rotateX(0) rotateY(0) scale3d(1, 1, 1)';
            card.style.boxShadow = 'var(--glass-shadow)';
            card.style.background = 'var(--glass-bg)';
        });
        
        // Animation when clicked
        card.addEventListener('click', function(e) {
            // Don't apply effect if clicking on buttons or inputs inside card
            if (e.target.closest('button, a, input, select, textarea')) return;
            
            card.classList.add('glass-card-clicked');
            setTimeout(() => {
                card.classList.remove('glass-card-clicked');
            }, 300);
        });
    });
    
    // Add background particle effect
    createParticles();
    
    // Add cursor special effect
    createGlowingCursor();
});

/**
 * Creates floating particles in the background for a more dynamic feel
 */
function createParticles() {
    const particleContainer = document.createElement('div');
    particleContainer.className = 'glass-background-particles';
    particleContainer.style.position = 'fixed';
    particleContainer.style.top = '0';
    particleContainer.style.left = '0';
    particleContainer.style.width = '100%';
    particleContainer.style.height = '100%';
    particleContainer.style.zIndex = '-1';
    particleContainer.style.pointerEvents = 'none';
    document.body.appendChild(particleContainer);
    
    const particleCount = 20;
    
    for (let i = 0; i < particleCount; i++) {
        const particle = document.createElement('div');
        particle.className = 'glass-particle';
        particle.style.position = 'absolute';
        particle.style.width = Math.random() * 10 + 5 + 'px';
        particle.style.height = particle.style.width;
        particle.style.background = 'rgba(255, 255, 255, 0.2)';
        particle.style.borderRadius = '50%';
        particle.style.backdropFilter = 'blur(1px)';
        
        // Random starting position
        particle.style.left = Math.random() * 100 + 'vw';
        particle.style.top = Math.random() * 100 + 'vh';
        
        // Create animation with random duration
        const duration = Math.random() * 30 + 20; // 20-50 seconds
        particle.style.animation = `floatParticle ${duration}s ease-in-out infinite`;
        particle.style.animationDelay = `-${Math.random() * duration}s`;
        
        particleContainer.appendChild(particle);
    }
    
    // Add keyframes for the float animation
    const style = document.createElement('style');
    style.textContent = `
        @keyframes floatParticle {
            0%, 100% {
                transform: translate(0, 0) rotate(0deg);
                opacity: 0;
            }
            10%, 90% {
                opacity: 0.8;
            }
            50% {
                transform: translate(${Math.random() * 30 - 15}vw, ${Math.random() * 30 - 15}vh) rotate(180deg);
                opacity: 0.3;
            }
        }
        
        .glass-card-clicked {
            transform: scale(0.98) !important;
            transition: transform 0.3s ease !important;
        }
    `;
    document.head.appendChild(style);
}

/**
 * Creates a subtle glowing effect that follows the cursor
 */
function createGlowingCursor() {
    const cursor = document.createElement('div');
    cursor.className = 'glass-cursor';
    cursor.style.position = 'fixed';
    cursor.style.width = '40px';
    cursor.style.height = '40px';
    cursor.style.borderRadius = '50%';
    cursor.style.background = 'radial-gradient(circle, rgba(255,255,255,0.4) 0%, rgba(255,255,255,0) 70%)';
    cursor.style.pointerEvents = 'none';
    cursor.style.transform = 'translate(-50%, -50%)';
    cursor.style.zIndex = '9999';
    cursor.style.opacity = '0';
    cursor.style.transition = 'opacity 0.3s ease';
    document.body.appendChild(cursor);
    
    document.addEventListener('mousemove', e => {
        cursor.style.left = e.clientX + 'px';
        cursor.style.top = e.clientY + 'px';
        cursor.style.opacity = '1';
    });
    
    document.addEventListener('mouseout', () => {
        cursor.style.opacity = '0';
    });
} 