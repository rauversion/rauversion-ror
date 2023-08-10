class TrackPlaylistsController < ApplicationController

  before_action :authenticate_user!

  def create
    @track_playlist = TrackPlaylist.new(build_params)
    @track_playlist.save
    # TODO: VALIDATE FOR USER , like @track_playlist.validate_for_user = true ; @track_playlist.save
  end

  def destroy
    @playlist = current_user.playlists.friendly.find(params[:id])
    @track = @playlist.tracks.find(params[:track_id])
    @track_playlist = @playlist.track_playlists.find_by(track_id: @track)
    @track_playlist.destroy
  end

  def build_params
    params.require(:track_playlist).permit(:id, :track_id, :playlist_id)
  end
  
end
