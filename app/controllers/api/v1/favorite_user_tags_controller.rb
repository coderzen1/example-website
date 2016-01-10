module Api
  module V1
    class FavoriteUserTagsController < Api::V1::ApplicationController
      version 1
      include UserTagsControllerConcern

      # GET
      #   Doc
      #     Index of all liked tags for a user
      #
      #   Params
      #     auth_token:    string
      #     id:            string
      def index
        user = find_user

        expose user.favorite_tags
      end

      private

      def find_user
        @user ||= User.find(params[:id])
      end

      def tags_finder_class
        LikedSuggestedTagsFinder
      end

      def tags_method
        :favorite_tags
      end

      def tag_list_method
        :favorite_tag_list
      end
    end
  end
end
