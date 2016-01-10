require 'rails_helper'

describe ProviderLogin::UserFactory do
  let(:facebook_proxy) { ProviderLogin::FacebookProxy.new(auth_token) }
  let(:facebook_user) { build(:facebook_user) }
  let(:auth_token) { facebook_user.auth_token }
  let(:facebook_response) do
    File.open(
      "#{Rails.root}/spec/api_responses/facebook/auth_response.json"
    ).read
  end
  let(:profile_picture) do
    File.open(
      "#{Rails.root}/spec/api_responses/facebook/profile_picture_response.txt"
    ).read
  end

  before do
    stub_request(
      :get, %r{https://graph\.facebook\.com/me\?access_token=.*}
    ).to_return(status: 200, body: facebook_response)

    stub_request(
      :get, %r{https://graph\.facebook\.com/me/picture}
    ).to_return(status: 200,
                headers: {
                  location: profile_picture
                })
  end

  context "with a user that doesn't exist" do
    let(:user_factory) { ProviderLogin::UserFactory.new(facebook_proxy) }

    it "should create a new user" do
      expect do
        user_factory.save
      end.to change(User, :count).by(1)
    end
  end

  context "with a user that already exists" do
    before { facebook_user.save }
    let(:user_factory) { ProviderLogin::UserFactory.new(facebook_proxy) }

    it "should not create a new user" do
      expect do
        user_factory.save
      end.not_to change(User, :count)
    end

    it "should update the user information" do
      user_factory.save

      expect do
        facebook_user.reload
      end
        .to change(facebook_user, :username)
        .from(facebook_user.username)
        .to(facebook_proxy.name)
    end
  end

  context "when given an invalid proxy" do
    let(:invalid_proxy) { ProviderLogin::FacebookProxy.new(nil) }
    let(:user_factory) { ProviderLogin::UserFactory.new(invalid_proxy) }

    it "should raise an error" do
      expect { user_factory.save }.to raise_error
    end
  end

  context "when having an invalid user" do
    let(:invalid_proxy) do
      ProviderLogin::FacebookProxy.new('auth_token', nil)
    end
    let(:user_factory) { ProviderLogin::UserFactory.new(invalid_proxy) }

    it "should return false when calling save" do
      expect(user_factory.save).to eq(false)
    end
  end
end
