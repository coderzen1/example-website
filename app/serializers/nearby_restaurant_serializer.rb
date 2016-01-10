class NearbyRestaurantSerializer < ActiveModel::Serializer
  attributes :id, :name, :photo, :distance

  attribute :formatted_address, key: :address
end
