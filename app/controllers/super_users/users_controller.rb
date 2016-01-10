module SuperUsers
  class UsersController < AuthorizedController
    def index
      @q = get_users.ransack(params[:q])
      @users = @q.result.paginate(page: params[:page], per_page: 8)
    end

    def destroy
      User.find(params[:id]).deleted!
    end

    def lock
      User.find(params[:id]).locked!
    end

    def restore
      User.find(params[:id]).normal!
    end

    def unlock
      User.find(params[:id]).normal!
    end

    private

    def get_users
      return User.normal if params[:status].blank?

      if params[:status] == "flagged"
        User.flagged
      else
        User.where(status: User.statuses[params[:status]])
      end
    end
  end
end
