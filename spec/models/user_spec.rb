require 'rails_helper'

describe User do
  let(:user) { build(:user) }
  let(:fb_user) { build(:facebook_user) }

  describe "when creating a user" do
    it "should generate an auth token when there's no provider set" do
      user.save

      expect(user.auth_token).not_to be_blank
    end

    it "should not generate an auth token when there's a provider given" do
      user.provider = "twitter"
      user.save

      expect(user.auth_token).to be_blank
    end

    it "should be invalid when creating with an invalid provider" do
      user.password = nil
      user.password_confirmation = nil
      user.provider = "instagram"
      user.uid = SecureRandom.hex(10)

      user.save

      expect(user).not_to be_valid
    end

    it "should be invalid when creating a user with no provider and email" do
      user.email = nil

      user.save

      expect(user).not_to be_valid
    end

    it "should be invalid when creating a user with no provider and no password" do
      user.password = ""
      user.password_confirmation = ""

      user.save

      expect(user).not_to be_valid
    end

    it "should be invalid when creating a user with no UID and a provider" do
      user.password = nil
      user.password_confirmation = nil
      user.encrypted_password = nil
      user.provider = "facebook"

      user.save

      expect(user).not_to be_valid
    end

    it "should be invalid when there's a password, email, provider and UID present" do
      user.provider = "facebook"
      user.uid = SecureRandom.hex(10)

      user.save

      expect(user).not_to be_valid
    end

    it "should be valid when a user tries to create an account with the same email but with a different provider" do
      fb_user.save

      expect(fb_user).to be_valid

      user.email = fb_user.reload.email
      user.provider = ""
      user.save

      expect(user).to be_valid
    end
  end

  describe "followers and following" do
    before do
      user.save
      fb_user.save
    end

    context "before following a user" do
      it "there should not be any followers" do
        expect(user.followers.count).to eq(0)
      end

      it "following? should return false" do
        expect(user.following?(fb_user)).to eq(false)
      end
    end

    context "after following a user" do
      before { user.follow(fb_user) }

      it "you should have one follower if somebody is following you" do
        expect(fb_user.followers.count).to eq(1)
      end

      it "you should have one following if you're following somebody" do
        expect(user.following.count).to eq(1)
      end

      it "following? should return true if you're following a user" do
        expect(user.following?(fb_user)).to eq(true)
      end
    end

    context "after unfollowing a user" do
      before do
        user.follow(fb_user)
        user.unfollow(fb_user)
      end

      it "you should not have any followers" do
        expect(fb_user.followers.count).to eq(0)
      end

      it "unfollowed user should not have any following" do
        expect(fb_user.following.count).to eq(0)
      end

      it "following? should return false" do
        expect(user.following?(fb_user)).to eq(false)
      end
    end
  end

  describe "profile_image method" do
    context "without a provider" do
      it "should return a small custom_profile_image" do
        user.save

        expect(user.profile_picture)
          .to eq(user.custom_profile_picture.small.url)
      end

      it "should return nil if there is no custom profile picture present" do
        user.remove_custom_profile_picture!
        user.save

        expect(user.profile_picture).to be_nil
      end
    end

    context "with a provider" do
      it 'should return the provider_profile_picture' do
        fb_user.save

        expect(fb_user.profile_picture).to eq(fb_user.provider_profile_picture)
      end

      it "should return nil if the provider profile picture is set, but the provider isn't" do
        fb_user.provider = nil

        expect(fb_user.profile_picture).to be_nil
      end
    end
  end
end
