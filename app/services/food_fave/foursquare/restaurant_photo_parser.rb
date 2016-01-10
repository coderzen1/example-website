module FoodFave
  module Foursquare
    class RestaurantPhotoParser

      def initialize(foursquare_data)
        @foursquare_data = foursquare_data.with_indifferent_access
      end

      def foursquare_id
        @foursquare_id ||= foursquare_data[:id]
      end

      def link
        @link ||= "#{foursquare_data[:prefix]}#{width}x#{height}#{foursquare_data[:suffix]}"
      end

      def attributes
        @attributes ||= {
          foursquare_id: foursquare_id,
          link: link
        }
      end

      private

      attr_reader :foursquare_data

      def width
        @width ||= foursquare_data[:width]
      end

      def height
        @height ||= foursquare_data[:height]
      end
    end
  end
end
