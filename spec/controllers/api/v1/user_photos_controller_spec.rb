require 'rails_helper'

describe Api::V1::UserPhotosController do
  default_version 1

  let(:user) { create(:user) }
  let(:photos) { create_list(:photo, 10, owner: create(:user)) }

  describe 'GET #index' do
    before do
      user.favorite_photos << photos
    end

    it 'should use the photo serializer' do
      get :index, auth_token: user.auth_token, id: user.id

      expect(response).to match_response_schema('photos_collection')
    end

    it 'should return all the favorited photos' do
      get :index, auth_token: user.auth_token, id: user.id

      expect(response.decoded_body['count']).to eq(user.favorite_photos.count)
    end
  end
end
