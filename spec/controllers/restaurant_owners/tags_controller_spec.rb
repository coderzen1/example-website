require 'rails_helper'
RSpec.describe RestaurantOwners::TagsController, type: :controller do
  let(:restaurant_owner) { create(:restaurant_owner, registration_status: 3) }
  before do
    sign_in restaurant_owner
  end

  describe "GET #index" do
    it "renders index" do
      get :index
      expect(response).to be_success
      expect(response).to render_template(:index)
    end
  end
end
