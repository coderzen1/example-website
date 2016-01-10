$(function() {
  'use strict';

  $('.js-navbar-toggle').on('click', function() {
    $(this).toggleClass('open');
    $('.js-collapsible-navbar').slideToggle().toggleClass('toggled');
  });
});
