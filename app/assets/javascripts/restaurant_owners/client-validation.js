$(function() {
  'use strict';

  jQuery.validator.addMethod('phone', function(value, element) {
    return this.optional(element) || (/^[0-9-+()#\s/]+$/).test(value);
  }, 'Please specify a valid phone number');

  $('#new_restaurant_owner').validate({
    rules: {
      'restaurant_owner[password]': {
        required: true,
        minlength: 8
      },
      'restaurant_owner[password_confirmation]': {
        required: true,
        equalTo: '#restaurant_owner_password',
        minlength: 8
      }
    }
  });

  $('#new_restaurant_info').validate({
    errorPlacement: function(error, element) {
      if (element.hasClass('input--datepicker')) {
        error.insertAfter('.dropdown-icon');
      } else {
        error.insertAfter(element);
      }
    }
  });

  $('#edit_owner_additional_info').validate({
    rules: {
      'owner_additional_info[address_attributes][address]': {
        required: true
      },
      'owner_additional_info[address_attributes][zip_code]': {
        required: true,
        maxlength: 20
      },
      'owner_additional_info[address_attributes][city]': {
        required: true
      },
      'owner_additional_info[address_attributes][state]': {
        required: true
      },
      'owner_additional_info[address_attributes][country]': {
        required: true
      },
      'owner_additional_info[phone]': {
        required: true,
        maxlength: 20,
        phone: true
      },
      'owner_additional_info[website]': {
        required: true,
        url: true
      }
    }
  });

  $('#new_restaurant_location_info').validate({
    rules: {
      'restaurant_location_info[address_attributes][address]': {
        required: true
      },
      'restaurant_location_info[address_attributes][zip_code]': {
        required: true,
        maxlength: 20
      },
      'restaurant_location_info[address_attributes][city]': {
        required: true
      },
      'restaurant_location_info[address_attributes][state]': {
        required: true
      },
      'restaurant_location_info[address_attributes][country]': {
        required: true
      }
    }
  });

});
