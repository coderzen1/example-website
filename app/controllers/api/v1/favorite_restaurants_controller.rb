module Api
  module V1
    class FavoriteRestaurantsController < Api::V1::ApplicationController
      version 1

      # POST
      #   Doc
      #     Favorite a restaurant
      #
      #   Params
      #     id:            string
      #     auth_token:    string
      def create
        restaurant = find_restaurant

        current_user.favorite_restaurants << restaurant

        expose current_user.favorite_restaurants
      end

      # GET
      #   Doc
      #     Show all favorited restaurants from a user
      #
      #   Params
      #     id:             string
      #     auth_token:     string
      #     page:           string
      #     per_page:       integer
      def index
        user = User.find(params[:id])

        favorite_restaurants =
          user
          .favorite_restaurants
          .paginate(page: params[:page], per_page: params[:per_page])

        expose favorite_restaurants
      end

      # DELETE
      #   Doc
      #     Remove a restaurant from the list of user's favorite restaurants
      #
      #   Params
      #     id:             string
      #     auth_token:     string
      def destroy
        restaurant = find_restaurant

        current_user.favorite_restaurants.destroy(restaurant)

        expose current_user.favorite_restaurants
      end

      private

      def find_restaurant
        @restaurant ||= Restaurant.find_by!(id: params[:id])
      end
    end
  end
end
