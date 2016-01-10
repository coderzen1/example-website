module RestaurantOwners
  class TaggedPhotosFilter
    def initialize(restaurant, tag_report)
      @restaurant = restaurant
      @tag_report = tag_report
      @tag = tag_report.tag
    end

    def process_photos!
      remove_tag_from_photos_with_multiple_tags

      wrap_photos_with_single_tag_in_report_action
    end

    private

    attr_reader :tag, :restaurant, :tag_report

    def wrap_photos_with_single_tag_in_report_action
      single_tag_photos.map do |photo|
        tag_report.tag_report_actions.build(photo: photo)
      end
    end

    def remove_tag_from_photos_with_multiple_tags
      multiple_tag_photos.each do |photo|
        photo.tag_list.remove(tag.name)
        photo.save
      end
    end

    def single_tag_photos
      @single_tag_photos ||= photos.select { |p| p.tags.length == 1 }
    end

    def multiple_tag_photos
      @multiple_tag_photos ||= photos.select { |p| p.tags.length > 1 }
    end

    def photos
      @photos ||= restaurant.food_photos.includes(:tags).tagged_with(tag).to_a
    end
  end
end
