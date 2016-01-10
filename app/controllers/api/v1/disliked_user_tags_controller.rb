module Api
  module V1
    class DislikedUserTagsController < Api::V1::ApplicationController
      version 1
      include UserTagsControllerConcern

      # GET
      #   Doc
      #     Get a list of all user disliked tags
      #
      #   Params
      #     auth_token: string
      def index
        expose current_user.disliked_tags
      end

      private

      def tags_finder_class
        DislikedSuggestedTagsFinder
      end

      def tags_method
        :disliked_tags
      end

      def tag_list_method
        :disliked_tag_list
      end
    end
  end
end
