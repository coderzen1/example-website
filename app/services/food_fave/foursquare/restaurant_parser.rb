module FoodFave
  module Foursquare
    class RestaurantParser

      def initialize(foursquare_data)
        @foursquare_data = foursquare_data.with_indifferent_access
      end

      def name
        @name ||= foursquare_data['name']
      end

      def foursquare_id
        @foursquare_id ||= foursquare_data['id']
      end

      def lat
        @lat ||= foursquare_data['location']['lat']
      end

      def lng
        @lng ||= foursquare_data['location']['lng']
      end

      def address
        @address ||= foursquare_data['location']['address']
      end

      def zip_code
        @zip_code ||= foursquare_data['location']['postalCode']
      end

      def city
        @city ||= foursquare_data['location']['city']
      end

      def state
        @state ||= foursquare_data['location']['state']
      end

      def country
        @country ||= foursquare_data['location']['cc']
      end

      def phone_number
        @phone_number ||= foursquare_data['contact']['formattedPhone']
      end

      def website
        @website ||= foursquare_data['url']
      end

      def attributes
        @attributes ||= {
          name: name,
          foursquare_id: foursquare_id,
          lat: lat,
          lng: lng
        }
      end

      private

      attr_reader :foursquare_data
    end
  end
end
