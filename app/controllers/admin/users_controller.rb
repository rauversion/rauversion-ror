class Admin::UsersController < Admin::BaseController
  include AdminControllerConcern

  private

  def model_class
    User
  end

  def permitted_params
    params.require(:user).permit(:email, :username, :role, :editor)
  end
end