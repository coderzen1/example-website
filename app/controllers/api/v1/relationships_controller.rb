module Api
  module V1
    class RelationshipsController < Api::V1::ApplicationController
      version 1

      # POST
      #   Doc
      #     Used for creating relationships (following) between users
      #
      #     The id of a user that is being followed
      #   Params
      #     auth_token:    string
      #     id:            string or integer
      def create
        relationship =
          Relationship.new(follower_id: current_user.id,
                           followed_id: params[:id])

        if relationship.save
          expose current_user.reload
        else
          error! :invalid_resource, relationship.errors
        end
      end

      # DELETE
      #   Doc
      #     Used for removing a relationship between users
      #
      #   Params
      #     auth_token:    string
      #     id:            string or integer
      def destroy
        relationship =
          Relationship.find_by(follower_id: current_user.id,
                               followed_id: params[:id])

        if relationship.present?
          relationship.destroy

          expose current_user.reload
        else
          error! :not_found
        end
      end
    end
  end
end
