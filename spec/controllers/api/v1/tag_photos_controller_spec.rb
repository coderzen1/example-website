require 'rails_helper'

describe Api::V1::TagPhotosController do
  default_version 1

  let(:user) { create(:user) }
  let(:tag_with_photos) { create(:tag) }
  let(:tag_without_photos) { create(:tag) }

  describe 'GET #index' do
    before do
      @photos = create_list(:photo, 15)
      @photos.each do |photo|
        photo.tags << tag_with_photos
      end

      allow_any_instance_of(PhotoActivitySerializer)
        .to receive(:scope).and_return(user)
    end

    it "should return all photos for a tag" do
      get :index, id: tag_with_photos.id,
                  auth_token: user.auth_token,
                  page: 1,
                  per_page: 10

      expect(response.decoded_body["count"]).to eq(10)
      expect(response).to be_paginated_resource
      expect(response)
        .to have_exposed(@photos.take(10),
                         each_serializer: PhotoActivitySerializer)
    end

    it "should not return anything if the tag has no associated photos" do
      get :index, id: tag_without_photos.id,
                  auth_token: user.auth_token,
                  page: 1,
                  per_page: 10

      expect(response.decoded_body["count"]).to eq(0)
      expect(response).to be_paginated_resource
      expect(response.decoded_body["response"]).to be_empty
    end
  end
end
