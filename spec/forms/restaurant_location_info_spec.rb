require 'rails_helper'

describe RestaurantLocationInfo do
  let(:restaurant) { create(:restaurant, address: nil) }
  let(:restaurant_owner) do
    create(:restaurant_owner, registration_status: :restaurant_location_info,
           restaurant: restaurant)
  end

  it { should validate_presence_of :lat }
  it { should validate_presence_of :lng }

  describe '#formatted_coordinates' do
    context 'when lat and lng are present' do
      let(:lat) { 10 }
      let(:lng) { 10 }
      let(:restaurant_location_info) do
        RestaurantLocationInfo.new(
          lat: lat, lng: lng, user: restaurant_owner, restaurant: restaurant
        )
      end

      it 'should return formatted coordinates' do
        expect(restaurant_location_info.formatted_coordinates)
          .to eq('N' + lat.round(4).to_s + ', W' + lng.round(4).to_s)
      end

      it 'should set the restaurant owner registration status to finished' do
        expect do
          restaurant_location_info.save
        end.to change(
          restaurant_owner, :registration_status
        ).from('restaurant_location_info').to('finished')
      end
    end

    context 'when lat and lng are not present' do
      let(:restaurant_location_info) do
        RestaurantLocationInfo.new
      end

      it 'should return --' do
        expect(restaurant_location_info.formatted_coordinates)
          .to eq('--')
      end
    end
  end
end
