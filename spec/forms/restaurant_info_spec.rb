require 'rails_helper'

RSpec.describe RestaurantInfo, type: :model do
  let!(:restaurant) { build(:restaurant_info) }
  let!(:restaurant_owner) { create(:restaurant_owner) }

  it { should validate_presence_of :restaurant_name }
  it { should validate_presence_of :owner_name }
  it { should validate_presence_of :owner_birth }

  let(:restaurant_info_hash) do
    {}.tap do |h|
      h[:restaurant_name] = "test restoran"
      h[:owner_name] = "Owner Ime"
      h[:owner_birth] = "10. 10. 1989."
      h[:user] = restaurant_owner
    end
  end

  describe "when given valid information" do
    it "should return true" do
      expect(
        RestaurantInfo.new(restaurant_info_hash).save
      ).to eq(true)
    end

    it "should add a restaurant" do
      expect do
        RestaurantInfo.new(restaurant_info_hash).save
      end.to change(Restaurant, :count).by(1)
    end
  end

  describe "when given invalid information" do
    it "should return false" do
      restaurant_info_hash[:restaurant_name] = nil

      expect(
        RestaurantInfo.new(restaurant_info_hash).save
      ).to eq(false)
    end

    it "should not create a restaurant" do
      restaurant_info_hash[:restaurant_name] = nil

      expect do
        RestaurantInfo.new(restaurant_info_hash).save
      end.not_to change(Restaurant, :count)
    end
  end
end
