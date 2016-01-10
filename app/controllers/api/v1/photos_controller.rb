module Api
  module V1
    class PhotosController < Api::V1::ApplicationController
      version 1

      # GET
      #   Doc
      #     Used for getting a specific image through the image id
      #   Params
      #     id:               string or integer
      #     auth_token:       string
      def show
        expose Photo.approved.not_deleted.find(params[:id])
      end

      # GET
      #   Doc
      #     Used for getting all images a user has uploaded, if no id present,
      #     it returns all images of the current user (base on auth_token)
      #   Params
      #     auth_token:       string
      #     id:               string (optional)
      #     page:             string
      #     per_page:         string
      def index
        user =
          if params[:id].present?
            User.find(params[:id])
          else
            current_user
          end

        photos =
          user
          .photos
          .approved
          .not_deleted
          .order(created_at: :desc)
          .paginate(page: params[:page], per_page: params[:per_page])

        expose photos
      end

      # POST
      #   Doc
      #     Upload an image from a user
      #   Params
      #     caption:          string
      #     image:            file
      #     auth_token:       string
      #     restaurant_id:    string
      #     tag_list:         array of words
      def create
        photo = current_user.photos.create(photo_params)

        expose photo
      end

      # PUT
      #   Doc
      #     Update image information
      #   Params
      #     auth_token:       string
      #     id:               string or integer
      #     caption:          string
      #     restaurant_id:    string
      #     tag_list:         array of words
      def update
        photo = current_user.photos.find(params[:id])

        if photo.update(photo_update_params)
          expose photo
        else
          error! :invalid_resource, photo.errors
        end
      end

      # DELETE
      #   Doc
      #     Mark the image as deleted
      #   Params
      #     auth_token:       string
      #     id:               string or integer
      def destroy
        photo = current_user.photos.find(params[:id])

        photo.delete!

        expose photo
      end

      # GET
      #   Doc
      #     Endpoint for the discover photos screen, in the radius of
      #     20km from given lat/lng
      #   Params
      #     auth_token:       string
      #     lat:              integer
      #     lng:              integer
      #     page:             integer
      #     per_page:         integer
      def discover
        discover_service = DiscoverScreenService.new(discover_params)

        expose discover_service.call, each_serializer: DiscoverPhotoSerializer
      end

      private

      def photo_params
        params.permit(:caption, :image, :restaurant_id, tag_list: [])
      end

      def photo_update_params
        photo_params.except(:image)
      end

      def discover_params
        params.permit(:lat, :lng, :page, :per_page)
      end
    end
  end
end
