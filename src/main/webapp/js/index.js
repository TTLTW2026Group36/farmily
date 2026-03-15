
const slides = document.querySelectorAll('.slide');
const sliderDots = document.querySelector('.slider-dots');
const prevBtn = document.querySelector('.slider-btn.prev');
const nextBtn = document.querySelector('.slider-btn.next');

if (slides.length > 0 && sliderDots) {
    let currentSlide = 0;
    let slideInterval;

    
    slides.forEach((_, index) => {
        const dot = document.createElement('div');
        dot.classList.add('dot');
        if (index === 0) dot.classList.add('active');
        dot.addEventListener('click', () => goToSlide(index));
        sliderDots.appendChild(dot);
    });

    const dots = document.querySelectorAll('.dot');

    function goToSlide(n) {
        slides[currentSlide].classList.remove('active');
        dots[currentSlide].classList.remove('active');
        
        currentSlide = n;
        if (currentSlide >= slides.length) currentSlide = 0;
        if (currentSlide < 0) currentSlide = slides.length - 1;
        
        slides[currentSlide].classList.add('active');
        dots[currentSlide].classList.add('active');
    }

    function nextSlide() {
        goToSlide(currentSlide + 1);
    }

    function prevSlide() {
        goToSlide(currentSlide - 1);
    }

    
    if (nextBtn) nextBtn.addEventListener('click', nextSlide);
    if (prevBtn) prevBtn.addEventListener('click', prevSlide);

    
    function startSlideShow() {
        slideInterval = setInterval(nextSlide, 5000);
    }

    function stopSlideShow() {
        clearInterval(slideInterval);
    }

    startSlideShow();

    const sliderContainer = document.querySelector('.slider-container');
    if (sliderContainer) {
        sliderContainer.addEventListener('mouseenter', stopSlideShow);
        sliderContainer.addEventListener('mouseleave', startSlideShow);
    }

    
    document.addEventListener('keydown', (e) => {
        if (e.key === 'ArrowLeft') prevSlide();
        if (e.key === 'ArrowRight') nextSlide();
    });
}


function updateCountdown() {
    const hoursEl = document.getElementById('hours');
    const minutesEl = document.getElementById('minutes');
    const secondsEl = document.getElementById('seconds');
    
    if (!hoursEl || !minutesEl || !secondsEl) return;
    
    const now = new Date();
    const endTime = new Date();
    endTime.setHours(23, 59, 59, 999);
    
    const diff = endTime - now;
    
    const hours = Math.floor(diff / (1000 * 60 * 60));
    const minutes = Math.floor((diff % (1000 * 60 * 60)) / (1000 * 60));
    const seconds = Math.floor((diff % (1000 * 60)) / 1000);
    
    hoursEl.textContent = String(hours).padStart(2, '0');
    minutesEl.textContent = String(minutes).padStart(2, '0');
    secondsEl.textContent = String(seconds).padStart(2, '0');
}

updateCountdown();
setInterval(updateCountdown, 1000);


document.querySelectorAll('.tab-btn').forEach(btn => {
    btn.addEventListener('click', function() {
        document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
        this.classList.add('active');
        
        const category = this.dataset.category;
        console.log('Filter by:', category);
    });
});


document.querySelectorAll('.wishlist-btn').forEach(btn => {
    btn.addEventListener('click', function(e) {
        e.preventDefault();
        e.stopPropagation();
        this.classList.toggle('active');
        
        if (this.classList.contains('active')) {
            this.style.animation = 'heartBeat 0.5s';
            setTimeout(() => this.style.animation = '', 500);
        }
    });
});





const loadMoreBtn = document.querySelector('.btn-load-more');
if (loadMoreBtn) {
    loadMoreBtn.addEventListener('click', function() {
        this.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang tải...';
        this.disabled = true;
        
        setTimeout(() => {
            this.innerHTML = 'Xem thêm sản phẩm <i class="fas fa-chevron-down"></i>';
            this.disabled = false;
            alert('Đã tải thêm sản phẩm!');
        }, 1000);
    });
}


const heartBeatStyle = document.createElement('style');
heartBeatStyle.textContent = `
    @keyframes heartBeat {
        0%, 100% { transform: scale(1); }
        25% { transform: scale(1.3); }
        50% { transform: scale(1.1); }
        75% { transform: scale(1.2); }
    }
`;
document.head.appendChild(heartBeatStyle);


const flashProductsScroll = document.querySelector('.flash-products-scroll');
const flashPrevBtn = document.querySelector('.flash-prev');
const flashNextBtn = document.querySelector('.flash-next');

if (flashProductsScroll && flashPrevBtn && flashNextBtn) {
    const scrollAmount = 250; 

    flashNextBtn.addEventListener('click', () => {
        flashProductsScroll.scrollBy({
            left: scrollAmount,
            behavior: 'smooth'
        });
    });

    flashPrevBtn.addEventListener('click', () => {
        flashProductsScroll.scrollBy({
            left: -scrollAmount,
            behavior: 'smooth'
        });
    });

    
    function updateScrollButtons() {
        const scrollLeft = flashProductsScroll.scrollLeft;
        const maxScroll = flashProductsScroll.scrollWidth - flashProductsScroll.clientWidth;

        
        flashPrevBtn.disabled = scrollLeft <= 0;
        
        
        flashNextBtn.disabled = scrollLeft >= maxScroll - 1;
    }

    
    updateScrollButtons();

    
    flashProductsScroll.addEventListener('scroll', updateScrollButtons);

    
    window.addEventListener('resize', updateScrollButtons);
}