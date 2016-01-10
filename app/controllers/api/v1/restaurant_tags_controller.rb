module Api
  module V1
    class RestaurantTagsController < ApplicationController
      # GET
      #   Doc
      #     Used for getting all tags of a restaurant
      #   Params
      #     id:            string or integer
      #     auth_token:    string
      def index
        tags =
          ActsAsTaggableOn::Tag
          .joins(:taggings)
          .where(taggings: {
                   taggable: Photo.where(restaurant_id: params[:id])
                 })

        expose tags
      end
    end
  end
end
