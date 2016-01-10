require 'rails_helper'
RSpec.describe RestaurantOwners::TagPhotosController, type: :controller do
  let(:restaurant_owner) { create(:restaurant_owner, registration_status: 3) }

  before do
    sign_in restaurant_owner
  end
  describe "GET #index" do
      it "send photos by tag" do
        xhr :get, :index, id: 'Test'
        expect(response).to be_success
      end
  end
end
