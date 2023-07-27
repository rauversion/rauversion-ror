class UserFollowsController < ApplicationController

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
    if current_user.toggle_follow!(@user)
      flash[:now] = "Followed"
    else
      flash[:now] = "Unfollowed"
    end
  end
end
