module Api
  module V1
    class TagsController < Api::V1::ApplicationController
      version 1

      # GET
      #   Doc
      #     Serching tags
      #
      #   Params
      #     auth_token:    string
      #     search:        string
      def index
        @tags = TagSearch.perform(params[:search])
        expose @tags
      end
    end
  end
end
