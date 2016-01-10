require 'rails_helper'

RSpec.describe Restaurant, type: :model do
  context 'a normal restaurant' do
    it { should validate_presence_of :lat }
    it { should validate_presence_of :lng }
    it { should validate_presence_of :name }
    # it { should validate_presence_of :address }
  end

  context 'a restaurant with restaurants_request_id present' do
    let(:restaurant) { build(:restaurant, restaurants_request_id: "bla") }
    subject { restaurant }

    it { should validate_presence_of :foursquare_id }
    # it { should_not validate_presence_of :address }
  end
end
