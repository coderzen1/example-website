class RestaurantPositionSerializer < ActiveModel::Serializer
  attributes :id, :name, :lat, :lng
end
