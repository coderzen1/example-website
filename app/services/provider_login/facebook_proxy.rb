module ProviderLogin
  class FacebookProxy < BaseProxy
    attr_reader :provider, :auth_token

    def initialize(auth_token, provider = 'facebook')
      @auth_token = auth_token
      @provider = provider
    end

    def name
      profile_info['name']
    end

    def email
      profile_info['email']
    end

    def auth_token_secret
      nil
    end

    def location
      profile_info['location']['name'] if profile_info['location']
    end

    def uid
      profile_info['id']
    end

    def profile_picture
      @profile_picture ||= koala_instance.get_picture(
        'me', type: 'square', height: 300, width: 300
      )
    end

    private

      def profile_info
        @profile_info ||= koala_instance.get_object('me')
      end

      def koala_instance
        Koala::Facebook::API.new(@auth_token)
      end
  end
end
