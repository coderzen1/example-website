module RestaurantOwners
  class BasicInfoController < AuthorizedController
    def index
      @restaurant = current_restaurant
    end

    def new

    end

    def create
      @restaurant = current_restaurant
    end

    def edit
      @restaurant = current_restaurant
    end
  end
end
