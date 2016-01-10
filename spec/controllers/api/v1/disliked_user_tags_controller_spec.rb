require 'rails_helper'
require_relative '../../../support/tag_suggestion_setup'

include TagSuggestionSetup

describe Api::V1::DislikedUserTagsController do
  default_version 1

  # TODO: Check responses
  let(:user) { create(:user) }

  let(:second_user) { create(:user) }

  let(:third_user) { create(:user) }

  before do
    create(:penne_creamy)
    create(:penne_vodka)
    create(:gnocchi)
  end

  let(:first_tag_name) { ActsAsTaggableOn::Tag.first.name }

  let(:second_tag_name) { ActsAsTaggableOn::Tag.second.name }

  let(:third_tag_name) { ActsAsTaggableOn::Tag.third.name }

  describe "POST #create" do
    it 'add tag to user if non existant yet' do
      expect do
        post :create, tag_name: first_tag_name, auth_token: user.auth_token
      end.to change(user.disliked_tags, :count).by(1)
    end

    it 'cant add same tag to user twice' do
      user.disliked_tag_list.add(first_tag_name)
      user.save

      expect do
        post :create, tag_name: first_tag_name, auth_token: user.auth_token
      end.not_to change(user.disliked_tags, :count)
    end
  end

  describe "POST #sync" do
    it 'sync tags while adding a new one' do
      user.disliked_tag_list.add([first_tag_name, second_tag_name])
      user.save

      expect do
        post :sync, tag_names: [first_tag_name,
                                second_tag_name,
                                third_tag_name],
                    auth_token: user.auth_token
      end.to change(user.disliked_tags, :count).by(1)
    end

    it 'sync tags while removing one' do
      user.disliked_tag_list.add([first_tag_name,
                                  second_tag_name,
                                  third_tag_name])
      user.save

      expect do
        post :sync, tag_names: [first_tag_name, second_tag_name],
                    auth_token: user.auth_token
      end.to change(user.disliked_tags, :count).by(-1)
    end
  end

  describe "GET #index" do
    before do
      user.disliked_tags << [ActsAsTaggableOn::Tag.first,
                             ActsAsTaggableOn::Tag.second,
                             ActsAsTaggableOn::Tag.third]
    end

    it 'should show all tags a user has liked' do
      get :index, auth_token: user.auth_token

      expect(response).to be_collection_resource
      expect(response.decoded_body["count"]).to eq(3)
    end
  end

  describe "GET #suggestions" do
    before do
      setup_database_for_disliked_tag_suggestions
      get :suggestions, auth_token: user.auth_token
    end

    it "should not return tags that you already disliked" do
      expect(response.decoded_body["response"].collect(&:tag_id).sort)
        .not_to include(user.disliked_tags.pluck(:id).sort)
    end

    it "should not return tags that you liked" do
      expect(response.decoded_body["response"].collect(&:tag_id).sort)
        .not_to include(user.favorite_tags.pluck(:id).sort)
    end

    it "should only return 10 tags" do
      expect(response.decoded_body["response"].count).to eq(10)
    end

    it "should sort the tags by number of appearance" do
      expect(response.decoded_body["response"][0]["count"]).to eq("2")
      expect(response.decoded_body["response"][1]["count"]).to eq("1")
    end

    it "should return an id instead of a tag_id" do
      expect(response.decoded_body["response"].first)
        .to include("id")
      expect(response.decoded_body["response"].first)
        .not_to include("tag_id")
    end

    it "should not show likes from users that didn't like the same tag" do
    end
  end
end
