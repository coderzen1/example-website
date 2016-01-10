$(function() {
  'use strict';

  var defaultAdultDate = new Date(moment().subtract(21, 'years').calendar());

  /* eslint-disable no-unused-vars */
  var picker = new Pikaday({
    field: document.getElementById('datepicker'),
    format: 'MMM DD, YYYY',
    defaultDate: defaultAdultDate
  });

  /* eslint-enable no-unused-vars */

  // Handle title inputs
  window.titleInputsHandler = function($titleInput, $titleEditIcon) {

    $titleInput.each(function() {
      $(this).attr('size', $(this).attr('placeholder').length);
    });

    $titleEditIcon.on('click', function() {
      $(this).siblings('.input-wrapper').find($titleInput).focus();
    });

    $titleInput.on('focus', function() {
      var $inputWrapper = $(this).closest('.input-wrapper');
      $inputWrapper.siblings($titleEditIcon).hide();
      $inputWrapper.addClass('input-wrapper--block');
    });

    $titleInput.on('blur', function() {
      var $this = $(this);
      var $inputWrapper = $this.closest('.input-wrapper');
      $inputWrapper.siblings($titleEditIcon).show();
      $inputWrapper.removeClass('input-wrapper--block');
      $this.attr('size', $this.val().length);
    });
  };

});
