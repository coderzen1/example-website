require 'rails_helper'

describe Api::V1::PhotosController do
  default_version 1

  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:photo) { create(:photo) }
  let(:serialized_photo) { attributes_for(:photo) }
  let(:lateral) { create(:lateral) }

  before do
    allow_any_instance_of(PhotoSerializer)
      .to receive(:scope).and_return(user)
  end

  describe "#show" do
    context "when finding an existing photo" do
      before(:each) { get :show, id: photo.id, auth_token: user.auth_token }

      it "should be a singular resource" do
        expect(response).to be_singular_resource
      end

      it "should expose the photo" do
        expect(response).to have_exposed(photo)
      end

      it "should conform to the defined schema" do
        expect(response).to match_response_schema("photo")
      end
    end

    context "when finding an image that doesn't exist" do
      it "should throw a RocketPants::NotFound error" do
        get :show, id: 20, auth_token: user.auth_token

        expect(response).to be_api_error(RocketPants::NotFound)
      end
    end
  end

  describe "#create" do
    context "when creating a photo with the correct data" do
      it "should create a new photo record" do
        expect do
          post :create,
               { auth_token: user.auth_token }
            .merge(attributes_for(:photo)
            .merge(restaurant_id: lateral.id, tag_list: %w(spicy hot)))
        end.to change(Photo, :count).by(1)
      end

      it "should expose the photo" do
        post :create,
             { auth_token: user.auth_token }
          .merge(attributes_for(:photo)
          .merge(restaurant_id: lateral.id, tag_list: %w(spicy hot)))

        last_photo = Photo.last

        expect(response).to be_success
        expect(response).to have_exposed(last_photo)
      end

      it "should save the tags" do
        post :create, {
          auth_token: user.auth_token
        }.merge(
          attributes_for(:photo)
          .merge(tag_list: %w(spicy hot), restaurant_id: lateral)
        )

        last_photo = Photo.last

        expect(last_photo.tags.count).to eq(2)
        expect(last_photo.tags.map(&:name)).to match_array(%w(spicy hot))
      end

      it "should conform to the defined schema" do
        post :create,
             { auth_token: user.auth_token }
          .merge(attributes_for(:photo)
          .merge(restaurant_id: lateral.id, tag_list: %w(spicy hot)))

        expect(response).to match_response_schema("photo")
      end
    end

    context "when creating a photo without the image" do
      before do
        post :create,
             { auth_token: user.auth_token }.merge(attributes_for(:photo,
                                                                  image: nil))
      end

      it "should raise an error" do
        expect(response).to be_api_error(RocketPants::InvalidResource)
      end

      it "should return the correct error message" do
        expect(response.parsed_body["messages"]["image"].first)
          .to eq("can't be blank")
      end
    end
  end

  describe "#index" do
    context 'when not given an id' do
      before do
        create_list(:photo, 10, owner: user)
      end

      it "should return all the photos of the current user" do
        get :index, auth_token: user.auth_token

        expect(response.decoded_body["count"]).to eq(user.photos.count)
      end

      it "should expose a paginated collection" do
        get :index, auth_token: user.auth_token

        expect(response).to be_paginated_resource
      end

      it "should conform to the schema" do
        get :index, auth_token: user.auth_token

        expect(response).to match_response_schema("paginated_photos_collection")
      end

      it "should expose a collection of photos" do
        get :index, auth_token: user.auth_token

        expect(response)
          .to have_exposed(user.photos.approved.not_deleted.order(created_at: :desc))
      end

      it 'should be paginated' do
        get :index, auth_token: user.auth_token, page: 1, per_page: 5
      end
    end

    context 'when given an id' do
      before do
        create_list(:photo, 10, owner: other_user)
      end

      it "should return all the photos of the user's given id" do
        get :index, auth_token: user.auth_token, id: other_user.id

        expect(response).to match_response_schema('paginated_photos_collection')
        expect(response.decoded_body['count']).to eq(other_user.photos.count)
      end
    end
  end

  describe "PUT #update" do
    let(:photo_owned_by_user) { create(:photo, owner: user) }
    let(:new_restaurant) { create(:restaurant) }

    context "with correct information" do
      before do
        put :update, auth_token: user.auth_token, id: photo_owned_by_user.id,
                     caption: 'Updated caption',
                     restaurant_id: new_restaurant.id,
                     tag_list: %w(updated tags)
      end

      it "should update the image information" do
        photo_owned_by_user.reload

        expect(photo_owned_by_user.caption).to eq('Updated caption')
        expect(photo_owned_by_user.restaurant_id).to eq(new_restaurant.id)
        expect(photo_owned_by_user.tag_list).to match_array(%w(updated tags))
      end

      it "should return a photo" do
        expect(response).to have_exposed(photo_owned_by_user.reload)
      end
    end

    context "when given invalid information" do
      before do
        put :update, auth_token: user.auth_token, id: photo_owned_by_user.id,
                     caption: nil
      end

      it "should return an error" do
        expect(response).to be_api_error(RocketPants::InvalidResource)
      end

      it "should include the invalid field in the response" do
        expect(response.decoded_body['messages']).to include('caption')
      end
    end
  end

  describe 'DELETE #destroy' do
    describe 'when destroying a photo' do
      let(:photo_with_owner) { create(:photo, owner: user) }

      before do
        delete :destroy, auth_token: user.auth_token,
                         id: photo_with_owner.id
      end

      it 'should set the deleted_at field in the photo' do
        photo_with_owner.reload

        expect(photo_with_owner.deleted_at).to_not be_nil
      end

      it 'should return the deleted photo' do
        expect(response).to have_exposed(photo_with_owner)
      end
    end
  end

  describe "#discover" do
    before do
      create_list(:photo, 10, owner: user)
    end

    it "should expose a paginated resource" do
      get :discover, auth_token: user.auth_token,
                     lat: Photo.first.restaurant.lat,
                     lng: Photo.first.restaurant.lng

      expect(response).to be_paginated_resource

      expect(response.decoded_body["count"]).to eq(10)
    end

    it "should expose a empty paginated resource if paginated too far" do
      get :discover, auth_token: user.auth_token, lat: 16, lng: 16, page: 2

      expect(response).to be_paginated_resource

      expect(response.decoded_body["count"]).to eq(0)
    end

    it "should fail if lat or long wasn't given" do
      get :discover, auth_token: user.auth_token

      expect(response).to be_api_error(RocketPants::InvalidResource)
    end

    it "should conform to the json schema" do
      get :discover, auth_token: user.auth_token, lat: 16, lng: 16, page: 1

      expect(response).to match_response_schema(:discover_photo)
    end

    it "should raise an error when not sending lat or lng" do
      get :discover, auth_token: user.auth_token, lat: 16, page: 1

      expect(response).to be_api_error(RocketPants::InvalidResource)
    end
  end
end
