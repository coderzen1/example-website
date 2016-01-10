require 'rails_helper'

describe Favorite do
  let(:user) { create(:user) }
  let(:photo) { create(:photo) }
  let(:restaurant) { create(:restaurant) }

  describe "if the user tries to favorite the same picture twice" do
    before do
      user.favorite_photos << photo
    end

    it "should not be valid" do
      favorite = Favorite.new(user: user, faved: photo)

      expect(favorite).to_not be_valid
    end
  end

  describe "when favoriting" do
    it "should be able to favorite both restaurants and photos" do
      favorite_1 = Favorite.new(user: user, faved: photo)
      favorite_2 = Favorite.new(user: user, faved: restaurant)

      expect(favorite_1).to be_valid
      expect(favorite_2).to be_valid
    end

    it "should increase the counter cache on photos" do
      expect do
        Favorite.create(user: user, faved: photo)
        photo.reload
      end.to change(photo, :favorites_count).from(0).to(1)
    end

    it "should not increase the counter cache on user if favoriting a photo" do
      expect do
        Favorite.create(user: user, faved: photo)
        user.reload
      end.not_to change(user, :favorite_restaurants_count)
    end
  end

  describe "when favoriting a restaurant" do
    it "should increase the counter cache on users" do
      expect do
        Favorite.create(user: user, faved: restaurant)
        user.reload
      end.to change(user, :favorite_restaurants_count).from(0).to(1)
    end
  end

  describe "when unfavoriting a restaurant" do
    before { Favorite.create(user: user, faved: restaurant) }

    it "should decrease the counter cache on users" do
      user.reload

      expect do
        Favorite.first.destroy
        user.reload
      end.to change(user, :favorite_restaurants_count).from(1).to(0)
    end
  end
end
