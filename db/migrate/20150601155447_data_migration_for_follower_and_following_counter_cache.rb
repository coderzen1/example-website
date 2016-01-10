class DataMigrationForFollowerAndFollowingCounterCache < ActiveRecord::Migration
  def change
    User.all.each do |user|
      user.follower_count = user.followers.count
      user.following_count = user.following.count
      user.save!
    end
  end
end
