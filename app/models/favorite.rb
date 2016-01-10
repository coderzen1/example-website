class Favorite < ActiveRecord::Base
  belongs_to :user
  belongs_to :faved, polymorphic: true, counter_cache: :favorites_count

  validates :user_id, uniqueness: { scope: [:faved_id, :faved_type],
                                    message: "can't fave same thing twice" }

  after_create :increment_restaurant_favorites, if: :favoriting_restaurant?
  after_destroy :decrement_restaurant_favorites, if: :favoriting_restaurant?

  private

  def favoriting_restaurant?
    faved.is_a?(Restaurant)
  end

  def increment_restaurant_favorites
    User.increment_counter(:favorite_restaurants_count, user_id)
  end

  def decrement_restaurant_favorites
    User.decrement_counter(:favorite_restaurants_count, user_id)
  end
end
