require 'rails_helper'

describe DiscoverScreenService do

  let(:lat) { first_photo.restaurant.lat }

  let(:lng) { first_photo.restaurant.lng }

  let!(:lateral) { create(:lateral) }

  let!(:umami) { create(:umami) }

  let(:first_user) { create(:user)  }

  let(:second_user) { create(:user) }

  let(:third_user) { create(:user) }

  let(:first_photo) { create(:photo, created_at: 4.hours.ago) }

  let(:second_photo) { create(:photo, created_at: 3.hours.ago) }

  let(:third_photo) { create(:photo, created_at: 2.hours.ago) }

  describe "when searching for restaurants" do
    before do
      first_photo.fans  << [first_user, second_user, third_user]
      second_photo.fans << [first_user, second_user, third_user]
      third_photo.fans  << [first_user, second_user, third_user]
    end

    it "should handout relation of three with calculated ratings" do
      discovered_photos = DiscoverScreenService.new(lat: lat, lng: lng).call
      expect(discovered_photos.count).to eq(3)

      first_result  = discovered_photos[0]
      second_result = discovered_photos[1]
      third_result  = discovered_photos[2]

      [first_photo, second_photo, third_photo].each(&:reload)

      expect(first_result.id).to  eq(third_photo.id)
      expect(second_result.id).to eq(second_photo.id)
      expect(third_result.id).to  eq(first_photo.id)

      expect(first_result.rating).to  eq(RatingCalculator.new(third_photo).score)
      expect(second_result.rating).to eq(RatingCalculator.new(second_photo).score)
      expect(third_result.rating).to  eq(RatingCalculator.new(first_photo).score)
    end

    it 'should be invalid if lat or lng are strings' do
      discover_screen_service = DiscoverScreenService.new(lat: 'abc', lng: lng)
      expect(discover_screen_service).to be_invalid
    end
  end
end
