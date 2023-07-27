class PlaylistsController < ApplicationController

  def index
  end

  def show
    @playlist = current_user.playlists.friendly.find(params[:id])
    @track = @playlist.tracks.first
  end

  def edit
    @tab = params[:tab] || "basic-info-tab"
    @playlist = current_user.playlists.friendly.find(params[:id])
  end

  def new
    track = Track.friendly.find(params[:track_id])
    @playlist = current_user.playlists.new
    @playlist.track_playlists << TrackPlaylist.new(track: track)
  end

  def create
    @tab = params[:tab] || "basic-info-tab"
    @playlist = current_user.playlists.create(playlist_params)
    if @playlist.errors.blank?
      flash[:now] = "successfully created"
    end
  end

  def update
    @tab = params[:tab] || "basic-info-tab"
    @playlist = current_user.playlists.friendly.find(params[:id])
    
    if !params[:nonpersist] && @playlist.update(playlist_params) 
      flash[:now] = "successfully created"
    end

    if params[:nonpersist] 
      @playlist.assign_attributes(playlist_params) 
    end
  end

  def destroy
  end

  def playlist_params
    params.require(:playlist).permit(
      :title, :description, :private, :price, 
      :playlist_type, :release_date, :cover,
      :record_label, :buy_link,
      :copyright,
      :attribution, :noncommercial, :non_derivative_works, :copies,
      track_playlists_attributes: [
        :track_id
      ]
    )
  end
end
