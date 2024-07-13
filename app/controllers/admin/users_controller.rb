class Admin::UsersController < Backstage::Rails::BaseController

  private

  def model_class
    User
  end

  def permitted_params
    params.require(:user).permit(:email, :username, :role, :editor)
  end
end