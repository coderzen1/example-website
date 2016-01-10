'use strict';

modulejs.define('overlay', ['jQuery'], function($) {

  var overlay = {
    show: function() {
      $('body').addClass('body-overlay');
      $('html, body').addClass('is-not-scrollable');
    },

    hide: function() {
      $('body').removeClass('body-overlay');
      $('html, body').removeClass('is-not-scrollable');
    },

    isVisible: function() {
      return $('body').hasClass('body-overlay');
    },

    toggle: function() {
      $('body').toggleClass('body-overlay');
      $('html, body').toggleClass('is-not-scrollable');
    }
  };

  return overlay;
});
