module RestaurantOwners
  class LocationController < AuthorizedController
    respond_to :js, :html
    def index
      @restaurant = current_restaurant.decorate
    end

    def new
      @restaurant = current_restaurant.decorate
    end

    def edit
      @restaurant = Restaurant.find(params[:id]).decorate
    end

    def update
      @restaurant = Restaurant.find(params[:id]).decorate
      @restaurant.update(location_params)
    end

    private

    def location_params
      params.require(:restaurant)
        .permit(:lat, :lng, address_attributes: [:address, :zip_code, :city, :state, :country])
    end
  end
end
