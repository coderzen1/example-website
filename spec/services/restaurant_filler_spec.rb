require 'rails_helper'

describe RestaurantFiller do

  let(:lat) { 45.8039700 }

  let(:lng) { 15.9899826 }

  let(:search_venues_body) do
    { meta: { code: 200 },
      response: {
        venues: [
            {
              name: 'Lateral',
              id: '3sda43er8',
              url: 'https://www.facebook.com/restoranlateral',
              contact: {
                formattedPhone: '+385 1 1111 111'
              },
              location: {
                lat: 45.8039401,
                lng: 15.9895105,
                formattedAddress: ['Hrvatska']
              }
            },
            {
              name: 'Umami',
              id: 'dfh71ry433',
              url: 'https://www.facebook.com/umami.restoran',
              contact: {
                formattedPhone: '+385 1 1111 111'
              },
              location: {
                lat: 45.8141409,
                lng: 15.9757991,
                formattedAddress: ['Skalinska 3', '10000 Zagreb', 'Hrvatska']
              }
            }
        ]}
    }.to_json
  end

  let(:restaurant_filler) { RestaurantFiller.new(lat: lat, lng: lng, radius: 5000) }

  let(:lateral) { create(:lateral) }

  let(:umami) { create(:umami) }

  before do
    stub_request(:get, %r{\Ahttps://api.foursquare.com/v2/venues/search})
      .to_return(body: search_venues_body, status: 200)
  end

  describe "when filling in restaurants" do
    it "should create two restaurants if no request was sent before" do
      expect do
        restaurant_filler.call
      end.to change{ Restaurant.count }.from(0).to(2)

      Restaurant.all.each do |restaurant|
        expect(restaurant.restaurants_request.id).to eq(RestaurantsRequest.first.id)
      end
    end

    it "should not create restaurants if a similar request was sent before" do
      RestaurantsRequest.create!(lat: lat, lng: lng, radius: 5000)

      expect do
        restaurant_filler.call
      end.not_to change{ Restaurant.count }
    end

    it 'one restaurant already persisted, one should be created' do
      lateral

      expect do
        restaurant_filler.call
      end.to change{ Restaurant.count }.from(1).to(2)
    end

    it 'two restaurants already persisted, none should be created' do
      lateral
      umami

      expect do
        restaurant_filler.call
      end.not_to change{ Restaurant.count }
    end

  end
end
