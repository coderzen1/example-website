module Instagram
  class RecentMedia
    attr_reader :feed

    def initialize(instagram_user_id)
      @feed = itemize(Instagram.user_recent_media(instagram_user_id, { count: 50 }))
    end

    def items_with_location_present
      feed.reject { |item| item.restaurant_name.nil? }
    end

    def items_with_location_present_in_json
      items_with_location_present.map(&:to_json)
    end

    private

    def itemize(feed_items)
      feed_items.map { |item| MediaItem.new(item) }
    end
  end
end
