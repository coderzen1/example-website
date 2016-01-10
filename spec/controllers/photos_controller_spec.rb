require 'rails_helper'

describe PhotosController do
  let(:user) { create(:user) }
  let(:instagram_response) do
    JSON.parse(File.read(File.join(Rails.root, 'spec', 'api_responses', 'instagram', 'recent_media_response.json'))).map { |t| Hashie::Mash.new(t) }
  end

  describe "#index" do
    before do
      stub_request(:get, "https://api.instagram.com/v1/users/1478237841/media/recent.json?count=50").
        to_return(body: instagram_response, status: 200)

      get :index
    end

    it "should only return instagram photos with a location" do
      expect(response.decoded_body[:photos].all? { |t| t[:restaurant_name].present? })
        .to eq(true)
    end

    it "should return both the location and the image url" do
      expect(response.decoded_body[:photos].first).to include(:restaurant_name)
      expect(response.decoded_body[:photos].first).to include(:image_url)
    end
  end

  describe "#discover" do
    before do
      create_list(:photo, 10, owner: user)
    end

    it "should expose a paginated resource" do
      get :discover, auth_token: user.auth_token,
                     lat: Photo.first.restaurant.lat, lng: Photo.first.restaurant.lng

      expect(response).to be_success
      expect(response.decoded_body.count).to eq(10)
    end
  end
end
