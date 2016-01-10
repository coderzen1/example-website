require 'rails_helper'
RSpec.describe RestaurantOwners::RestaurantController, type: :controller do
  let(:restaurant_owner) { create(:restaurant_owner, registration_status: 3) }
  let(:restaurant) { attributes_for(:restaurant) }

  before do
    sign_in restaurant_owner
  end

  describe "GET #edit" do
    it "renders edit" do
      get :edit, id: restaurant_owner.restaurant.id
      expect(response).to be_success
      expect(response).to render_template(:edit)
    end
  end

  describe "PUT #update" do
    context "when valid" do
      it "updates a restaurant" do
        put :update, id: restaurant_owner.restaurant.id, restaurant: restaurant
        expect(response).to redirect_to(restaurants_settings_path)
      end
    end
  end
end
