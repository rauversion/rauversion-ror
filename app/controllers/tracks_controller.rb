class TracksController < ApplicationController

  before_action :authenticate_user!, except: [:index, :show, :private_access ]

  def index
    @tracks = Track.published.order("id desc")
    .with_attached_cover
    .includes(user: { avatar_attachment: :blob })
    .page(params[:page]).per(12)
  end

  def new
    #@track = current_user.tracks.new
    #@track.step = "upload"
    @track_form = TrackBulkCreator.new
    @track_form.step = "upload"
  end

  def create

    @track_form = TrackBulkCreator.new()
    @track_form.step = track_bulk_params[:step]

    if @track_form.step == "upload"
      audios = track_bulk_params["audio"].select{|o| o.is_a?(String)}.reject(&:empty?)
      #@track = current_user.tracks.new(track_params)
      @track_form.user = current_user
      @track_form.tracks_attributes = audios.map{|o| {audio: o} }
      @track_form.step = "info"
    else
      @track_form.tracks_attributes_objects = track_bulk_params[:tracks_attributes]
      @track_form.user = current_user
      @track_form.save
      if @track_form.errors.blank?
        @track_form.step = "share"
      else
      end
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
    if params[:nonpersist]
      @track.assign_attributes(track_params)
      @track.valid?
    else
      flash.now[:notice] = "Track was successfully updated."
      @track.update(track_params)
    end
    # puts @track.errors.as_json
    @track.tab = @tab
  end

  def private_access
    @track = Track.find_signed(params[:id])
    get_meta_tags
    render "show"
  end

  def show
    @track = Track.friendly.find(params[:id])
    get_meta_tags
  end

  def destroy
    @track = current_user.tracks.friendly.find(params[:id])
    @track.destroy
  end

  def get_meta_tags
    @supporters = []
    set_meta_tags(
      # title: @track.title,
      # description: @track.description,
      keywords: @track.tags.join(", "),
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

    @oembed_json = private_oembed_track_url(track_id: @track, format: :json)
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
      :copyright, :attribution, :noncommercial, :copies,
      tags: []
    )
  end

  def track_bulk_params
    params.require(:track_bulk_creator).permit(
      :make_playlist, :private,
      :step, 
      audio: [], tracks_attributes: [
        :audio, :cover, :title, :tags, :description
      ] 
    )
  end
end
