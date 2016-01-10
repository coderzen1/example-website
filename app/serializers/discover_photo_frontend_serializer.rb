# This shouldn't be named liked this - everything else
# should be namespaced in the serializers folder.
class DiscoverPhotoFrontendSerializer < ActiveModel::Serializer
  attributes :image_url, :restaurant_name

  def image_url
    object.image.url
  end
end
