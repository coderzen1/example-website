module SuperUsers
  class RestaurantOwnersController < AuthorizedController
    def index
      @q = RestaurantOwner.ransack(params[:q])
      @restaurant_owners = @q.result.paginate(page: params[:page], per_page: 8)
    end
  end
end
