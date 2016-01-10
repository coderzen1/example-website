module Api
  module V1
    class UsersController < Api::V1::ApplicationController
      skip_before_action :authenticate_user_from_auth_token!,
                         only: [:oauth_login, :login, :create]

      version 1

      # GET
      #   Doc
      #     Used for getting profile information of a user
      #   Params
      #     id:          string or integer
      #     auth_token:  string
      def show
        user = load_user
        expose user, serializer: UserProfileSerializer
      end

      # POST
      #   Doc
      #     Used for logging in with Facebook/Twitter
      #     The provider string should be either "twitter" or "facebook".
      #     Permissions for facebook should be set to user_profile, location,
      #     email.
      #   Params
      #     provider:           string
      #     auth_token:         string
      #     auth_token_secret:  string (Twitter only)
      def oauth_login
        @login_handler =
          ProviderLogin.from_provider(
            params[:provider], params[:auth_token], params[:auth_token_secret]
          )

        if @login_handler.save
          expose @login_handler.user, serializer: CompactUserSerializer
        else
          error! :invalid_resource, @login_handler.user.errors,
                 metadata: {
                   error_description: "An error occured when creating a user."
                 }
        end
      end

      # POST
      #   Doc
      #     Used for logging in a user from email
      #   Params
      #     email:                  string
      #     password:               string
      def login
        user = User.find_by_email(params[:email])

        if user && user.valid_password?(params[:password])
          expose user, serializer: CompactUserSerializer
        else
          error! :invalid_resource, user.try(:errors),
                 metadata: { error_description: "Invalid login information." }
        end
      end

      # POST
      #   Doc
      #     Used for registering an account without a provider.
      #
      #     The location string should be in the form of "City, State" for US,
      #     and "City, Country" for other countries
      #   Params
      #     user:
      #       username:               string
      #       email:                  string
      #       password:               string
      #       password_confirmation:  string
      #       location:               string
      #     custom_profile_picture: file
      def create
        user = User.new(user_params_with_profile_picture)

        if user.save
          expose user
        else
          error! :invalid_resource, user.errors
        end
      end

      # GET
      #   Doc
      #     Used for getting a feed from users you're following
      #
      #   Params
      #     auth_token:  string
      #     page:        integer or string
      #     per_page:    integer or string
      def feed
        feed =
          Photo
          .where(owner_id: current_user.feed_ids)
          .order(created_at: :desc)
          .includes([:tags, :fans])
          .not_deleted
          .approved
          .paginate(page: params[:page], per_page: params[:per_page])

        expose feed, each_serializer: ActivitySerializer
      end

      # GET
      #   Doc
      #     Used for getting a list of users that are following a user
      #
      #   Params
      #     id:          string
      #     page:        integer or string
      #     per_page:    integer or string
      #     auth_token:  string
      def followers
        user = load_user

        expose user
               .followers
               .includes(:following, :favorite_restaurants)
               .paginate(page: params[:page], per_page: params[:per_page]),
               each_serializer: UserRelationshipSerializer
      end

      # GET
      #   Doc
      #     Used for getting a list of users a user is following
      #
      #   Params
      #     id:          string
      #     page:        integer or string
      #     per_page:    integer or string
      #     auth_token:  string
      def following
        user = load_user

        expose user
               .following
               .includes(:following, :favorite_restaurants)
               .paginate(page: params[:page], per_page: params[:per_page]),
               each_serializer: UserRelationshipSerializer
      end

      # PUT
      #   Doc
      #     Used for updating user information
      #
      # Params
      #   auth_token:  string
      #   user:
      #     username:              string
      #     email:                 string
      #     password:              string
      #     password_confirmation: string
      #     location:              string
      #     radius:                integer
      #     private_faved_photos:  boolean
      #   custom_profile_picture:  file
      def update
        current_user.update(user_params_with_profile_picture)

        expose current_user
      end

      # PUT
      #   Doc
      #     Used for updating the user password
      #
      # Params
      #   auth_token: string
      #   user:
      #     current_password:      string
      #     password:              string
      #     password_confirmation: string
      def update_password
        if current_user.update_with_password(update_password_params)
          expose current_user
        else
          error! :invalid_resource, current_user.errors
        end
      end

      # DELETE
      #   Doc
      #     Used for soft-deleting your profile
      #
      # Params
      #   auth_token: string
      def destroy
        current_user.deleted!

        expose current_user
      end

      private

        def load_user
          User.find(params[:id])
        end

        def user_params
          params.require(:user).permit(:username,
                                       :email,
                                       :location,
                                       :password,
                                       :password_confirmation,
                                       :radius,
                                       :private_faved_photos,
                                       :custom_profile_picture)
        end

        def update_password_params
          params.require(:user).permit(:current_password,
                                       :password,
                                       :password_confirmation)
        end

        def user_params_with_profile_picture
          return user_params.merge(
            custom_profile_picture: params[:custom_profile_picture]
          ) if params[:custom_profile_picture]
          user_params
        end
    end
  end
end
