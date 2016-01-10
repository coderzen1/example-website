$(function() {
  'use strict';

  (window.mapTrigger = function() {
    var MapSetup = modulejs.require('map-setup');

    /* eslint-disable no-unused-vars */
    if ($('.side-content').hasClass('side-content--toggled')) {
      $('.js-map[data-modal=true]').each(function() {
        var initializedMap = new MapSetup(this);
      });

    } else {
      $('.js-map').each(function() {
        var initializedMap = new MapSetup(this);
      });

    }

    /* eslint-enable no-unused-vars */
  })();

});
