$(function() {
  'use strict';

  var $closeAlert = $('.js-close-alert');

  if ($('body').hasClass('body--darker')) {
    $closeAlert.on('click', function() {
      $(this).closest('.alert').animate({
        opacity: 0
      }, 400);
    });
  } else {
    $closeAlert.on('click', function() {
      $(this).closest('.alert').fadeOut();
    });
  }
});
