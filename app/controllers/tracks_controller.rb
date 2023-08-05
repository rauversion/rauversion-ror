class TracksController < ApplicationController

  def index
    @tracks = Track.published.page(params[:page]).per(10)
  end

  def new
    @track = current_user.tracks.new
    @track.step = "upload"
  end

  def create
    @track = current_user.tracks.new(track_params)
    if @track.step == "upload"
      @track.step = "info"
    else
      @track.save
      @track.step = "share"
    end
  end

  def edit
    @track = current_user.tracks.friendly.find(params[:id])
    @tab = params[:tab] || "basic-info-tab"
    @track.tab = @tab
  end

  def update
    @track = current_user.tracks.friendly.find(params[:id])
    @tab = params[:track][:tab] || "basic-info-tab"
    @track.update(track_params)
    puts @track.errors.as_json
    @track.tab = @tab
    flash.now[:notice] = "Track was successfully updated."
  end

  def show
    @track = Track.friendly.find(params[:id])

    set_meta_tags(
      title: @track.title,
      description: @track.description,
      keywords: "",
      # url: Routes.articles_show_url(socket, :show, track.id),
      title: "#{@track.title} on Rauversion",
      description: "Stream #{@track.title} by #{@track.user.username} on Rauversion.",
      image: @track.cover_url(:small),
      "twitter:player": track_embed_url(@track),
      twitter: {
        card: "player",
        player: {
          stream: @track.mp3_audio&.url,
          "stream:content_type": "audio/mpeg",
          width: 290,
          height: 58
        }
      }
    )
  end

  def destroy
    @track = current_user.tracks.friendly.find(params[:id])
    @track.destroy
  end

  def track_params
    params.require(:track).permit(
      :private,
      :audio, :title, :step, :description,
      :tab, :genre, :contains_music, :artist, :publisher, :isrc, 
      :composer, :release_title, :buy_link, :album_title, 
      :record_label, :release_date, :barcode, 
      :iswc, :p_line,
      :price, :name_your_price,
      :direct_download, :display_embed, :enable_comments, 
      :display_comments, :display_stats, :include_in_rss, 
      :offline_listening, :enable_app_playblack,
      :cover,
      tags: []
    )
  end
end
