require 'rails_helper'
RSpec.describe RestaurantOwners::PhotosController, type: :controller do
  let(:restaurant_owner) { create(:restaurant_owner, registration_status: 3) }
  let(:photo) { attributes_for(:photo) }

  let(:valid_attributes) do
    { caption: 'Test picture', image: 'image.jpg', restaurant: 1 }
  end

  let(:invalid_attributes) do
    { caption: '', image: '' }
  end

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

  describe "GET #new" do
    it "renders new" do
      get :new

      expect(response).to be_success
      expect(response).to render_template(:new)
    end
  end

  describe "POST #create" do
    context "when valid" do
      it "creates a new Photo" do
        expect { post :create, photo: photo }.to change(Photo, :count).by(1)
      end

      it "redirects to the index page" do
        post :create, photo: photo

        expect(response).to redirect_to(restaurants_photos_path)
      end
    end

    context "with invalid" do
      it "re-renders new" do
        post :create, photo: invalid_attributes

        expect(response).to render_template(:new)
      end
    end
  end
end
