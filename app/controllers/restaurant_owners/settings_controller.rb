module RestaurantOwners
  class SettingsController < AuthorizedController
    layout 'settings'

    def index
      @restaurant = current_restaurant.decorate
    end

    def edit_general_info
      @info = GeneralInfoForm.new
    end

    # def update_general_info
    #   binding.pry
    # end
    #
    # private
    #
    # def general_info_params
    # end
  end
end
