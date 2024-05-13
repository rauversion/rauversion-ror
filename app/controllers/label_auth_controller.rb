class LabelAuthController < ApplicationController
  before_action :authenticate_user!

  # Assuming `User` model and `Accounts` is a service object that contains user related queries
  # and `is_child_of?` is a method defined within your User model or an associated service.

  def add
    username = params[:username]
    user = User.get_user_by_username(username)

    if current_user.is_child_of?(user.id)
      sign_in(:user, user) # Devise's sign_in helper
      session[:parent_user] = current_user.id
      redirect_to "/#{user.username}"
    else
      flash[:error] = "Not allowed"
      redirect_to "/#{current_user.username}"
    end
  end

  def back
    username = params[:username]
    user = User.get_user_by_username(username)

    if user.is_child_of?(current_user.id)
      sign_in(:user, user) # Devise's sign_in helper
      session[:parent_user] = nil
      redirect_to "/#{user.username}"
    else
      flash[:error] = "Not allowed"
      redirect_to "/#{current_user.username}"
    end
  end
end