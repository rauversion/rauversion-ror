class LikesController < ApplicationController

  before_action :check_user

  def create
    @resource = find_resource
    @button_class = current_user.toggle_like!(@resource) ? "button-active" : "button"
  end

  private

  def find_resource
    if params[:track_id]
      @resource = Track.friendly.find(params[:track_id])
    elsif params[:playlist_id]
      @resource = Playlist.friendly.find(params[:playlist_id])
    end
  end

  def check_user
    redirect_to new_user_session_path and return if current_user.blank?
  end

   
end
