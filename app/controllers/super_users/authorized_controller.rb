module SuperUsers
  class AuthorizedController < ActionController::Base
    before_action :authenticate_super_user!
    layout "admin"
  end
end
