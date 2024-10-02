class ReleasesController < ApplicationController

  before_action :find_playlist

  def index
    @playlist.releases
  end

  def new
    @release = @playlist.releases.new
  end

  def create
    @release = @playlist.releases.new
    permitted_params = params.require(:release).permit!
    @release.update(permitted_params)
    redirect_to edit_playlist_release_path(@playlist, @release)
  end

  def edit
    @release = @playlist.releases.friendly.find(params[:id])
  end

  def update
    @release = @playlist.releases.friendly.find(params[:id])
    permitted_params = params.require(:release).permit!
    flash[:notice] = "us"
    @release.update(permitted_params)
  end

  def destroy
    @release = @playlist.releases.friendly.find(params[:id])
    @release.destroy
    redirect_to playlist_releases_path(@playlist)
  end

  private

  def find_playlist
   @playlist = Playlist.friendly.find(params[:playlist_id])
  end

end
