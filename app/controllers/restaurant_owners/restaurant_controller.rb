module RestaurantOwners
  class RestaurantController < AuthorizedController
    respond_to :js, :html
    def edit
      @restaurant = Restaurant.find(params[:id])
    end

    def update
      @restaurant = Restaurant.find(params[:id])
      @restaurant.update(restaurant_params)
      respond_with @restaurant, location: restaurants_settings_path
    end

    private

    def restaurant_params
      params.require(:restaurant)
        .permit(:email, :phone_number, :website,
          address_attributes: [:address, :zip_code, :city, :state, :country])
    end
  end
end
