require 'rails_helper'

describe Api::V1::FavoritePhotosController do
  default_version 1

  let(:user) { create(:user) }

  let(:photo) { create(:photo) }

  before do
    allow_any_instance_of(PhotoSerializer)
      .to receive(:scope).and_return(user)
  end

  describe "#index" do
    it "should be a collection resource even if none inside" do
      get :index, id: photo.id, auth_token: user.auth_token

      expect(response).to be_collection_resource

      expect(response).to have_exposed(photo.fans)

      expect(response.decoded_body["count"]).to eq(0)
    end

    it 'should return one fans when there is one' do
      user.favorite_photos << photo

      get :index, id: photo.id, auth_token: user.auth_token

      expect(response).to be_collection_resource

      expect(response).to have_exposed(photo.fans)

      expect(response.decoded_body["count"]).to eq(1)
    end
  end

  describe "#create" do
    it "should be able to favor a photo" do
      expect do
        post :create, auth_token: user.auth_token,
                      id: photo.id
      end.to change(Favorite, :count).from(0).to(1)

      expect(response).to have_exposed(photo.reload)
      expect(photo.reload.favorites_count).to eq(1)
    end

    it "shouldn't be able to favor a photo if already favored" do
      user.favorite_photos << photo

      post :create, { auth_token: user.auth_token,
                      id: photo.id }

      expect(response).to be_api_error(RocketPants::InvalidResource)
    end
  end

  describe "#destroy" do
    it "should be able to unfavor a photo" do
      user.favorite_photos << photo

      expect(photo.reload.favorites_count).to eq(1)

      expect do
        delete :destroy, { auth_token: user.auth_token,
                           id: photo.id }
      end.to change(Favorite, :count).from(1).to(0)

      expect(response).to have_exposed(photo)

      expect(photo.reload.favorites_count).to eq(0)
    end

    it "unfavoring photos will silently fail" do
      delete :destroy, { auth_token: user.auth_token, id: photo.id }

      expect(response).to have_exposed(photo)
    end
  end
end
