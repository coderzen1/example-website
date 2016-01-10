require 'rails_helper'

describe Photo do
  let(:photo) { build(:photo) }

  describe "an uploaded photo" do
    it { should validate_presence_of(:caption) }
    it { should validate_presence_of(:restaurant) }
    it { should validate_presence_of(:image) }
  end
end
