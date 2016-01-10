var foodFaveApp = foodFaveApp || {};

modulejs.define('picture_gallery', function() {

  $(function() {
    'use strict';

    foodFaveApp.locationsPhotos = (function() {

      var locations;

      function _getRandomImage() {
        return locations.photos[Math.floor(Math.random() * locations.photos.length)];
      }

      function loadImages() {
        setInterval(function() {
          var image = _getRandomImage();
          var $pictureBox = $('.picture-box');
          var $randomPictureBox = $($pictureBox[Math.floor(Math.random() * $pictureBox.length)]);
          var $randomPictureWrapper = $('.__pic-wrapper', $randomPictureBox);

          var img = new Image();
          $(img).on('load', function() {
            $randomPictureWrapper.find('div.__pic-title > p').fadeIn(1200, function() {
              $(this).text(image.restaurant_name);
            });
            $randomPictureWrapper.find('div.__pic > img').fadeOut(1200, function() {
              $randomPictureWrapper.find('div.__pic > img').attr('src', image.image_url);
              $randomPictureWrapper.find('div.__pic > img').show();

            });
          });
          $randomPictureBox.css('background-image', 'url(' + image.image_url + ')');
          img.src = image.image_url;
        }, 1500);
      }

      // here is the ajax call for the instagram photos
      return $.get('/photos/index', function(data) {
        locations = data;
      }).then(loadImages);

    })();
  });

  return {};
});
