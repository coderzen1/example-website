require 'rails_helper'

describe Api::V1::RelationshipsController do
  default_version 1

  let(:follower) { create(:user) }

  let(:followee) { create(:user) }

  describe "POST #create" do
    context "follower follows followee" do
      it "should return the current user" do
        post :create, id: followee.id, auth_token: follower.auth_token

        expect(response).to be_singular_resource
        expect(response).to have_exposed(follower.reload)
      end

      it "should increment the following count" do
        post :create, id: followee.id, auth_token: follower.auth_token

        expect(response.decoded_body["response"]["following_count"]).to eq(1)
      end

      it "should create a relationship" do
        expect do
          post :create, id: followee.id, auth_token: follower.auth_token
        end.to change(Relationship, :count).by(1)
      end
    end

    context "follower can't follow followee twice" do
      it "should return an error" do
        follower.follow(followee)

        post :create, id: followee.id, auth_token: follower.auth_token

        expect(response).to be_api_error(RocketPants::InvalidResource)
      end
    end
  end

  describe "DELETE #destroy" do
    it "follower unfollows followee" do
      follower.follow(followee)

      delete :destroy, id: followee.id, auth_token: follower.auth_token

      expect(response).to be_singular_resource
      expect(response).to have_exposed(follower.reload)
    end

    it "removes a relationship" do
      follower.follow(followee)

      expect do
        delete :destroy, id: followee.id, auth_token: follower.auth_token
      end.to change(Relationship, :count).by(-1)
    end

    it "follower can't unfollow followee he is not following" do
      delete :destroy, id: followee.id, auth_token: follower.auth_token

      expect(response).to be_api_error(RocketPants::NotFound)
    end

    it "follower can't unfollow followee twice" do
      follower.follow(followee)
      follower.unfollow(followee)

      delete :destroy, id: followee.id, auth_token: follower.auth_token

      expect(response).to be_api_error(RocketPants::NotFound)
    end
  end
end
