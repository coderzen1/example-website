#  Controller for SignUp
module RestaurantOwners
  class SignupController < AuthorizedController
    layout 'devise'
    include Wicked::Wizard

    steps :restaurant_info, :owner_additional_info, :restaurant_location_info
    skip_before_action :force_finishing_registration!

    def show
      @form = initialize_form
      render_wizard
    end

    def update
      @form = initialize_form

      render_wizard @form
    end

    private

    def finish_wizard_path
      restaurants_root_path
    end

    def initialize_form
      case step
      when :restaurant_info
        RestaurantInfo.new(restaurant_params)
      when :owner_additional_info
        current_restaurant_owner.assign_attributes(owner_additional_params)
        current_restaurant_owner
      when :restaurant_location_info
        RestaurantLocationInfo.new(restaurant_location_params)
      end
    end

    def restaurant_params
      params.fetch(:restaurant_info, {})
        .permit(:restaurant_name,
                :owner_name,
                :owner_birth)
        .merge(user: current_restaurant_owner)
    end

    def owner_additional_params
      params.fetch(:owner_additional_info, {})
        .permit(
          :phone, :website, address_attributes:
          [:address, :zip_code, :city, :state, :country]
        ).merge(registration_status: :restaurant_location_info)
    end

    def restaurant_location_params
      params.fetch(:restaurant_location_info, {})
        .permit(
          :lat, :lng, address_attributes:
          [:address, :zip_code, :city, :state, :country]
        ).merge(user: current_restaurant_owner,
                restaurant: current_restaurant_owner.restaurant)
    end
  end
end
