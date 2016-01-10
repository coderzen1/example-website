require 'rails_helper'

describe FoodFave::Foursquare::RestaurantFactory do
  let(:lateral) do
    create(:lateral)
  end

  let(:lateral_parser) do
    FoodFave::Foursquare::RestaurantParser.new(
      name: 'Lateral',
      id: '3sda43er8',
      url: 'https://www.facebook.com/restoranlateral',
      contact: {
        formattedPhone: '+385 1 1111 111'
      },
      location: {
        lat: 45.8039401,
        lng: 15.9895105,
        cc: 'HR',
        country: 'Hrvatska',
        formattedAddress: ['Hrvatska']
      }
    )
  end

  let(:umami_parser) do
    FoodFave::Foursquare::RestaurantParser.new(
      name: 'Umami',
      id: 'dfh71ry433',
      url: 'https://www.facebook.com/umami.restoran',
      contact: {
        formattedPhone: '+385 1 1111 111'
      },
      location: {
        lat: 45.8039401,
        lng: 15.9895105,
        address: 'Skalinska 3',
        postalCode: '10000',
        city: 'Zagreb',
        state: 'Grad Zagreb',
        cc: 'HR',
        country: 'Hrvatska',
        formattedAddress: ['Skalinska 3', '10000 Zagreb', 'Hrvatska']
      }
    )
  end

  describe "when passing in a restaurant that doesn't exist" do
    it "should create a new restaurant" do
      expect do
        FoodFave::Foursquare::RestaurantFactory.new(
          lateral_parser
        ).find_or_create
      end.to change(Restaurant, :count).by(1)
    end

    it "should trigger a delayed job" do
      expect do
        FoodFave::Foursquare::RestaurantFactory.new(
          lateral_parser
        ).find_or_create
      end.to change(enqueued_jobs, :size).by(1)
    end

    it "should set the restaurants_request_id if passed in" do
      restaurant =
        FoodFave::Foursquare::RestaurantFactory.new(
          lateral_parser,
          restaurants_request_id: 5
        ).find_or_create

      expect(restaurant.reload.restaurants_request_id).to eq('5')
    end
  end

  describe "when passing information from a restaurant that already exists" do
    before do
      lateral
    end

    it "should not create a restaurant" do
      expect do
        FoodFave::Foursquare::RestaurantFactory.new(
          lateral_parser
        ).find_or_create
      end.not_to change(Restaurant, :count)
    end
  end
end
