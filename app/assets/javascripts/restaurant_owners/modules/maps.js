'use strict';

modulejs.define('map-setup', ['jQuery', 'maps', 'map-autocompletes'], function($, map, MapAutocompletes) {

  function mapSetup(mapElement) {
    this.markersArray = [];
    this.mapElement = mapElement;
    this.$mapElement = $(mapElement);

    this.defaultLat = 40.685261;
    this.defaultLng = -73.953290;
    this.mapCenterLat = this.$mapElement.data('latitude');
    this.mapCenterLng = this.$mapElement.data('longitude');
    this.mapCenter = new map.LatLng(this.mapCenterLat || this.defaultLat, this.mapCenterLng || this.defaultLng);
    this.isForm = this.$mapElement.data('form');

    this.initMap();
    this.initNavigator();
    this.initMarkers();
    this.initAutocomplete();
  }

  mapSetup.prototype.initMap = function() {
    var self = this;

    this.map = new map.Map(self.mapElement, {
      center: self.mapCenter,
      zoom: 16,
      scrollwheel: false,
      mapTypeId: map.MapTypeId.ROADMAP,
      disableDefaultUI: true
    });
  };

  mapSetup.prototype.initMarkers = function(markerJson) {
    var data = markerJson || [{lat: this.mapCenterLat || this.defaultLat, lng: this.mapCenterLng || this.defaultLng}];

    if (data.length > 0) {
      for (var i = 0, ln = data.length; i < ln; i++) {
        this.createMarker(data[i].lat, data[i].lng);
      }
    }
  };

  mapSetup.prototype.createMarker = function(lat, lng) {
    var self = this;
    var markerLatLng = new map.LatLng(lat, lng);

    var defaults = {
      markerImage: '/icons/foodfave-marker@2x.png',
      markerSize: [71, 96],
      markerAnchor: [35, 93]
    };

    var imageObj = {
      url: defaults.markerImage,
      anchor: new map.Point(defaults.markerAnchor[0], defaults.markerAnchor[1]),
      scaledSize: new map.Size(defaults.markerSize[0], defaults.markerSize[1])
    };

    var marker = new map.Marker({
      position: markerLatLng,
      map: self.map,
      icon: imageObj,
      draggable: this.isForm
    });

    this.markersArray.push(marker);

    if (this.isForm) {
      google.maps.event.addListener(marker, 'position_changed', function() {
        lat = this.position.lat();
        lng = this.position.lng();

        self.mapAutocompletes.updateCoordinates(lat, lng);
      });
    }
  };

  mapSetup.prototype.deleteMarkers = function() {
    if (this.markersArray) {
      for (var i = 0, l = this.markersArray.length; i < l; i++) {
        this.markersArray[i].setMap(null);
      }

      this.markersArray.length = 0;
    }
  };

  mapSetup.prototype.initAutocomplete = function() {
    var self = this;

    if (this.isForm) {
      this.mapAutocompletes = new MapAutocompletes(this.$mapElement);

      this.$mapElement.on('marker:delete', function() {
        self.deleteMarkers();
      });

      this.$mapElement.on('marker:create', function(e, geo) {
        self.createMarker(geo.lat, geo.lng);
      });

      this.$mapElement.on('map:center', function(e, geo) {
        var newPosition = new map.LatLng(geo.lat, geo.lng);
        self.map.setCenter(newPosition);
      });
    }
  };

  mapSetup.prototype.initNavigator = function() {
    var self = this;

    if (!this.mapCenterLat && !this.mapCenterLng) {
      navigator.geolocation.getCurrentPosition(function(position) {
        var latitude = position.coords.latitude;
        var longitude = position.coords.longitude;

        var newCenter = new map.LatLng(latitude, longitude);

        self.map.setCenter(newCenter);
        self.markersArray[0].setPosition(newCenter);
      });
    }
  };

  return mapSetup;

});
