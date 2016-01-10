require 'rails_helper'

RSpec.describe RestaurantOwners::SignupController, type: :controller do
  let(:restaurant_info_hash) do
    {}.tap do |h|
      h[:restaurant_name] = "test restoran"
      h[:owner_name] = "Owner Ime"
      h[:owner_birth] = "10. 10. 1989."
      h[:user] = restaurant_owner
    end
  end

  describe "GET #show" do
    context "on the first step of signing up" do
      let(:restaurant_owner) do
        create(
          :restaurant_owner,
          registration_status:
            RestaurantOwner.registration_statuses[:restaurant_info]
        )
      end

      before { sign_in restaurant_owner }

      it "should render the restaurant_info template" do
        get :show, id: restaurant_owner.registration_status

        expect(response).to render_template('restaurant_info')
      end
    end

    context "on the additional info step of signing up" do
      let(:restaurant_owner) do
        create(
          :restaurant_owner,
          registration_status:
            RestaurantOwner.registration_statuses[:owner_additional_info]
        )
      end

      before { sign_in restaurant_owner }

      it "should render the additional_info template" do
        get :show, id: restaurant_owner.registration_status

        expect(response).to render_template('owner_additional_info')
      end
    end

    context "on the restaurant location step" do
      let(:restaurant_owner) do
        create(
          :restaurant_owner,
          registration_status:
            RestaurantOwner.registration_statuses[:restaurant_location_info]
        )
      end

      before { sign_in restaurant_owner }

      it "should render the restaurant_location_info template" do
        get :show, id: restaurant_owner.registration_status

        expect(response).to render_template('restaurant_location_info')
      end
    end
  end

  describe "PUT #update" do
    context "when updating the restaurant_info step" do
      let(:restaurant_owner) do
        create(
          :restaurant_owner,
          registration_status:
            RestaurantOwner.registration_statuses[:restaurant_info]
        )
      end

      let(:restaurant_hash) do
        {}.tap do |h|
          h[:restaurant_name] = "Restaurant name"
          h[:owner_name] = "Test Name"
          h[:owner_birth] = "10. 10. 1989."
        end
      end

      before { sign_in restaurant_owner }

      it "should update the record" do
        put :update, id: restaurant_owner.registration_status,
                     restaurant_info: restaurant_hash
        expect do
          restaurant_owner.reload
        end.to change(
          restaurant_owner, :registration_status
        ).from('restaurant_info').to('owner_additional_info')
      end
    end

    context "when updating the owner_additional_info step" do
      let(:step) do
        RestaurantOwner.registration_statuses[:owner_additional_info]
      end
      let(:restaurant_owner) do
        create(:restaurant_owner, registration_status: step)
      end

      let(:owner_additional_hash) do
        {}.tap do |h|
          h[:phone] = '012222222'
          h[:website] = 'http://www.infinum.co'
          h[:address_attributes] = {
            address: "Školska",
            zip_code: "42201",
            city: "Varaždin",
            state: "Varaždin",
            country: "Hrvatska"
          }
        end
      end

      before { sign_in restaurant_owner }

      it "should update the record" do
        put :update, id: restaurant_owner.registration_status,
                     restaurant_info: owner_additional_hash
        expect do
          restaurant_owner.reload
        end.to change(
          restaurant_owner, :registration_status
        ).from('owner_additional_info').to('restaurant_location_info')
      end
    end

    context "when updating the restaurant_location_info step" do
      let(:step) do
        RestaurantOwner.registration_statuses[:restaurant_location_info]
      end

      let(:restaurant_owner) do
        create(:restaurant_owner, registration_status: step,
               restaurant: create(:restaurant, address: nil))
      end

      let(:location_hash) do
        {}.tap do |h|
          h[:lat] = 2.23
          h[:lng] = 1.14
          h[:address_attributes] = {
            address: "Školska",
            zip_code: "42201",
            city: "Varaždin",
            state: "Varaždin",
            country: "Hrvatska"
          }
        end
      end

      before { sign_in restaurant_owner }

      it "should update the record" do
        expect(restaurant_owner.registration_status)
          .to eq("restaurant_location_info")

        put :update, id: restaurant_owner.registration_status,
                     restaurant_location_info: location_hash

        expect(restaurant_owner.reload.registration_status)
          .to eq("finished")
      end

      it "should create a new address" do
        expect do
          put :update, id: restaurant_owner.registration_status,
                       restaurant_location_info: location_hash
        end.to change(Address, :count).by(1)

        expect(Restaurant.last.address).to_not be_nil
      end
    end
  end
end
