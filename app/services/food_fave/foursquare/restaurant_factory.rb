module FoodFave
  module Foursquare
    class RestaurantFactory

      def initialize(foursquare_data, restaurants_request_id: nil)
        @foursquare_data = foursquare_data
        @restaurants_request_id = restaurants_request_id
      end

      def find_or_create
        return restaurant if restaurant.persisted?

        FoursquarePicturesJob.perform_later(restaurant_id: restaurant.id)
        # TODO: Check for validity of this
        restaurant.save(validate: false)
        restaurant
      end

      private

      attr_reader :foursquare_data, :restaurants_request_id

      def restaurant
        @restaurant ||= Restaurant.find_or_initialize_by(foursquare_id: foursquare_data.foursquare_id) do |restaurant|
          restaurant.lat  = foursquare_data.lat
          restaurant.lng  = foursquare_data.lng

          restaurant.name = foursquare_data.name
          restaurant.website = foursquare_data.website
          restaurant.address_id = address.id
          restaurant.phone_number = foursquare_data.phone_number

          restaurant.restaurants_request_id = restaurants_request_id
        end
      end

      def address
        # TODO: Check for validity of this
        @address ||= Address.new.tap do |a|
          a.address = foursquare_data.address
          a.zip_code = foursquare_data.zip_code
          a.state = foursquare_data.state
          a.country = foursquare_data.country
          a.city = foursquare_data.city
          a.save(validate: false)
        end
      end
    end
  end
end
