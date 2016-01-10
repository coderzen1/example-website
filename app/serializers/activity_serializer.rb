class ActivitySerializer < ActiveModel::Serializer
  attributes :id, :owner_id, :owner_name, :owner_type, :owner_profile_picture,
             :photo_url, :favorited, :tags, :created_at, :favorites_count,
             :restaurant

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

  def owner_profile_picture
    object.owner.profile_picture
  end
end
