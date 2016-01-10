modulejs.define('panels', function() {

  $(function() {
    'use strict';

    $('.panel-heading').first().addClass('shown');

    $('.panel-heading').on('click', function() {
      if ($(this).hasClass('shown')) {
        $(this).removeClass('shown');
      } else {
        $('.panel-heading').removeClass('shown');
        $(this).addClass('shown');
      }
    });

  });

  return {};
});
