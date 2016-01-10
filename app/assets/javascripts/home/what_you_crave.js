modulejs.define('animate_crave_phone_slides', function() {

  $(function() {
    'use strict';

    foodFaveApp.phoneSlides = (function() {
      var playInterval;
      var playBackgrounds;
      var playSlider;

      function isPaused() {
        return !playInterval;
      }

      function _slideBgTransition(bg, btn) {
        var $phoneContentBgWrapper = $('.__phone-content-slide-bg');
        var $baseBg = $phoneContentBgWrapper.find('.__base-bg');
        var $transitionBg = $phoneContentBgWrapper.find(bg);
        var $buttonBg = $(btn);
        var active = '__active-bg';
        var deactivate = '__deactivated-bg';
        var btnBg;
        var $touchWrapper;
        var touchGesture;

        if (btn === '.__yes-button') {
          btnBg = 'green-button';
          touchGesture = 'touch-circle--right';
          $touchWrapper = $('.__content-right .touch-circle');
        } else {
          btnBg = 'red-button';
          touchGesture = 'touch-circle--left';
          $touchWrapper = $('.__content-left .touch-circle');
        }
        $('.touch-circle').removeClass('touch-circle--left touch-circle--right');
        $touchWrapper.addClass(touchGesture);

        playBackgrounds = setTimeout(function() {
          $buttonBg.addClass(btnBg);
          $baseBg.removeClass(active).addClass(deactivate);
          $transitionBg.addClass(active);
          $transitionBg.on('transitionend webkitTransitionEnd oTransitionEnd', function() {
            if (!isPaused()) {
              $transitionBg.removeClass(active);
              $baseBg.removeClass(deactivate).addClass(active);
              $buttonBg.removeClass(btnBg);
            }
          });
        }, 200);
      }

      function _addSlideBg(yesOption) {
        if (!isPaused()) {
          if (yesOption) {
            _slideBgTransition('.__green-bg', '.__yes-button');
          } else {
            _slideBgTransition('.__red-bg', '.__no-button');
          }
        }
      }

      function _nextSlide(yesOption) {
        var $activeSlide = $('.__phone-content-slide.__active-slide');
        var slideClass = yesOption ? '__phone-slide-right' : '__phone-slide-left';
        var $firstSlide = $('.__phone-content-slide').first();
        var active = '__active-slide';

        playSlider = setTimeout(function() {
          $activeSlide.addClass(slideClass);
        }, 200);

        window.setTimeout(function() {
          $activeSlide.removeClass(slideClass);

          if ($activeSlide.next().length > 0) {
            $activeSlide.removeClass(active).next().addClass(active).fadeIn('slow');
          } else {
            $activeSlide.removeClass(active);
            _setSlideClass();
          }
        }, 1150);
      }

      function _setSlideClass() {
        if (!$('.__phone-content-slide.__active-slide').length) {
          $('.__phone-content-slide').first().addClass('__active-slide');
        }
      }

      function _resetBackgrounds() {
        $('.__phone-content-slide-bg .__bg').removeClass('__active-bg __deactivated-bg');
        $('.__phone-content-slide-bg .__base-bg').addClass('__active-bg');

        $('.__phone-content-slide').removeClass('__active-slide __phone-slide-right __phone-slide-left');
        $('.__phone-content-slide').first().addClass('__active-slide');
        $('.__yes-button').removeClass('green-button');
        $('.__no-button').removeClass('red-button');
        $('.touch-circle').removeClass('touch-circle--left touch-circle--right');
      }

      function play() {
        if (isPaused()) {
          playInterval = true;
          var yesOption = true;
          _addSlideBg(yesOption);
          _nextSlide(yesOption);
          yesOption = !yesOption;

          playInterval = setInterval(function() {
            _addSlideBg(yesOption);
            _nextSlide(yesOption);
            yesOption = !yesOption;
          }, 2000);
        }
      }

      function pause() {
        if (!isPaused()) {
          clearInterval(playInterval);
          clearTimeout(playBackgrounds);
          clearTimeout(playSlider);
          playInterval = false;
          _resetBackgrounds();
        }
      }

      return {
        play: play,
        pause: pause
      };

    })();

  });

  return {};
});
