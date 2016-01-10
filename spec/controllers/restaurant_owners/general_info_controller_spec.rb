require 'rails_helper'
RSpec.describe RestaurantOwners::GeneralInfoController, type: :controller do
  let(:restaurant_owner) { create(:restaurant_owner, registration_status: 3) }
  let(:info) { GeneralInfoForm.new(restaurant_name:"Restoran1",
                                   owner_name: "Filip",
                                   owner_birthday: "23.12.1991")}

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
      it "updates a general info" do
        put :update, id: restaurant_owner.restaurant.id, general_info_form: info.as_json
        expect(response).to redirect_to(restaurants_settings_path)
      end
    end

    context "with invalid" do
      it "re-renders edit" do
        info.restaurant_name = nil
        put :update, id: restaurant_owner.restaurant.id, general_info_form: info.as_json
        expect(response).to render_template(:edit)
      end
    end
  end
end
