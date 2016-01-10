module Api
  module V1
    class ApplicationController < RocketPants::Base
      include Devise::Controllers::Helpers
      include ActionController::Serialization

      before_action :authenticate_user_from_auth_token!

      use_named_exception_notifier :bugsnag

      serialization_scope :current_user

      private

      def authenticate_user_from_auth_token!
        auth_token    = params[:auth_token].presence
        user = auth_token && User.find_by_auth_token(auth_token)
        fail RocketPants::Unauthenticated unless user
        sign_in(user, store: false)
      end

      def default_serializer_options
        {
          url_options: url_options,
          root: false,
          scope: serialization_scope
        }
      end
    end
  end
end
