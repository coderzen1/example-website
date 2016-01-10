module ProviderLogin
  class << self
    def from_provider(provider, auth_token, auth_token_secret)
      provider_proxy =
        find_provider_proxy(provider, auth_token, auth_token_secret)

      ProviderLogin::UserFactory.new(provider_proxy)
    end

    def find_provider_proxy(provider, auth_token, auth_token_secret)
      case provider
      when "facebook"
        ProviderLogin::FacebookProxy.new(auth_token)
      when "twitter"
        ProviderLogin::TwitterProxy.new(auth_token, auth_token_secret)
      when "instagram"
        ProviderLogin::InstagramProxy.new(auth_token)
      else
        raise_invalid_provider_given
      end
    end

    def raise_invalid_provider_given
      exception = RocketPants::BadRequest.new
      exception.context = {
        metadata: { error_description: { provider: "can't be blank" } }
      }
      fail exception
    end
  end
end
