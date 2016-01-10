require 'rails_helper'

describe Api::V1::UsersController do
  default_version 1

  let(:user) do
    create(:user_with_followers_and_following,
           number_of_followers: 10,
           number_of_following: 7)
  end

  let(:fb_user) { create(:facebook_user) }

  let(:user_attributes) { attributes_for(:user) }

  let(:missmatched_password_user_attributes) do
    attributes_for(:user, password_confirmation: "sadas")
  end

  let(:custom_profile_picture) do
    Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'images', 'chicken-meal.jpg'))
  end

  let(:mocked_facebook_response) do
    {
      "id" => "1384763815174614",
      "email" => "stephen_rznbjhq_ellis@tfbnw.net",
      "first_name" => "Stephen",
      "gender" => "male",
      "last_name" => "Ellis",
      "link" => "https://www.facebook.com/app_scoped_user_id/1384763815174614/",
      "location" => { "id" => "108424279189115", "name" => "New York, New York" },
      "locale" => "en_US",
      "name" => "Stephen Ellis",
      "timezone" => 0,
      "updated_time" => "2015-03-09T10:23:01+0000",
      "verified" => false
    }
  end

  before do
    allow_any_instance_of(UserProfileSerializer)
      .to receive(:scope).and_return(user)
    allow_any_instance_of(UserRelationshipSerializer)
      .to receive(:scope).and_return(user)
  end

  describe "#show" do
    describe "when finding an existing user" do
      it "the response should be a singular resource" do
        get :show, id: user.id, auth_token: user.auth_token

        expect(response).to be_singular_resource
      end

      it "the response should expose the user" do
        get :show, id: user.id, auth_token: user.auth_token

        expect(response).to have_exposed(user.reload,
                                         serializer: UserProfileSerializer)
      end

      it "should conform to the defined schema" do
        get :show, id: user.id, auth_token: user.auth_token

        expect(response).to match_response_schema("user_profile")
      end

      it "should say if you're following that user" do
        user.follow(fb_user)
        get :show, id: fb_user.id, auth_token: user.auth_token

        expect(user.following?(fb_user)).to eq(true)
        expect(response.decoded_body["response"]["following_this_user"])
          .to eq(true)
      end
    end

    describe "when trying to find a user that does not exist" do
      it "should throw an RocketPants::NotFound error" do
        get :show, id: 1, auth_token: user.auth_token
        expect(response).to be_api_error(RocketPants::NotFound)
      end
    end
  end

  describe "#oauth_login" do
    context "when logging with the correct data" do
      before do
        stub_request(:get, %r{\Ahttps://graph.facebook.com(/v2.\d)?/me(.*)})
          .to_return(body: mocked_facebook_response.to_json, status: 200)
      end

      it "should return the user" do
        get :oauth_login, provider: "facebook",
                          auth_token: "some_auth_token"

        user = User.find_by(auth_token: "some_auth_token")

        expect(response)
          .to have_exposed(user, serializer: CompactUserSerializer)
      end
    end

    context "when loggin in with invalid data" do
      before do
        stub_request(:get, %r{\Ahttps://graph.facebook.com(/v2.\d)?/me(.*)})
          .to_return(body: mocked_facebook_response.merge("id" => "").to_json)

        get :oauth_login, provider: "facebook",
                          auth_token: "some_auth_token"
      end

      it "should raise an error" do
        expect(response).to be_api_error(RocketPants::InvalidResource)
      end

      it "should return the raised error" do
        expect(response.decoded_body["messages"]["base"].first)
          .to include("Either uid and provider")
      end
    end

    context "when loggin in with no data" do
      before do
        get :oauth_login
      end

      it "should raise an error" do
        expect(response).to be_api_error(RocketPants::BadRequest)

        expect(response.decoded_body['error_description']['provider'])
          .to include("can't be blank")
      end
    end

    context "when logging in through facebook without an auth_token" do
      it "should raise an error" do
        get :oauth_login, provider: "facebook"
        expect(response).to be_api_error(RocketPants::BadRequest)

        expect(response.decoded_body['error_description']["auth_token"])
          .to include("can't be blank")
      end

    context "when logging in thorough twitter without an auth_token"
      it "should raise an error" do
        get :oauth_login, provider: "twitter",
                          auth_token_secret: "some_auth_token_secret"

        expect(response).to be_api_error(RocketPants::BadRequest)

        expect(response.decoded_body['error_description']['auth_token'])
          .to include("can't be blank")
      end
    end

    context "when logging in through twitter without an auth_token_secret" do
      it "should raise an error" do
        get :oauth_login, provider: "twitter",
                          auth_token: "some_auth_token"

        expect(response).to be_api_error(RocketPants::BadRequest)

        expect(response.decoded_body['error_description']["auth_token_secret"])
          .to include("can't be blank")
      end
    end
  end

  describe "#login" do
    describe "when sending correct params" do
      it "should expose the auth token" do
        post :login, email: user.email, password: "password1"

        expect(response).to have_exposed(user, serializer: CompactUserSerializer)
      end
    end

    describe "when sending an incorrect password" do
      before do
        post :login, email: "test-email@email.com", password: "password2"
      end

      it "should raise an invalid resource error" do
        expect(response).to be_api_error(RocketPants::InvalidResource)
      end

      it "should return an invalid login error message" do
        expect(response.parsed_body["error_description"])
          .to eq("Invalid login information.")
      end
    end

    describe "when sending an incorrect email" do
      it "should raise an invalid resource error" do
        post :login, email: "test-emsaa@email.com", password: "password1"

        expect(response).to be_api_error(RocketPants::InvalidResource)
      end
    end
  end

  describe "#create" do
    describe "when sending correct params" do
      it "should create a user" do
        expect do
          post :create, user: user_attributes
        end.to change(User, :count).by(1)
      end

      it "should expose the user" do
        post :create, user: user_attributes

        created_user = User.find_by(email: user_attributes[:email])

        expect(response).to have_exposed(created_user)
      end

      it "should correctly return the small version of an uploaded image" do
        post :create, user: user_attributes,
                      custom_profile_picture: custom_profile_picture

        created_user = User.find_by(email: user_attributes[:email])

        expect(response.decoded_body["response"]["profile_picture"])
          .to eq(created_user.custom_profile_picture.small.url)
      end
    end

    describe "when sending incorrect params" do
      it "should not create a new user" do
        expect do
          post :create, user: missmatched_password_user_attributes
        end.not_to change(User, :count)
      end

      it "should raise the appropriate error" do
        post :create, user: missmatched_password_user_attributes
        expect(response).to be_api_error(RocketPants::InvalidResource)
      end

      it "should return the correct error message" do
        post :create, user: missmatched_password_user_attributes
        expect(response.parsed_body["messages"]["password_confirmation"].first)
          .to eq("doesn't match Password")
      end
    end
  end

  describe "#followers" do
    it "should be paginated" do
      get :followers, id: user.id, auth_token: user.auth_token,
                      page: 1, per_page: 10

      expect(response).to be_paginated_resource
    end

    it "should expose the user's followers" do
      get :followers, id: user.id, auth_token: user.auth_token,
                      page: 1, per_page: 10

      expect(response).to have_exposed(
        user.followers.take(10), each_serializer: UserRelationshipSerializer
      )
    end

    it "should return all the followers if there are multiple followers" do
      get :followers, id: user.id, auth_token: user.auth_token,
                      page: 1, per_page: 10

      expect(response.decoded_body["count"]).to eq(10)
    end

    it "should return paginated followers for any user" do
      get :followers, id: fb_user.id, auth_token: user.auth_token,
                      page: 1, per_page: 5

      expect(response).to have_exposed(
        fb_user.followers.take(5), each_serializer: UserRelationshipSerializer
      )
    end

    it "should return if the user is following another user or not" do
      fb_user.following << user.followers.first

      get :followers, id: user.id, auth_token: fb_user.auth_token,
                      page: 1, per_page: 5

      expect(response.decoded_body["response"].first["following_this_user"])
    end
  end

  describe "#following" do
    it "should be paginated" do
      get :following, id: user.id, auth_token: user.auth_token,
                      page: 1, per_page: 10
      expect(response).to be_paginated_resource
    end

    it "should expose paginated users a user is following" do
      get :following, id: user.id, auth_token: user.auth_token,
                      page: 1, per_page: 10

      expect(response).to have_exposed(
        user.following.take(10), each_serializer: UserRelationshipSerializer
      )
    end

    it "should return all the followed users if a user if following multiple users" do
      get :following, id: user.id, auth_token: user.auth_token,
                      page: 1, per_page: 10
      expect(response.decoded_body["count"]).to eq(7)
    end

    it "should return paginated followed users for any user" do
      get :following, id: user.id, auth_token: fb_user.auth_token,
                      page: 1, per_page: 5

      expect(response).to have_exposed(
        user.following.take(5), each_serializer: UserRelationshipSerializer
      )
    end

    it "should return if you're following a user or not" do
      get :following, id: user.id, auth_token: user.auth_token,
                      page: 1, per_page: 10

      expect(response.decoded_body["response"].first["following_this_user"])
        .to eq(true)
    end
  end

  describe "#feed" do
    before do
      user.follow(fb_user)
      create_list(:photo, 20, owner: fb_user)
      user_photo = create(:photo, owner: user)
      user.favorite_photos << fb_user.photos.last
      user_photo.tags << create_list(:tag, 2)

      get :feed, id: user.id, per_page: 7, page: 1,
                 auth_token: user.auth_token
    end

    describe "requesting a feed" do
      it "should return paginated results" do
        expect(response).to be_paginated_resource
      end

      it "should return as many items as there were requested" do
        expect(response.decoded_body["count"]).to eq(7)
      end

      it "should return your uploaded photos" do
        expect(response.decoded_body["response"].collect(&:owner_id))
          .to include(user.id)
      end

      it "should return true if a user has favorited a photo" do
        favorited_photo =
          response.decoded_body["response"].find do |act|
            act["id"] == user.favorite_photos.first.id
          end

        expect(favorited_photo["id"])
          .to eq(user.favorite_photos.first.id)
        expect(favorited_photo["favorited"]).to eq(true)
      end

      it "should return the owner's profile picture" do
        expect(response.decoded_body["response"].first["owner_profile_picture"])
          .to eq(user.profile_picture)
      end

      it "should return a list of tags associated with the picture" do
        photo_with_tags =
          response.decoded_body["response"].find do |act|
            act.id == user.photos.first.id
          end

        expect(photo_with_tags["tags"].collect(&:id))
          .to match_array(user.photos.first.tags.pluck(:id))
      end

      it "should return the number of times a photo has been favorited" do
        favorited_photo =
          response.decoded_body["response"].find do |act|
            act["id"] == user.favorite_photos.first.id
          end

        expect(favorited_photo["favorites_count"]).to eq(1)
      end

      it "should conform to the JSON schema" do
        expect(response).to match_response_schema(:activity)
      end
    end
  end

  describe "PUT/PATCH #update"do
    let(:user_update_attributes) do
      {}.tap do |h|
        h[:username] = "Update Test"
        h[:email] = "update@gmail.com"
        h[:location] = "Zagreb, Croatia"
        h[:radius] = 20_000
        h[:private_faved_photos] = true
      end
    end

    before do
      put :update, user: user_update_attributes,
                   auth_token: user.auth_token
    end

    it "should return the updated user" do
      expect(response).to have_exposed(user.reload)
    end

    it "should update the user model" do
      user.reload

      user_update_attributes.each do |key, value|
        expect(user.send(key)).to eq(value)
      end
    end
  end

  describe "PUT/PATCH #update_password" do
    let(:update_password_params) do
      {
        current_password: "password1",
        password: "password2",
        password_confirmation: "password2"
      }
    end

    context "when correctly updating a password" do
      it "should expose the user" do
        put :update_password, auth_token: user.auth_token,
                              user: update_password_params

        expect(response).to have_exposed(user.reload)
        expect(response).to be_success
      end
    end

    context "when sending the wrong current_password" do
      it "should return an invalid resource error" do
        update_password_params[:current_password] = "wrong_password"

        put :update_password, auth_token: user.auth_token,
                              user: update_password_params

        expect(response).to be_api_error(RocketPants::InvalidResource)
        expect(response.decoded_body["messages"].keys)
          .to include("current_password")
        expect(response.decoded_body["messages"]["current_password"])
          .to include("is invalid")
      end
    end

    context "when sending missmatching passwords" do
      it "should return an invalid resource error" do
        update_password_params[:password_confirmation] = "missmatched_password"

        put :update_password, auth_token: user.auth_token,
                              user: update_password_params

        expect(response).to be_api_error(RocketPants::InvalidResource)
        expect(response.decoded_body["messages"].keys)
          .to include("password_confirmation")
        expect(response.decoded_body["messages"]["password_confirmation"])
          .to include("doesn't match Password")
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when deleting your profile' do
      it 'should not actually delete a user' do
        expect { delete :destroy, auth_token: user.auth_token }
          .not_to change(User, :count)
      end

      it 'should return a user' do
        delete :destroy, auth_token: user.auth_token

        expect(response).to have_exposed(user.reload)
      end

      it 'should marke the user as deleted' do
        delete :destroy, auth_token: user.auth_token

        expect { user.reload }
          .to change(user, :status).from('normal').to('deleted')
      end
    end
  end
end
