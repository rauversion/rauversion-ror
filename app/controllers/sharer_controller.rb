class SharerController < ApplicationController

  before_action :authenticate_user!, except: [:index, :show ]

  def new
    @resource, @resource_path = find_resource

    @button_class = "button"
  end

  def find_resource
    if params[:track_id]
      resource = Track.friendly.find(params[:track_id])
      [ resource, track_embed_url(resource)]
    elsif params[:playlist_id]
      resource = Playlist.friendly.find(params[:playlist_id])
      [ resource, playlist_embed_url(resource)]
    end
  end
end
