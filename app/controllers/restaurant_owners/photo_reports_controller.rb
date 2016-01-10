module RestaurantOwners
  class PhotoReportsController < AuthorizedController
    def create
      @report = current_restaurant_owner.photo_reports.create(photo_id: params[:photo_id])
    end
  end
end
