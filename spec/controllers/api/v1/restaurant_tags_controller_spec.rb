require 'rails_helper'

describe Api::V1::RestaurantTagsController do
  default_version 1

  let(:user) { create(:user) }
  let(:restaurants) { create_list(:restaurant, 2) }
  let(:first_restaurant_photo) { create(:photo, restaurant: restaurants[0]) }
  let(:second_restaurant_photo) { create(:photo, restaurant: restaurants[0]) }
  let(:photos_from_another_restaurant) { create(:photo, restaurant: restaurants[1]) }

  describe 'GET #index' do
    before do
      first_restaurant_photo.tags << create_list(:tag, 2)
      second_restaurant_photo.tags << create_list(:tag, 3)
      photos_from_another_restaurant.tags << create_list(:tag, 4)
    end

    it "should return a list of tags for all the photos of a restaurant" do
      get :index, auth_token: user.auth_token,
                  id: restaurants[0].id

      all_tag_names =
        (first_restaurant_photo.tags + second_restaurant_photo.tags)
        .collect(&:name)

      expect(response.decoded_body["response"].count).to eq(5)

      expect(response.decoded_body["response"].collect(&:name))
        .to match_array(all_tag_names)
    end

    it "should not return unrelated tags" do
      get :index, auth_token: user.auth_token,
                  id: restaurants[1].id

      expect(response.decoded_body["response"].collect(&:name))
        .not_to include(*first_restaurant_photo.tags.collect(&:name))
      expect(response.decoded_body["response"].collect(&:name))
        .not_to include(*second_restaurant_photo.tags.collect(&:name))
    end
  end
end
