module Api
  module V1
    class FavoritePhotosController < Api::V1::ApplicationController
      version 1

      # GET
      #   Doc
      #     Get all users that favorited a photo
      #   Params
      #     id:               string or integer
      #     auth_token:       string
      def index
        expose photo.fans
      end

      # POST
      #   Doc
      #     Favor a photo
      #   Params
      #     id:               string or integer
      #     auth_token:       string
      def create
        current_user.favorite_photos << photo
        expose photo
      end

      # DELETE
      #   Doc
      #     Unfavor a photo
      #   Params
      #     id:               string or integer
      #     auth_token:       string
      def destroy
        current_user.favorite_photos.delete(photo)
        expose photo
      end

      private

      def photo
        @photo ||= Photo.find(params[:id])
      end
    end
  end
end
