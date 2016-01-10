modulejs.define('explore_places_icon_animation', function() {

  $(function() {
    'use strict';

    foodFaveApp.explorePlaces = (function() {

      var playInterval;
      var restaurantNum = 1;

      function _displayLocation() {

        var restaurant = {
          1: {
            pic: "#restaurant-1-pic",
            icon: '.__location-icon--lft-top-left',
            mobileIcon: '.__location-icon--btm-left',
            slider: 'fall--lft-top-left'
          },
          2: {
            pic: "#restaurant-2-pic",
            icon: '.__location-icon--lft-middle-right',
            mobileIcon: '.__location-icon--btm-right',
            slider: 'fall--lft-middle-right'
          },
          3: {
            pic: "#restaurant-3-pic",
            icon: '.__location-icon--lft-bottom-left',
            slider: 'fall--lft-bottom-left'
          },
          4: {
            pic: "#restaurant-4-pic",
            icon: '.__location-icon--rt-middle-right',
            slider: 'fall--rt-middle-right'
          },
          5: {
            pic: "#restaurant-5-pic",
            icon: '.__location-icon--rt-bottom-left',
            slider: 'fall--rt-bottom-left'
          }
        };

        var $pic;
        var $icon;
        var slider;

        $('.__location-icon').removeClass(
          'fall--lft-top-left fall--lft-middle-right fall--lft-bottom-left fall--rt-middle-right fall--rt-bottom-left');
        $('.__explore-places-slides img.__active').removeClass('__active');

        if (window.innerWidth > 768) {
          $pic = $(restaurant[restaurantNum].pic);
          $icon = $(restaurant[restaurantNum].icon);
          slider = restaurant[restaurantNum].slider;
        } else {
          $pic = $('#restaurant-1-pic');
        }

        $pic.addClass('__active');
        $icon.addClass(slider);

        if (restaurantNum >= 5) {
          return restaurantNum = 1;
        } else {
          return restaurantNum += 1;
        }
      }

      function play() {
        _displayLocation();

        playInterval = setInterval(function() {
          _displayLocation();
        }, 2500);
      }

      function pause() {
        clearInterval(playInterval);
      }

      return {
        play: play,
        pause: pause
      };

    })();
  });

  return {};
});
