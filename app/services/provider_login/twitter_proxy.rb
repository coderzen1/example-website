module ProviderLogin
  class TwitterProxy < BaseProxy
    validates :auth_token_secret, presence: true

    attr_reader :provider, :auth_token, :auth_token_secret

    def initialize(auth_token, auth_token_secret, provider = 'twitter')
      @auth_token = auth_token
      @auth_token_secret = auth_token_secret
      @provider = provider
    end

    def profile_picture
      twitter_user.profile_image_uri.to_s
    end

    def email
      nil
    end

    def name
      twitter_user.screen_name
    end

    def location
      twitter_user.location if twitter_user.location?
    end

    def uid
      @twitter_uid ||= twitter_user.id
    end

    private

      def twitter_user
        @twitter_user ||= twitter_instance.user
      end

      def twitter_instance
        @twitter_instance ||= ::Twitter::REST::Client.new do |config|
          config.consumer_key = Rails.application.secrets.twitter_consumer_key
          config.consumer_secret =
            Rails.application.secrets.twitter_consumer_key_secret
          config.access_token = auth_token
          config.access_token_secret = auth_token_secret
        end
      end
  end
end
