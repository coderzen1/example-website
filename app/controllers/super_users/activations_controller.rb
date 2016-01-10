module SuperUsers
  class ActivationsController < AuthorizedController
    def index
      @restaurant_owners = RestaurantOwner.not_verified
    end

    def approve
      RestaurantOwner.find(params[:id]).verified!
    end

    def reject
      @restaurant = RestaurantOwner.find(params[:id]).restaurant
      @restaurant.ownership_document = nil
      @restaurant.save
    end

    def delete_owner
      RestaurantOwner.find(params[:id]).destroy
    end
  end
end
