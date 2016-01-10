require 'rails_helper'

describe NearbyPlaces do

  let(:lat) { 45.8039700 }

  let(:lng) { 15.9899826 }

  let!(:lateral) { create(:lateral) }

  let!(:umami) { create(:umami) }

  context 'when searching over an area' do
    it 'should return all local restaurants' do
      expect(NearbyPlaces.new(lat: lat, lng: lng).call)
        .to match_array([lateral, umami])
    end
  end

  describe 'when searching for restaurants' do
    context 'when the search term is capitalized' do
      it 'should return a restaurant' do
        expect(
          NearbyPlaces.new(lat: lat, lng: lng, search_term: 'Lateral').call
        ).to match_array([lateral])
      end
    end

    context 'when the search term is downcased' do
      it 'should handout relation of one that matches a search term even if downcased' do
        expect(
          NearbyPlaces.new(lat: lat, lng: lng, search_term: 'lateral').call
        ).to match_array([lateral])
      end
    end

    context 'when the search term is upcased' do
      it 'should return a restaurant' do
        expect(
          NearbyPlaces.new(lat: lat, lng: lng, search_term: 'LATERAL').call
        ).to match_array([lateral])
      end
    end

    context 'when given a partial search term' do
      it 'should return a restaurant' do
        expect(
          NearbyPlaces.new(lat: lat, lng: lng, search_term: 'lat').call
        ).to match_array([lateral])
      end
    end
  end

  context 'when given lat and lng as strings' do
    it 'should be invalid' do
      nearby_places_finder = NearbyPlaces.new(lat: 'abc', lng: lng)
      expect(nearby_places_finder).to be_invalid
    end
  end
end
