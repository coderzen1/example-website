describe ProviderLogin::TwitterProxy do
  let(:twitter_proxy) do
    ProviderLogin::TwitterProxy.new(twitter_auth_token,
                                    twitter_auth_token_secret)
  end

  let(:twitter_user) { build(:twitter_user) }
  let(:twitter_auth_token) { twitter_user.auth_token }
  let(:twitter_auth_token_secret) { twitter_user.auth_token_secret }
  let(:user_instance) { build(:twitter_user_instance) }
  let(:user) { login_handler.user }

  before do
    stub_request(
      :get, "https://api.twitter.com/1.1/account/verify_credentials.json"
    ).to_return(status: 200, body: user_instance.to_json)
  end

  it "should respond to name" do
    expect(twitter_proxy.name).to eq(user_instance.screen_name)
  end

  it "should return twitter as a provider" do
    expect(twitter_proxy.provider).to eq("twitter")
  end

  it "should return nil for email" do
    expect(twitter_proxy.email).to be_nil
  end

  it "should respond to location" do
    expect(twitter_proxy.location).to eq(user_instance.location)
  end

  it "should respond to auth_token" do
    expect(twitter_proxy.auth_token).to eq(twitter_user.auth_token)
  end

  it "should respond to uid" do
    expect(twitter_proxy.uid).to eq(user_instance.id)
  end

  it "should respond to profile_picture" do
    expect(twitter_proxy.profile_picture)
      .to eq(user_instance.profile_image_uri.to_s)
  end

  it "should respond to auth_token_secret" do
    expect(twitter_proxy.auth_token_secret)
      .to eq(twitter_user.auth_token_secret)
  end

  context "when given an invalid auth_token" do
    it "should not be valid" do
      expect(ProviderLogin::TwitterProxy.new(nil, twitter_auth_token_secret))
        .to_not be_valid
    end
  end

  context "when given an invalid auth_token_secret" do
    it "should not be valid" do
      expect(ProviderLogin::TwitterProxy.new(twitter_auth_token, nil))
        .to_not be_valid
    end
  end
end
