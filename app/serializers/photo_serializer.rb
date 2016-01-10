class PhotoSerializer < ActiveModel::Serializer
  attributes :owner_id, :owner_type, :owner_name, :owner_profile_picture,
             :id, :photo_url, :created_at, :favorited,
             :favorites_count

  attribute :caption, key: :photo_caption
  has_many :tags
  has_one :restaurant, serializer: RestaurantPositionSerializer

  def owner_name
    object.owner.username
  end

  def owner_profile_picture
    object.owner.profile_picture
  end

  def photo_url
    object.image.url
  end

  def favorited
    object.fan_ids.include? scope.id
  end
end
