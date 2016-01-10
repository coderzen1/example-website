module ProviderLogin
  class InstagramProxy < BaseProxy
    attr_reader :auth_token, :provider

    def initialize(auth_token, provider = 'instagram')
      @auth_token = auth_token
      @provider = provider
    end

    def name
      instagram_user["username"]
    end

    def email
      nil
    end

    def location
      nil
    end

    def uid
      instagram_user["id"]
    end

    def profile_picture
      instagram_user["profile_picture"]
    end

    def auth_token_secret
      nil
    end

    private

    def instagram_user
      @instagram_user ||= instagram_client_instance.user
    end

    def instagram_client_instance
      @instagram_client_instance ||= Instagram.client(access_token: auth_token)
    end
  end
end
