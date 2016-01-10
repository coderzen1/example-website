'use strict';

modulejs.define('modal-loader', ['jQuery'], function($) {

  var modalLoader = {
    show: function() {
      $('#side-loader').removeClass('is-hidden');
    },

    hide: function() {
      $('#side-loader').addClass('is-hidden');
    },

    isVisible: function() {
      return !$('#side-loader').hasClass('is-hidden');
    },

    toggle: function() {
      $('#side-loader').toggleClass('is-hidden');
    }
  };

  return modalLoader;

});
