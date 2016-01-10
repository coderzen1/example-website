class RegistrationsController < Devise::RegistrationsController
  protected

  def after_sign_up_path_for(resource)
    restaurants_signup_path(id: "restaurant_info")
  end
end
