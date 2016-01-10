require 'rails_helper'
RSpec.describe SuperUsers::ActivationsController, type: :controller do
  let(:super_user) { SuperUser.create(email: "fkuster@foi.hr", password: "12345678") }
  let!(:restaurant) { create(:restaurant, ownership_document: "test_image.jpg") }
  let!(:restaurant_owner) { create(:restaurant_owner, restaurant: restaurant) }

  before do
    sign_in super_user
  end

  describe "POST #delete_owner" do
    it "delete restaurant owner" do
      expect { xhr :post, :delete_owner, id: restaurant_owner }
        .to change(RestaurantOwner, :count).by(-1)
    end
  end

  describe "POST #reject" do
    it "delete owner ownership_document" do
      xhr :post, :reject, id: restaurant_owner

      expect { restaurant_owner.restaurant.reload }
        .to change(restaurant_owner.restaurant, :ownership_document)
        .from("test_image.jpg").to(nil)
    end
  end

  describe "POST #approve" do
    it "change owner verification status to verified" do
      xhr :post, :approve, id: restaurant_owner

      expect { restaurant_owner.reload }
        .to change(restaurant_owner, :ownership_verification_status)
        .from("not_verified").to("verified")
    end
  end
end
