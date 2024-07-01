class PodcastsController < ApplicationController


  def show
    @user = User.find_by(username: params[:user_id])
  end

  def edit
    @user = User.find_by(username: params[:user_id])
    @info = @user.podcaster_info || @user.build_podcaster_info
  end

  def update
    @user = User.find_by(username: params[:user_id])
    @info = @user.podcaster_info || @user.build_podcaster_info
    @info.update(podcaster_params)
    redirect_to user_podcast_path(@user.username)
  end


  def create
    @user = User.find_by(username: params[:user_id])
    @info = @user.podcaster_info || @user.build_podcaster_info
    @info.update(podcaster_params)
    redirect_to user_podcast_path(@user.username)
  end


  private

  def podcaster_params
    params.require(:podcaster_info).permit(:about, :title, :description)
  end
end
