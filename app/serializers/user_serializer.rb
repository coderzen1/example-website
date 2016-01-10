class UserSerializer < ActiveModel::Serializer
  attributes :username, :email, :auth_token, :id,
             :provider, :uid, :profile_picture, :location, :radius,
             :private_faved_photos, :follower_count, :following_count,
             :faved_restaurants_count

  def faved_restaurants_count
    object.favorite_restaurants_count
  end
end
