require 'rails_helper'

RSpec.describe RestaurantOwner, type: :model do
  let(:user) { FactoryGirl.build(:restaurant_owner) }
  context 'when missing name' do
    it 'validates presence of name' do
      user.name = nil

      expect(user.valid?).to eq(true)
      expect(user.errors[:name]).to eq([])
    end
  end

  context 'when missing email' do
    it 'validates presence of email' do
      user.email = nil

      expect(user.valid?).to eq(false)
      expect(user.errors[:email]).to include("can't be blank")
    end
  end

  context 'when missing password' do
    it 'validates presence of password' do
      user.password = nil

      expect(user.valid?).to eq(false)
      expect(user.errors[:password]).to eq(["can't be blank"])
    end
  end

  context 'when missing birthday' do
    it 'validates presence of birthday' do
      user.birthday = nil

      expect(user.valid?).to eq(true)
      expect(user.errors[:birthday]).to eq([])
    end
  end
end
