class UserSettingsController < ApplicationController
  before_action :authenticate_user!

  def show
    @section = params[:section] || "profile"
    @user = User.find_by(username: params[:user_id])
    render "index"
  end

  def index
    @section = params[:section] || "profile"
    @user = User.find_by(username: params[:user_id])
  end

  def update
    @user = User.find_by(username: params[:user_id])
    @section = params[:section]
    if @user.update(user_attributes)
      flash[:now] = "#{params[:section]} updated"
    end
  end

  private

  def user_attributes
    params.require(:user).permit(
      :username, :last_name, :first_name, :bio, :avatar, :country, :city,
      :email, :current_password,
      :new_follower_email,
      :new_follower_app,
      :repost_of_your_post_email,
      :repost_of_your_post_app,
      :new_post_by_followed_user_email,
      :new_post_by_followed_user_app,
      :like_and_plays_on_your_post_app,
      :comment_on_your_post_email,
      :comment_on_your_post_app,
      :suggested_content_email,
      :suggested_content_app,
      :new_message_email,
      :new_message_app,
      :profile_header,
      :like_and_plays_on_your_post_email,
      :tbk_commerce_code, :pst_enabled, :tbk_test_mode
    )
  end
end
