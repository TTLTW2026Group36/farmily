(function () {
  'use strict';

  document.addEventListener('DOMContentLoaded', function () {
    var header = document.querySelector('header');
    if (header) {
      var checkScroll = function () {
        if (window.scrollY > 20) {
          header.classList.add('scrolled');
        } else {
          header.classList.remove('scrolled');
        }
      };
      window.addEventListener('scroll', checkScroll);
      checkScroll();
    }

    var hamburger = document.getElementById('hamburger-btn');
    var miniNav = document.querySelector('header .mini-nav');
    var mobileSearchBar = document.querySelector('.mobile-search-bar');

    if (!hamburger || !miniNav) return;

    function openMenu() {
      miniNav.classList.add('mobile-open');
      hamburger.setAttribute('aria-expanded', 'true');
      hamburger.innerHTML = '<i class="fa-solid fa-xmark"></i>';
      if (mobileSearchBar) mobileSearchBar.style.display = 'block';
    }

    function closeMenu() {
      miniNav.classList.remove('mobile-open');
      hamburger.setAttribute('aria-expanded', 'false');
      hamburger.innerHTML = '<i class="fa-solid fa-bars"></i>';
      if (mobileSearchBar) mobileSearchBar.style.display = 'none';
    }

    hamburger.addEventListener('click', function (e) {
      e.stopPropagation();
      if (miniNav.classList.contains('mobile-open')) {
        closeMenu();
      } else {
        openMenu();
      }
    });

    document.addEventListener('click', function (e) {
      var isClickInsideSearch = mobileSearchBar && mobileSearchBar.contains(e.target);
      if (!miniNav.contains(e.target) && !hamburger.contains(e.target) && !isClickInsideSearch) {
        closeMenu();
      }
    });

    window.addEventListener('resize', function () {
      if (window.innerWidth > 768) {
        closeMenu();
      }
    });
  });
})();
