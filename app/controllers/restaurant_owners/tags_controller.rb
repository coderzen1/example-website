module RestaurantOwners
  class TagsController < AuthorizedController
    def index
      @tags = current_restaurant.food_photos.all_tags.paginate(page: params[:page], per_page: 1)
    end
  end
end
