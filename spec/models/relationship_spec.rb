require 'rails_helper'

describe Relationship do
  let(:user) { create(:user) }
  let(:fb_user) { create(:facebook_user) }

  context "when creating a relationship" do
    context "that already exists" do
      before do
        Relationship.create(follower_id: user.id,
                            followed_id:  fb_user.id)
        @relationship = Relationship.new(follower_id: user.id,
                                         followed_id:  fb_user.id)
      end

      it "should not be saved to the database" do
        expect do
          @relationship.save
        end.not_to change(User, :count)
      end

      it "should not be valid" do
        @relationship.save
        @relationship.valid?
        expect(@relationship.errors[:follower_id])
          .to include("has already been taken")
      end
    end
  end
end
