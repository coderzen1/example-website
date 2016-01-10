require 'rails_helper'
RSpec.describe RestaurantOwners::LocationController, type: :controller do
  let(:restaurant_owner) { create(:restaurant_owner, registration_status: 3) }
  let(:restaurant) { create(:restaurant) }
  let(:restaurant_hash) do
    {
      "lat": 1.234,
      "lng": 2.345,
        "address_attributes"=>
          {
            "address" => "Školska",
            "zip_code" => "42201",
            "city" => "Varaždin",
            "state" => "Varaždin",
            "country" => "Hrvatska"
          }
    }
  end

  before do
    sign_in restaurant_owner
  end

  describe "GET #edit" do
    it "returns edit page" do
      xhr :get, :edit, id: restaurant.id

      expect(response).to be_success
    end
  end

  describe "PUT #update" do
    it "change restaurant location" do
      xhr :put, :update, id: restaurant.id, restaurant: restaurant_hash

      restaurant.reload

      expect(restaurant.lat).to eql(1.234)
      expect(restaurant.lng).to eql(2.345)
    end
  end

  describe "GET #index" do
    it "return location page" do
      get :index

      expect(response).to be_success
    end
  end
end
