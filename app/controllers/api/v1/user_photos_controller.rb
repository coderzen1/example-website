module Api
  module V1
    class UserPhotosController < Api::V1::ApplicationController
      # GET
      #   Doc
      #     Get all photos that a user favorited
      #   Params
      #     id:               string or integer
      #     auth_token:       string
      def index
        user = User.find(params[:id])

        expose user
               .favorite_photos
               .approved
               .not_deleted
      end
    end
  end
end
