class UserRelationshipSerializer < ActiveModel::Serializer
  attributes :id, :username, :profile_picture, :following_this_user,
             :location

  def faved_restaurants_count
    object.favorite_restaurants.count
  end

  def following_this_user
    scope.following? object
  end
end
