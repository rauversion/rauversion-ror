class EmbedsController < ApplicationController
  layout "embed"

  def show
    @track = Track.friendly.find(params[:track_id]) if params[:track_id].present?
    @playlist = Playlist.friendly.find(params[:playlist_id]) if params[:playlist_id].present?
  end
end
