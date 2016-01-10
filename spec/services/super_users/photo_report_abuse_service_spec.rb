require 'rails_helper'

describe SuperUsers::PhotoReportAbuseService do
  let(:restaurant) { create(:restaurant) }
  let(:user) { create(:user) }
  let(:restaurant_owner) do
    create(:restaurant_owner, registration_status: 2, restaurant: restaurant)
  end

  let(:photo1) do
    create(:photo, restaurant: restaurant, owner: user)
  end

  let(:photo2) do
    create(:photo, restaurant: restaurant, owner: user)
  end

  let(:photo3) do
    create(:photo, restaurant: restaurant, owner: user)
  end

  let(:report1) { PhotoReport.create(photo_id: photo1.id, reporter: restaurant_owner) }
  let(:report2) { PhotoReport.create(photo_id: photo2.id, reporter: restaurant_owner) }
  let(:report3) { PhotoReport.create(photo_id: photo3.id, reporter: restaurant_owner) }

  describe "when filtering user" do
    it "should flag user as flagged" do
      photo1.removed!
      photo2.removed!
      photo3.removed!

      SuperUsers::PhotoReportAbuseService
        .new(photo1)
        .check_abuse!

      expect { user.reload }.to change(user, :flagged).from(false).to(true)
    end
  end

  describe "when filtering user" do
    it "should flag user as flagged" do
      photo1.removed!
      photo2.removed!

      SuperUsers::PhotoReportAbuseService
        .new(photo1)
        .check_abuse!

      expect(user.flagged).to eql(false)
    end
  end
end
