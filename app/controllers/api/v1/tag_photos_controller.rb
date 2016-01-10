module Api
  module V1
    class TagPhotosController < ApplicationController
      # GET
      #   Doc
      #     Used for getting photos of a specific tag
      #   Params
      #     id:          string or integer
      #     auth_token:  string
      #     per_page:    string
      #     page:        string
      def index
        tag_photos =
          Photo
          .joins(:tags)
          .where(taggings: { tag: ActsAsTaggableOn::Tag.find(params[:id]) })
          .paginate(per_page: params[:per_page], page: params[:page])

        expose tag_photos, each_serializer: PhotoActivitySerializer
      end
    end
  end
end
