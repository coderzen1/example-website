module Api
  module V1
    class RestaurantsController < Api::V1::ApplicationController
      version 1

      # GET
      #   Doc
      #     Used for getting nearby restaurants in the list when uploading
      #     a new photo.
      #     SearchTerm is optional
      #   Params
      #     auth_token: string
      #     lat: float
      #     lng: float
      #     page: integer
      #     per_page: integer
      #     search_term: string
      def index
        nearby_places_finder = NearbyPlaces.new(nearby_places_params)

        expose nearby_places_finder.call,
               each_serializer: NearbyRestaurantSerializer
      end

      # POST
      #   Doc
      #     Used for creating a placeholder restaurant, until a owner can claim
      #     it
      #   Params
      #     auth_token:   string
      #     restaurant:
      #       lat:        float
      #       lng:        float
      #       name:       string
      #       address_attributes:
      #         address:  string
      #         zip_code: string
      #         city:     string
      #         state:    string
      #         country:  string
      def create
        restaurant = Restaurant.new(restaurant_params)

        if restaurant.save
          expose restaurant
        else
          error! :invalid_resource, restaurant.errors
        end
      end

      # GET
      #   Doc
      #     Used for getting nearby restaurants pois when looking at the map
      #   Params
      #     auth_token: string
      #     lat: float
      #     lng: float
      #     radius: integer
      def map_pois
        restaurant_positions = RestaurantPositions.new(map_params)

        expose restaurant_positions.call,
               each_serializer: RestaurantPositionSerializer
      end

      # GET
      #   Doc
      #     Used for getting the feed of any restaurant
      #   Params
      #     id:         string
      #     auth_token: string
      #     page:       string
      #     per_page:   string
      def feed
        feed_items =
          Photo
          .where(restaurant_id: params[:id])
          .includes(:owner, :tags, :fans)
          .order(created_at: :desc)
          .not_deleted
          .approved
          .paginate(page: params[:page], per_page: params[:per_page])

        expose feed_items, each_serializer: PhotoActivitySerializer
      end

      # GET
      #   DOC
      #     Used for getting information about any restaurants
      #   Params
      #     id: string
      #     auth_token: string
      def show
        restaurant = Restaurant.find(params[:id])

        expose restaurant
      end

      private

      def restaurant_params
        params.require(:restaurant).permit(:name, :lat, :lng,
                                           address_attributes: address_params)
      end

      def nearby_places_params
        params.permit(:lat, :lng, :page, :per_page, :search_term)
      end

      def map_params
        params.permit(:lat, :lng, :radius)
      end

      def address_params
        [:address, :zip_code, :city, :state, :country]
      end
    end
  end
end
