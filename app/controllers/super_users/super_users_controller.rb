module SuperUsers
  class SuperUsersController < AuthorizedController
    respond_to :html, :js

    def index
      @super_users = SuperUser.all
    end

    def create
      @super_user = SuperUser.new(super_user_params)
      @super_user.save
      respond_with @super_user, location: admin_super_users_path
    end

    def new
      @super_user = SuperUser.new
    end

    def edit
      @super_user = SuperUser.find(params[:id])
    end

    def update
      @super_user = SuperUser.find(params[:id])
      @super_user.update(super_user_params)
      respond_with @super_user, location: admin_super_users_path
    end

    def destroy
      @super_user = SuperUser.find(params[:id])
      @super_user.destroy
    end

    private

    def super_user_params
      params.require(:super_user).permit(:email, :password, :role)
    end
  end
end
