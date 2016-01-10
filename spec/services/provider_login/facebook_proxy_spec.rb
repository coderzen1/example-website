describe ProviderLogin::FacebookProxy do
  let(:facebook_proxy) { ProviderLogin::FacebookProxy.new(auth_token) }
  let(:auth_token) { attributes_for(:facebook_user)[:auth_token] }
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

  it "should respond to name" do
    expect(facebook_proxy.name).to eq("Stephen Ellis")
  end

  it "should return facebook as provider" do
    expect(facebook_proxy.provider).to eq("facebook")
  end

  it "should respond to email" do
    expect(facebook_proxy.email).to eq("stephen_rznbjhq_ellis@tfbnw.net")
  end

  it "should respond to location" do
    expect(facebook_proxy.location).to eq("New York, New York")
  end

  it "should respond to auth_token" do
    expect(facebook_proxy.auth_token).to eq(auth_token)
  end

  it "should respond to uid" do
    expect(facebook_proxy.uid).to eq("1384763815174614")
  end

  it "should respond to profile_picture" do
    expect(facebook_proxy.profile_picture).to_not be_nil
  end

  it "should return nil for auth_token_secret" do
    expect(facebook_proxy.auth_token_secret).to be_nil
  end

  context "when not given an auth_token" do
    it "should not be valid" do
      expect(ProviderLogin::FacebookProxy.new(nil)).to_not be_valid
    end
  end
end
