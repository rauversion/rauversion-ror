class PlaylistsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  def index
  end

  def show
    if current_user
      begin
        @playlist = current_user.playlists.friendly.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        nil
      end
    end

    @playlist ||= Playlist.published.friendly.find(params[:id])
    @track = @playlist.tracks.first

    metatags = {
      title: @playlist.title,
      description: @playlist.description,
      keywords: "",
      # url: Routes.articles_show_url(socket, :show, playlist.id),
      title: "#{@playlist.title} on Rauversion",
      description: "Stream #{@playlist.title} by #{@playlist.user.username} on Rauversion.",
      image: @playlist.cover_url(:small),
      "twitter:player": playlist_embed_url(@playlist)
    }

    metatags.merge!({
      twitter: {
        card: "player",
        player: {
          stream: @playlist.tracks&.first&.mp3_audio&.url,
          "stream:content_type": "audio/mpeg",
          width: 290,
          height: 58
        }
      }
    })
    set_meta_tags(metatags)
  end

  def edit
    @tab = params[:tab] || "basic-info-tab"
    @playlist = current_user.playlists.friendly.find(params[:id])
    @playlist.enable_label = @playlist.label_id.present?
  end

  def new
    @tab = params[:tab]
    @track = Track.friendly.find(params[:track_id])
    @playlist = current_user.playlists.new
    @playlist.track_playlists << TrackPlaylist.new(track: @track)
  end

  def create
    @tab = params[:tab] || "basic-info-tab"
    @playlist = current_user.playlists.create(playlist_params)
    if @playlist
      flash.now[:notice] = "successfully created"
    else
      flash.now[:error] = "error in creating"
    end
  end

  def update
    @tab = params[:tab] || "basic-info-tab"
    @playlist = current_user.playlists.friendly.find(params[:id])

    @playlist.assign_attributes(playlist_params)

    if !params[:nonpersist] && @playlist.save
      flash.now[:notice] = "successfully updated"
    else
      flash.now[:error] = "error updating playlist"
    end
  
    if params[:nonpersist]
      @playlist.assign_attributes(playlist_params)
    end
  end

  def destroy
  end

  def playlist_params
    params.require(:playlist).permit(
      :id,
      :title, :description, :private, :price,
      :playlist_type, :release_date, :cover,
      :record_label, :buy_link,
      :enable_label,
      :copyright,
      :attribution, :noncommercial, :non_derivative_works, :copies,
      track_playlists_attributes: [
        :id,
        :_destroy,
        :track_id
      ]
    )
  end

  def sort
    @tab = params[:tab] || "tracks-tab"
    @playlist = current_user.playlists.friendly.find(params[:id])
    id = params.dig("section", "id")
    position = params.dig("section", "position")

    collection = @playlist.track_playlists.find(id)
    collection.insert_at(position)

    flash[:now] = "successfully updated"

    render "update"

  end
end
