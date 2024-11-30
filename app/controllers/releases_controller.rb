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
    flash.now[:notice] = "us"
    @release.update(permitted_params)
    render "edit", status: 422
  end

  def destroy
    @release = @playlist.releases.friendly.find(params[:id])
    @release.destroy
    redirect_to playlist_releases_path(@playlist)
  end

  private

  def find_playlist
    @playlist = Playlist
      .where(user_id: current_user.id)
      .or(Playlist.where(label_id: current_user.id))
      .friendly.find(params[:playlist_id])

    render status: :not_found and return if @playlist.blank?
  end

end
