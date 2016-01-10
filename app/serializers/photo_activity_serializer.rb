class PhotoActivitySerializer < ActiveModel::Serializer
  attributes :owner_id, :owner_name, :owner_type,
             :favorited, :created_at, :id, :favorites_count,
             :photo_url

  attribute :caption, key: :photo_caption

  has_one :restaurant, serializer: RestaurantPositionSerializer
  has_many :tags

  def owner_name
    object.owner.username
  end

  def photo_url
    object.image.url
  end

  def favorited
    object.fan_ids.include? scope.id
  end
end
