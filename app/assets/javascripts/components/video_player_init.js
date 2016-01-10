modulejs.define('video_player_init', function() {

  $(function() {
    'use strict';

    foodFaveApp.videoPlayer = (function() {

      return function() {
        var $videoContainer = $('.video');

        $videoContainer.on('click', function() {
          // var $videoContainer = $(this).parent();
          var $this = $(this);
          var video = $this.find('video')[0];

          if ($this.hasClass('playing')) {
            video.pause();
            $this.removeClass('playing');
            if (video.ended) {
              video.load();
            }
          } else {
            video.play();
            $this.addClass('playing');
          }
        });
      };

    })();

    foodFaveApp.videoPlayer();
  });

  return {};
});
