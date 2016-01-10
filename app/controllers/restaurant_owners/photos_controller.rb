# Controller for RestaurantOwner photos
module RestaurantOwners
  class PhotosController < AuthorizedController
    def index
      @photos =
        current_restaurant
        .food_photos
        .approved
        .includes(:photo_reports)
        .paginate(page: params[:page], per_page: 1)
        .decorate
    end

    def new
      @photo = Photo.new
    end

    def create
      @photo = current_restaurant.food_photos.new(photo_params)
      if @photo.save
        redirect_to restaurants_photos_path
      else
        render :new
      end
    end

    private

    def photo_params
      params.require(:photo).permit(:caption, :image)
    end
  end
end
