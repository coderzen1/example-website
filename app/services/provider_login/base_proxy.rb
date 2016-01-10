module ProviderLogin
  class BaseProxy
    include ActiveModel::Model

    validates :auth_token, presence: true
    attr_reader :auth_token, :auth_token_secret, :provider

    def to_h
      {
        username: name,
        uid: uid,
        email: email,
        provider: provider,
        auth_token: auth_token,
        auth_token_secret: auth_token_secret,
        location: location,
        provider_profile_picture: profile_picture
      }
    end
  end
end
