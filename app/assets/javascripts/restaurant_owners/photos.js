$(function() {
  'use strict';

  $('.js-photo-modal').on('click', function() {

    $('.photo-modal').modal('setting', {
      onShow: function() {
        $(this).css({
          margin : '0',
          position : 'fixed',
          top : '0',
          bottom : '0',
          left : '0',
          right : '0',
          width : 'auto'
        });

        if ($(this).hasClass('scrolling')) {
          $(this).removeClass('scrolling');
        }

      }
    }).modal('show');
  });

});
