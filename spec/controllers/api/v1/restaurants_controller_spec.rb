require 'rails_helper'

describe Api::V1::RestaurantsController do
  default_version 1

  let(:lat) { 45.8039700 }

  let(:lng) { 15.9899826 }

  let!(:lateral) { create(:lateral) }

  let!(:umami) { create(:umami) }

  let!(:user) { create(:user) }

  before do
    allow_any_instance_of(RestaurantFiller)
      .to receive(:area_covered?).and_return(true)
  end

  before do
    allow_any_instance_of(RestaurantSerializer)
      .to receive(:scope).and_return(user)
  end

  describe "GET #index" do
    it "should be success" do
      get :index, lat: lat, lng: lng, auth_token: user.auth_token
      expect(response).to be_success
    end

    it "should return nearby places" do
      get :index, lat: lat, lng: lng, auth_token: user.auth_token

      expect(response.decoded_body["response"].collect(&:name))
        .to match_array(%w(Umami Lateral))
    end

    it 'should match the response schema' do
      get :index, lat: lat, lng: lng, auth_token: user.auth_token

      expect(response).to match_response_schema('restaurants_index')
    end

    it "should raise an error if there's no lat or long set" do
      get :index, lat: nil, lng: nil, auth_token: user.auth_token

      expect(response).to be_api_error(RocketPants::InvalidResource)
      expect(response.decoded_body["messages"]["lat"])
        .to include("can't be blank")
      expect(response.decoded_body["messages"]["lng"])
        .to include("can't be blank")
    end
  end

  describe "POST #create" do
    it "should successfully create a restaurant" do
      expect do
        post :create,
             restaurant: {
               lat: lat, lng: lng,
               name: "Test restaurant",
               address_attributes: {
                 address: "Strojarska 22",
                 zip_code: "10000",
                 country: "Croatia",
                 state: "Grad Zagreb",
                 city: "Zagreb"
               }
             },
             auth_token: user.auth_token
      end.to change(Restaurant, :count).by(1)
    end

    it "should return invalid resource error if the restaurant is invalid" do
      post :create,
           restaurant: {
             lat: lat,
             name: "Test restaurant",
             address: "Strojarska 22, 10 000 Zagreb, Croatia" },
           auth_token: user.auth_token

      expect(response).to be_api_error(RocketPants::InvalidResource)
    end
  end

  describe "GET #map_pois" do
    it "should be success" do
      get :map_pois, lat: lat, lng: lng, auth_token: user.auth_token,
                     radius: 50_000
      expect(response).to be_success
    end

    it "should return nearby places" do
      get :map_pois, lat: lat, lng: lng, auth_token: user.auth_token,
                     radius: 50_000

      expect(response.decoded_body["response"].collect(&:name).sort)
        .to eq(%w(Umami Lateral).sort)
    end

    it "should not return any restaurants if they're not nearby" do
      get :map_pois, lat: lat + 10, lng: lng + 10, auth_token: user.auth_token,
                     radius: 50_000

      expect(response.decoded_body["count"]).to eq(0)
      expect(response.decoded_body["response"]).to be_empty
    end

    it "should return the latitude and longitude of restaurants" do
      get :map_pois, lat: lat, lng: lng, auth_token: user.auth_token,
                     radius: 50_000

      expect(response.decoded_body["response"].first)
        .to include("lat")
      expect(response.decoded_body["response"].first)
        .to include("lng")
    end

    it "should raise an error if there's no lat or long set" do
      get :map_pois, lat: nil, lng: nil, auth_token: user.auth_token,
                     radius: nil

      expect(response).to be_api_error(RocketPants::InvalidResource)
      expect(response.decoded_body["messages"]["lat"])
        .to include("can't be blank")
      expect(response.decoded_body["messages"]["lng"])
        .to include("can't be blank")
      expect(response.decoded_body["messages"]["radius"])
        .to include("can't be blank")
    end
  end

  describe "GET #feed" do
    before do
      @photos = create_list(:photo, 20, restaurant_id: lateral.id)
      user.favorite_photos << @photos.last
    end

    it "should be paginated" do
      get :feed, auth_token: user.auth_token,
                 id: lateral.id, page: 1, per_page: 7

      expect(response).to be_paginated_resource
      expect(response.decoded_body["count"]).to eq(7)
    end

    it "should return all photos of food for that restaurant" do
      get :feed, auth_token: user.auth_token,
                 id: lateral.id, page: 1, per_page: 100

      expect(response.decoded_body["count"]).to eq(20)
    end

    it "should include the photo url" do
      get :feed, auth_token: user.auth_token,
                 id: lateral.id, page: 1, per_page: 1

      expect(response.decoded_body["response"].first)
        .to include("photo_url")
    end

    it "should return true if the photo was favorited" do
      get :feed, auth_token: user.auth_token,
                 id: lateral.id, page: 1, per_page: 1

      expect(response.decoded_body["response"].first)
        .to include("favorited")
      expect(response.decoded_body["response"].first["favorited"])
        .to eq(true)
    end

    it 'should include the restaurant information' do
      get :feed, auth_token: user.auth_token,
                 id: lateral.id, page: 1, per_page: 1

      expect(response.decoded_body['response'].first.keys)
        .to include("restaurant")
    end
  end

  describe "GET #show" do
    context "when requesting an existing restaurant" do
      before do
        get :show, auth_token: user.auth_token,
                   id: lateral.id
      end

      it "should return a restaurant" do
        expect(response).to have_exposed(lateral)
      end

      it "should have a photo url" do
        expect(response.decoded_body["response"]).to include(:photo)
        expect(response.decoded_body["response"]["photo"])
          .to include('http://')
      end

      it "should return if a photo was favorited or not" do
        expect(response.decoded_body["response"]).to include(:favorited)
        expect(response.decoded_body["response"]["favorited"])
          .to be_falsey
      end
    end

    context "when requesting a restaurant that doesn't exist" do
      before do
        get :show, auth_token: user.auth_token,
                   id: lateral.id + 10
      end

      it "should raise an error" do
        expect(response).to be_api_error(RocketPants::NotFound)
      end
    end
  end
end
