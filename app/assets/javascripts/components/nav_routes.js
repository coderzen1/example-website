modulejs.define('nav_routes', function() {

  $(function() {
    'use strict';

    $('body').scrollspy({
      target: '.four-tab-nav'
    });

    $('.panel').on('click', function() {
      $('.panel-heading').addClass('shown');
    });

    foodFaveApp.routes = (function() {
      var navpos;
      var activeSection;
      var previousSection;


      function _getActiveSection() {
        var $navTab = $('.__tab.active .__tab-name');
        if ($navTab.hasClass('nav-3')) {
          return foodFaveApp.phoneSlides;
        } else if ($navTab.hasClass('nav-4')) {
          return foodFaveApp.findFave;
        } else if ($navTab.hasClass('nav-5')) {
          return foodFaveApp.explorePlaces;
        } else {
          return null;
        }
      }

      $('.__tab-name').on('click', function(e) {
        e.preventDefault();
        var elemId;

        if (e.target.classList.contains('nav-3')) {
          elemId = "#nav3";
        } else if (e.target.classList.contains('nav-4')) {
          elemId = "#nav4";
        } else if (e.target.classList.contains('nav-5')) {
          elemId = "#nav5";
        } else {
          elemId = "#nav6";
        }

        $('body,html').animate({
          scrollTop: $(elemId).offset().top
        }, 1000);

        $('.four-tab-nav').find('div.active').removeClass('active');
        $(e.target).parent().addClass('active');
      });

      $('.__tab-name').mouseover(function() {
        $(this).parent().find('div.__tab-border').addClass('__active');
      });

      $('.__tab-name').mouseleave(function() {
        var $this = $(this);

        if ($this.parent().find('div.__tab-border').hasClass('__active')) {
          $this.parent().find('div.__tab-border').removeClass('__active');
        }
      });

      function fixNavToTop() {
        var x;
        var $nav = $('.four-tab-nav:not(.fixed)');
        if ($nav.length) {
          navpos = $nav.offset();
        }

        if ($(window).scrollTop() > navpos.top) {
          $('.four-tab-nav').addClass('fixed');
          $('.crave-or-not-js').addClass('padding-top');
        } else {
          $('.four-tab-nav').removeClass('fixed');
          $('.crave-or-not-js').removeClass('padding-top');

          x = _getActiveSection();
          if (x === null) {
            foodFaveApp.phoneSlides.pause();
          }
        }

        if (window.innerWidth < 768) {
          $('.crave-or-not-js').removeClass('padding-top');
          foodFaveApp.phoneSlides.pause();
        }
      }

      $(window).on('scroll', _.throttle(fixNavToTop, 15));

      window.onresize = function() {
        var mobileScreenSize = 768;
        var newWindowSize = window.innerWidth;

        if (newWindowSize < mobileScreenSize) {
          foodFaveApp.phoneSlides.pause();
        }
      };

      $('.four-tab-nav').on('activate.bs.scrollspy', function() {
        activeSection = _getActiveSection();

        if (activeSection) {
          activeSection.play();
        }

        if (previousSection && previousSection !== activeSection) {
          previousSection.pause();
        }

        previousSection = activeSection;
      });

    })();
  });

  return {};
});
