describe ProviderLogin::InstagramProxy do
  let(:instagram_proxy) do
    ProviderLogin::InstagramProxy.new("auth_token")
  end

  let(:instagram_response) do
    File.open(
      "#{Rails.root}/spec/api_responses/instagram/user_details_response.json"
    ).read
  end

  let(:parsed_instagram_response) do
    JSON.parse(instagram_response)["data"]
  end

  before do
    stub_request(
      :get,
      %r{https://api\.instagram\.com/v1/users/self\.json\?.*}
    ).to_return(status: 200, body: instagram_response)
  end

  it "should respond to name" do
    expect(instagram_proxy.name).to eq(parsed_instagram_response["username"])
  end

  it "should return instagram as a provider" do
    expect(instagram_proxy.provider).to eq("instagram")
  end

  it "should respond nil for email" do
    expect(instagram_proxy.email).to be_nil
  end

  it "should return nil for location" do
    expect(instagram_proxy.location).to be_nil
  end

  it "should respond to auth_token" do
    expect(instagram_proxy.auth_token)
      .to eq("auth_token")
  end

  it "should respond to uid" do
    expect(instagram_proxy.uid).to eq(parsed_instagram_response["id"])
  end

  it "should respond to profile_picture" do
    expect(instagram_proxy.profile_picture)
      .to eq(parsed_instagram_response["profile_picture"])
  end

  it "should return nil for auth_token_secret" do
    expect(instagram_proxy.auth_token_secret).to be_nil
  end

  context "when given an invalid auth_token" do
    it "should not be valid" do
      expect(ProviderLogin::InstagramProxy.new(nil)).to_not be_valid
    end
  end
end
