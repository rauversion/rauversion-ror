class LikesController < ApplicationController
  def create
    @resource = find_resource
    @button_class = current_user.toggle_like!(@resource) ? "button-active" : "button"
  end

  def find_resource
    if params[:track_id]
      @resource = Track.friendly.find(params[:track_id])
    elsif params[:playlist_id]
      @resource = Playlist.friendly.find(params[:playlist_id])
    end
  end
end
