require 'rails_helper'

describe RestaurantPositions do

  let(:lat) { 45.8039700 }

  let(:lng) { 15.9899826 }

  let!(:lateral) { create(:lateral) }

  let!(:umami) { create(:umami) }

  before do
    allow_any_instance_of(RestaurantFiller)
      .to receive(:area_covered?).and_return(true)
  end

  describe "when searching for restaurants" do
    it "should handout relation of one" do
      expect(RestaurantPositions.new(lat: lat, lng: lng, radius: 50).call).to match_array([lateral])
    end

    it "should handout relation of two if larger radius" do
      expect(RestaurantPositions.new(lat: lat, lng: lng, radius: 4000).call).to match_array([lateral, umami])
    end

    it 'should be invalid if lat or lng are strings' do
      restaurant_position_finder = RestaurantPositions.new(lat: 'abc', lng: lng, radius: 4000)
      expect(restaurant_position_finder).to be_invalid
    end
  end
end
