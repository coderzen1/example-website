require 'rails_helper'
RSpec.describe RestaurantOwners::TagReportActionsController, type: :controller do
  let(:restaurant_owner) { create(:restaurant_owner, registration_status: 3) }
  let(:tag) { create(:tag) }
  let(:tag_report) { TagReport.create(tag:tag, reporter:restaurant_owner) }
  let(:tag_report_hash) do
    {
      "tag_report_actions_attributes"=>
      {
        "0"=>
        {
          "photo_id"=>"1", "action"=>"remove", "tag_suggestion"=>"funny"
        }
      }
    }
  end
  before do
    sign_in restaurant_owner
  end

  describe "PUT #update" do
    context "when valid" do
      it "creates a new tag_report_action" do
        expect { xhr :put, :update, tag_report: tag_report_hash, id: tag_report.id} .to change(TagReportAction, :count).by(1)
      end
    end
  end
end
