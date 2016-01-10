modulejs.define('animate_share_phone_slides', function() {

  $(function() {
    'use strict';

    foodFaveApp.findFave = (function() {
      var playInterval;

      function getRandomInt(min, max) {
        return Math.floor(Math.random() * (max - min)) + min;
      }

      function faveCombos() {
        var cssTop = {
          0: {
            desktops: 0,
            tablets: 0,
            phones: 0
          },
          1: {
            desktops: 580,
            tablets: 500,
            phones: 310
          },
          2: {
            desktops: 1100,
            tablets: 930,
            phones: 600
          },
          3: {
            desktops: 1600,
            tablets: 1360,
            phones: 0
          },
          4: {
            desktops: 2110,
            tablets: 1790,
            phones: 310
          },
          5: {
            desktops: 2620,
            tablets: 2220,
            phones: 600
          },
          6: {
            desktops: 3120,
            tablets: 2650,
            phones: 0
          },
          7: {
            desktops: 3630,
            tablets: 3080,
            phones: 310
          },
          8: {
            desktops: 4140,
            tablets: 3510,
            phones: 600
          },
          9: {
            desktops: 4650,
            tablets: 3940,
            phones: 0
          }
        };

        // link buttons to images and select at random
        var num = getRandomInt(0, 10);
        var mobileNum = getRandomInt(0, 3);
        var $phoneContent = $('.__phone-content');
        var $selectedButton;

        if (window.innerWidth > 768) {
          $selectedButton = $('.__share-fave-desktop-js .share-button-js').eq(num);
        } else {
          $selectedButton = $('.share-fave-js .mobile-only .share-button-js').eq(Mobilenum);
        }

        $('.share-button-js').removeClass('__selected');
        $selectedButton.addClass('__selected');

        if (window.innerWidth < 768) {
          $phoneContent.animate({
            scrollTop: cssTop[num].phones
          }, 1000);
        } else if ((window.innerWidth > 768) && (window.innerWidth < 992)) {
          $phoneContent.animate({
            scrollTop: cssTop[num].tablets
          }, 1000);
        } else {
          $phoneContent.animate({
            scrollTop: cssTop[num].desktops
          }, 1000);
        }
      }

      function play() {
        faveCombos();

        playInterval = setInterval(function() {
          faveCombos();
        }, 2500);
      }

      function pause() {
        clearInterval(playInterval);
      }

      return {
        getRandomInt: getRandomInt,
        play: play,
        pause: pause
      };

    })();

  });

  return {};
});
