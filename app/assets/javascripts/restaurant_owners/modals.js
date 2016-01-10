$(function() {
  'use strict';

  var overlay = modulejs.require('overlay');
  window.loader = modulejs.require('modal-loader');

  window.sideContentToggler = function() {
    $('.side-content').toggleClass('side-content--toggled');
    overlay.toggle();
  };

  $('body').on('click', '.js-close-side-content', function(e) {
    e.preventDefault();
    sideContentToggler();
  });

  $('.js-main-wrapper').on('click', '.js-toggle-modal', function() {
    sideContentToggler();

    if (!loader.isVisible()) {
      loader.show();
    }
  });

  $('.side-modal').on('click', '.js-submit-modal-form', function() {
    if (!loader.isVisible()) {
      loader.show();
    }
  });

});
