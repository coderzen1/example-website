require 'rails_helper'

RSpec.describe GeneralInfoForm, type: :model do
  let(:info) { GeneralInfoForm.new() }

  context 'when missing resturant name' do
    it 'validates presence of resturant name' do
      info.restaurant_name = nil
      expect(info.valid?).to eq(false)
      expect(info.errors[:restaurant_name]).to eq(["can't be blank"])
    end
  end

  context 'when missing owner name' do
    it 'validates presence of owner name' do
      info.owner_name = nil
      expect(info.valid?).to eq(false)
      expect(info.errors[:owner_name]).to eq(["can't be blank"])
    end
  end

  context 'when missing owner birthday' do
    it 'validates presence of owner birthday' do
      info.owner_birthday = nil
      expect(info.valid?).to eq(false)
      expect(info.errors[:owner_birthday]).to eq(["can't be blank"])
    end
  end
end
