module FoodFave
  module Foursquare
    class RestaurantEndpoint

      FOOD_CATEGORY_ID = '4d4b7105d754a06374d81259'

      def self.nearby_search(lat:, lng:, radius:)
        new(lat: lat, lng: lng, radius: radius).nearby_search.map do |venue_data|
          RestaurantParser.new(venue_data)
        end
      end

      def self.restaurant_photos(restaurant_id:)
        Foursquare.client.venue_photos(restaurant_id)['items'].map do |photo_data|
          RestaurantPhotoParser.new(photo_data)
        end
      end

      def initialize(lat:, lng:, radius:)
        @lat = lat
        @lng = lng
        @radius = radius
      end

      def nearby_search
        Foursquare.client.search_venues(
          ll: ll,
          radius: radius,
          limit: 50,
          categoryId: FOOD_CATEGORY_ID
        )['venues']
      end

      private

      attr_reader :lat, :lng, :radius

      def ll
        "#{lat}, #{lng}"
      end
    end
  end
end
