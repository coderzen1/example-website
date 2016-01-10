module Instagram
  class MediaItem
    attr_reader :item

    def initialize(item)
      @item = item
    end

    def restaurant_name
      item.location.name if item.location?
    end

    def image_url
      item.images.standard_resolution.url
    end

    def to_json
      {
        restaurant_name: restaurant_name,
        image_url: image_url
      }
    end
  end
end
