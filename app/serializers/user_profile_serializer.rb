class UserProfileSerializer < ActiveModel::Serializer
  attributes :username, :email, :id,
             :profile_picture, :location, :radius,
             :private_faved_photos, :follower_count, :following_count,
             :faved_restaurants_count, :following_this_user

  def faved_restaurants_count
    object.favorite_restaurants.count
  end

  def following_this_user
    scope.following?(object)
  end
end
