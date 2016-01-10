module RestaurantOwners
  class GeneralInfoController < AuthorizedController

    def edit
      @info = GeneralInfoForm.new(data_for_edit)
    end

    def update
      @info = GeneralInfoForm.new(general_info_params)
      if @info.save
        redirect_to restaurants_settings_path
      else
        render :edit
      end
    end

    private

    def data_for_edit
      {
        restaurant_name: current_restaurant.name,
        owner_name: current_restaurant_owner.name,
        owner_birthday: current_restaurant_owner.birthday,
        ownership_document: current_restaurant.ownership_document,
        user: current_restaurant_owner
      }
    end

    def general_info_params
      params
        .require(:general_info_form)
        .permit(:restaurant_name,
                :owner_name,
                :owner_birthday,
                :ownership_document)
        .merge(user: current_restaurant_owner)
    end
  end
end
