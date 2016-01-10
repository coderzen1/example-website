require 'rails_helper'
RSpec.describe RestaurantOwners::PhotoReportsController, type: :controller do
  let(:restaurant_owner) { create(:restaurant_owner, registration_status: 3) }
  let(:photo) { create(:photo) }

  before do
    sign_in restaurant_owner
  end

  describe "POST #create" do
    context "when valid" do
      it "creates a new Report" do
        expect {
          xhr :post, :create, photo_id: photo.id
        }.to change(PhotoReport, :count).by(1)
      end

      it "redirects to the index page" do
        xhr :post, :create, photo_id: photo.id
        expect(response).to be_success
      end
    end
  end
end
