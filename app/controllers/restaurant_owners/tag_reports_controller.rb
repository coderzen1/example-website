module RestaurantOwners
  class TagReportsController < AuthorizedController
    def create
      @tag_report =
        current_restaurant_owner.tag_reports.create(tag_id: params[:tag_id])

      @tag_report_actions =
        TaggedPhotosFilter.new(current_restaurant, @tag_report).process_photos!
    end
  end
end
