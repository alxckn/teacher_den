class User::ProfileController < User::UserController
  def index
    @user = current_user
  end
end
