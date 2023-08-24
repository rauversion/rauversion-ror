class UserFollowsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  def followees
    @user = User.find_by(username: params[:user_id])
    @collection = @user.followees(User)
    render "index"
  end

  def followers
    @user = User.find_by(username: params[:user_id])
    @collection = @user.followers(User)
    render "index"
  end

  def create
    @user = User.find_by(username: params[:user_id])
    flash[:now] = if current_user.toggle_follow!(@user)
      "Followed"
    else
      "Unfollowed"
    end
  end
end
