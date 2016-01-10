require 'rails_helper'

describe Api::V1::FavoriteRestaurantsController do
  default_version 1

  let!(:user) do
    create(:user_with_favorited_photos_and_restaurants,
           number_of_restaurants: 15)
  end

  let(:restaurant) { create(:restaurant) }

  before do
    allow_any_instance_of(RestaurantSerializer)
      .to receive(:scope).and_return(user)
  end

  describe "#index" do
    before do
      get :index, auth_token: user.auth_token, id: user.id,
                  per_page: 8, page: 1
    end

    it "should return a paginated colletion" do
      expect(response).to be_paginated_resource
    end

    it "should return the requested number of items" do
      expect(response.decoded_body["count"]).to eq(8)
    end
  end

  describe "#create" do
    context "when adding a valid restaurant" do
      it "should add a restaurants to favorites correctly" do
        expect do
          post :create, auth_token: user.auth_token,
                        id: restaurant.id
        end.to change(user.favorite_restaurants, :count).by(1)
      end

      it "should return all favorited restaurants" do
        post :create, auth_token: user.auth_token,
                      id: restaurant.id

        expect(response)
          .to have_exposed(user.favorite_restaurants)
      end
    end

    context "when adding a restaurant that doesn't exist" do
      it "should raise a not found error" do
        post :create, auth_token: user.auth_token,
                      id: Restaurant.last.id + 10

        expect(response).to be_api_error(RocketPants::NotFound)
      end
    end
  end

  describe "#destroy" do
    context "when destroying a restaurant" do
      it "should remove a restaurant from user's favorite restaurants" do
        expect do
          delete :destroy, auth_token: user.auth_token,
                           id: user.favorite_restaurants.sample.id
        end.to change(user.favorite_restaurants, :count).by(-1)
      end

      it "should not remove a restaurant from the database" do
        expect do
          delete :destroy, auth_token: user.auth_token,
                           id: user.favorite_restaurants.sample.id
        end.not_to change(Restaurant, :count)
      end

      it "should return a list of all favorited restaurants" do
        delete :destroy, auth_token: user.auth_token,
                         id: user.favorite_restaurants.sample.id

        expect(response)
          .to have_exposed(user.reload.favorite_restaurants)
      end
    end

    context "when trying to remove a restaurant that wasn't favorited" do
      it "should return the list of favorited restaurants" do
        delete :destroy, auth_token: user.auth_token,
                         id: restaurant.id

        expect(response)
          .to have_exposed(user.favorite_restaurants)
      end

      it "should not change the total number of restaurants" do
        expect do
          delete :destroy, auth_token: user.auth_token,
                           id: user.favorite_restaurants.sample.id
        end.not_to change(Restaurant, :count)
      end

      it "should not change the number of favorited restaurants" do
        expect do
          delete :destroy, auth_token: user.auth_token,
                           id: user.favorite_restaurants.sample.id
        end.to change(user.favorite_restaurants, :count).by(-1)
      end
    end

    context "when trying to remove a restaurant that doesn't exist" do
      it "should raise a not found error" do
        post :create, auth_token: user.auth_token,
                      id: Restaurant.last.id + 10

        expect(response).to be_api_error(RocketPants::NotFound)
      end
    end
  end
end
