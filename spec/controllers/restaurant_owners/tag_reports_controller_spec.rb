require 'rails_helper'
RSpec.describe RestaurantOwners::TagReportsController, type: :controller do
  let(:restaurant_owner) { create(:restaurant_owner, registration_status: 3) }
  let(:tag) { create(:tag) }

  before do
    sign_in restaurant_owner
  end

  describe "POST #create" do
    context "when valid" do
      it "creates a new tag_report" do
        expect { xhr :post, :create, tag_id: tag.id}.to change(TagReport, :count).by(1)
      end
    end
  end
end
