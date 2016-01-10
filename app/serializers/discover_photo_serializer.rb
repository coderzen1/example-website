class DiscoverPhotoSerializer < ActiveModel::Serializer
  attributes :id, :image, :restaurant_id,
             :restaurant_name, :favorites_count, :rating
end
