class RestaurantSerializer < ActiveModel::Serializer
  attributes :id, :name, :lat, :lng,
             :photo, :favorites_count,
             :email, :website, :phone_number, :favorited

  attribute :formatted_address, key: :address

  def favorited
    object.fan_ids.include? scope.id
  end
end
