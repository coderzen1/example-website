'use strict';

modulejs.define('map-autocompletes', ['jQuery', 'maps'], function($, map) {

  function mapAutocompletes($mapSetup) {
    this.$mapSetup = $mapSetup;
    this.$addressInput = $('.js-restaurant-address');
    this.$zipCodeInput = $('.js-restaurant-zipcode');
    this.$cityInput = $('.js-restaurant-city');
    this.$stateInput = $('.js-restaurant-state');
    this.$latitudeInput = $('.js-restaurant-lat');
    this.$longitudeInput = $('.js-restaurant-lng');
    this.$countryInput = $('.js-restaurant-country');
    this.$coordinatesInput = $('.js-restaurant-coordinates');

    this.init();
  }

  mapAutocompletes.prototype.init = function() {
    var self = this;

    var autocomplete = new map.places.Autocomplete(
      (this.$addressInput.get(0)
    ), {types: ['geocode']});

    map.event.addDomListener(this.$addressInput.get(0), 'keydown', function(e) {
      if (e.keyCode === 13) {
        e.preventDefault();
      }
    });

    map.event.addListener(autocomplete, 'place_changed', function() {
      var place = autocomplete.getPlace();
      var lat = place.geometry.location.lat();
      var lng = place.geometry.location.lng();
      self.updateInputs(place);
      self.updateCoordinates(lat, lng);

      self.$mapSetup.trigger('marker:delete');
      self.$mapSetup.trigger('marker:create', {lat: lat, lng: lng});
      self.$mapSetup.trigger('map:center', {lat: lat, lng: lng});
    });
  };

  mapAutocompletes.prototype.updateInputs = function(place) {

    /* eslint-disable camelcase */
    var componentForm = {
      locality: 'long_name',
      country: 'long_name',
      postal_code: 'short_name',
      administrative_area_level_1: 'short_name'
    };

    /* eslint-enable camelcase */
    var zipCode;
    var city;
    var state;
    var country;

    // Handles marker movement and input autocomplete
    for (var i = 0; i < place.address_components.length; i++) {
      var addressType = place.address_components[i].types[0];

      if (componentForm[addressType]) {
        var val = place.address_components[i][componentForm[addressType]];

        if (addressType === 'postal_code') {
          zipCode = val;
        } else if (addressType === 'locality') {
          city = val;
        } else if (addressType === 'country') {
          country = val;
        } else if (addressType === 'administrative_area_level_1') {
          state = val;
        }
      }
    }

    this.$zipCodeInput.val(zipCode);
    this.$cityInput.val(city);
    this.$stateInput.val(state);
    this.$countryInput.val(country);
  };

  mapAutocompletes.prototype.updateCoordinates = function(lat, lng) {
    var formattedCoordinates = 'N' + parseFloat(lat.toFixed(4)) + ', W' + parseFloat(lng.toFixed(4));

    this.$coordinatesInput.html(formattedCoordinates);
    this.$latitudeInput.val(lat);
    this.$longitudeInput.val(lng);
  };

  return mapAutocompletes;

});
