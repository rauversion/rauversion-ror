class PodcastsController < ApplicationController

  before_action :find_user
  before_action :unset_user_menu
  before_action :disable_footer

  def index
    @collection = @user.tracks.published.podcasts.page(params[:page]).per(10)
  end

  def show
    @podcast = @user.tracks.published.podcasts.friendly.find(params[:id])
  end

  def about
  end

  private

  def unset_user_menu
    @disable_user_menu = true
  end

  def find_user
    @user = User.find_by(username: params[:user_id])
  end

  def podcaster_params
    params.require(:podcaster_info).permit(:about, :title, :description)
  end
end
