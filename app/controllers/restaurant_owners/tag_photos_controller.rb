module RestaurantOwners
  class TagPhotosController < AuthorizedController
    def index
      @photos = current_restaurant.food_photos.tagged_with(params[:id])
      @tag = TagDecorator.decorate(ActsAsTaggableOn::Tag.find_by(name:params[:id]))
    end
  end
end
