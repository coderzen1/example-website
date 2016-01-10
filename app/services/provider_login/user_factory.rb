module ProviderLogin
  class UserFactory
    def initialize(login_provider_proxy)
      @login_provider_proxy = login_provider_proxy
    end

    def save
      raise_missing_attributes_error if login_provider_proxy.invalid?

      user.assign_attributes(login_provider_proxy.to_h)

      return false if user.invalid?

      user.save!
    end

    def user
      @user ||= User.where(
        uid: login_provider_proxy.uid, provider: login_provider_proxy.provider
      ).first_or_initialize
    end

    private

    def raise_missing_attributes_error
      exception = RocketPants::BadRequest.new(login_provider_proxy.errors)
      exception.context = {
        metadata: { error_description: login_provider_proxy.errors }
      }
      fail exception
    end

    attr_reader :login_provider_proxy
  end
end
