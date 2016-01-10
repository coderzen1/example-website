class Relationship < ActiveRecord::Base
  belongs_to :follower, class_name: User, counter_cache: :following_count
  belongs_to :followed, class_name: User, counter_cache: :follower_count

  validates :follower_id, uniqueness: { scope: :followed_id }
end
