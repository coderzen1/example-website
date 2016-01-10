require 'rails_helper'

RSpec.describe PhotoReport, type: :model do
  let(:photo) { create(:photo) }
  let(:restaurant_owner) { create(:restaurant_owner) }
  let!(:report) do
    create(:photo_report, photo: photo, reporter: restaurant_owner)
  end
  let(:report2) do
    build(:photo_report, photo: photo, reporter: restaurant_owner)
  end

  context 'when missing reporter_id' do
    it 'validates presence of reporter_id' do
      report.reporter_id = nil

      expect(report.valid?).to eq(false)
    end
  end

  context 'when duplicate records' do
    it 'validates uniqueness of reporter and photo' do
      expect(report2.valid?).to eq(false)
    end
  end

  context 'when missing photo_id' do
    it 'validates presence of photo_id' do
      report.photo_id = nil
      expect(report.valid?).to eq(false)
    end
  end
end
