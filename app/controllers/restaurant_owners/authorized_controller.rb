module RestaurantOwners
  class AuthorizedController < ActionController::Base
    before_action :authenticate_restaurant_owner!
    before_action :force_finishing_registration!,
                  unless: "current_restaurant_owner && current_restaurant_owner.finished?"

    layout "authorized"

    private

    def force_finishing_registration!
      redirect_to restaurants_signup_path(
        id: current_restaurant_owner.registration_status
      )
    end

    def current_restaurant
      @current_restaurant ||= current_restaurant_owner.restaurant
    end
    helper_method :current_restaurant
  end
end
